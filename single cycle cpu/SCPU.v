module sccpu( clk, rst, instr, readdata, PC, MemWrite, aluout, writedata, reg_sel, reg_data);  
         
   input      clk;          // clock
   input      rst;          // reset
   
   input [31:0]  instr;     // instruction
   input [31:0]  readdata;  // data from data memory
   
   output [31:0] PC;        // PC address
   output        MemWrite;  // write memory or not

   output [31:0] aluout;    // ALU output
   output [31:0] writedata; // data to data memory
   
   input  [4:0] reg_sel;    // register selection (for debug use)
   output [31:0] reg_data;  // selected register data (for debug use)
   
   wire        RegWrite;    // control signal to register write
   wire        EXTOp;       // control signal to signed extension
   wire [4:0]  ALUOp;       // ALU opertion
   wire [1:0]  NPCOp;       // next PC operation

   wire [1:0]  WDSel;       // (register) write data selection
   wire [1:0]  GPRSel;      // general purpose register selection
   wire        ALUSrc;      // ALU source (choose_signal) for B
   wire        ARegSel;     // ALU sourec (choose_signal)  for A
   wire        Zero;        // ALU ouput zero

   wire [31:0] NPC;         // next PC

   wire [4:0]  rs;          // rs
   wire [4:0]  rt;          // rt
   wire [4:0]  rd;          // rd
   wire [5:0]  Op;          // opcode
   wire [5:0]  Funct;       // funct
   wire [31:0] shamt;
   wire [15:0] Imm16;       // 16-bit immediate
   wire [31:0] Imm32;       // 32-bit immediate
   wire [25:0] IMM;         // 26-bit immediate (address)
   wire [4:0]  A3;          // register address for write
   wire [31:0] WD;          // register write data
   wire [31:0] RD1;         // register data specified by rs
   wire [31:0] B;           // operator for ALU B
   wire [31:0] A;



   assign Op = instr[31:26];  // instruction
   assign Funct = instr[5:0]; // funct
   assign rs = instr[25:21];  // rs
   assign rt = instr[20:16];  // rt
   assign rd = instr[15:11];  // rd

   assign shamt = {27'b0, instr[10:6]};

   assign Imm16 = instr[15:0];// 16-bit immediate
   assign IMM = instr[25:0];  // 26-bit immediate
   
   
   // instantiation of control unit
   ctrl U_CTRL ( 
      .Op(Op), .Funct(Funct), .Zero(Zero),

      .RegWrite(RegWrite), .MemWrite(MemWrite),
      .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), 
      .ALUSrc(ALUSrc), .GPRSel(GPRSel), .WDSel(WDSel), .ARegSel(ARegSel)
   );
   
   //* instantiation of ALU 
   alu U_ALU ( //C comes out of ALU as the  "aluout"
      .A(A), .B(B), .ALUOp(ALUOp), .C(aluout), .Zero(Zero)
   ); 

   //* instantiation of PC
   PC U_PC (
      .clk(clk), .rst(rst), .NPC(NPC), .PC(PC)
   ); 
   
   //* instantiation of NPC
   NPC U_NPC ( 
      .PC(PC), .NPCOp(NPCOp),.PCJR(RD1), .IMM(IMM), .NPC(NPC)
   );

   //* mux for signed extension or zero extension
   EXT U_EXT ( 
      .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) 
   );
   
   //* instantiation of register file
   RF U_RF (
      .clk(clk), .rst(rst), .RFWr(RegWrite),  //RegWrite->RFWr
      .A1(rs), .A2(rt), .A3(A3), //Write register's address->A3
      .WD(WD), 
      .RD1(RD1),
      .RD2(writedata),//RD2->writedata->mux(ALU_B)->DM
      .reg_sel(reg_sel),//for debug
      .reg_data(reg_data) //for debug 
   );
   
   // mux for (address for write to Register File)
   mux4 #(5) U_MUX4_GPR_A3 (
      .d0(rd), .d1(rt), .d2(5'b11111), .d3(5'b0), //d0:00, d1:01, d1:10, d2:10($ra is $31), d3:11(do not write RF)
      .s(GPRSel),
      .y(A3)
   );
   
   // mux for RF's Data to write 
   mux4 #(32) U_MUX4_GPR_WD (
      .d0(aluout),   //aluout(C)->writeData
      .d1(readdata), //from dataMemory
      .d2(PC + 4),  //i_jalr(when not providing $rd explicitly in the instrution,( pc+4  ) send to $31($ra) defaultly
      .d3(32'b0),  //do not write data to RF
      .s(WDSel), 
      .y(WD)
   );


   //* mux for ALU B---upper
   mux2 #(32) U_MUX_ALU_B (
      .d0(writedata), //RD2
      .d1(Imm32), 
      .s(ALUSrc), 
      .y(B)
   );   
   //* mux for ALU A---lower
   mux2 #(32) U_MUX_ALU_A( //C=B<<A
     .d0(RD1), .d1(shamt), 
     .s(ARegSel), 
     .y(A)
   );

       

endmodule