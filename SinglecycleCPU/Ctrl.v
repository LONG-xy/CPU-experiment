

 `include "ctrl_encode_def.v"

module ctrl(Op, Funct, Zero, 
            RegWrite, MemWrite,
            EXTOp, ALUOp, NPCOp, 
            ALUSrc, GPRSel, WDSel, ARegSel
            );
            
   input  [5:0] Op;       // opcode
   input  [5:0] Funct;    // funct
   input        Zero;
   
   output       RegWrite; // control signal for register write
   output       MemWrite; // control signal for memory write
   output       EXTOp;    // control signal to signed extension

   output [4:0] ALUOp;    // ALU opertion

   output [1:0] NPCOp;    // next pc operation
   output       ALUSrc;   // ALU source for B (choose signal)
   output       ARegSel;  // ALU source for A (choose signal)

   output [1:0] GPRSel;   // general purpose register selection (to write the destination data)

   output [1:0] WDSel;    // (register) write data selection



  // r format
   wire rtype  = ~|Op; // every bit fist:or ,then: not, the answer is just one bit;

   wire i_add  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // add(100 000)
   wire i_sub  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // sub
   wire i_and  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // and
   wire i_or   = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]& Funct[0]; // or
   wire i_slt  = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // slt
   wire i_sltu = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // sltu
   wire i_addu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // addu
   wire i_subu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // subu
   wire i_jr   = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; //jr 001000
   wire i_jalr = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; //jalr 001001
   wire i_nor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; //nor 100111
   wire i_sll  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; //sll 000000
   wire i_srl  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; //srl 000010
   wire i_sra  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; //sra 000011
   wire i_srav = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; //srav 000111
   wire i_sllv = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; //sllv 000100
   wire i_srlv = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]&~Funct[0]; //srlv 000110
   wire i_xor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]&~Funct[0]; 

  // i format
   wire i_addi = ~Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; // addi
   wire i_ori  = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]& Op[0]; // ori
   wire i_lw   =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lw
   wire i_sw   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sw
   wire i_beq  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // beq
   wire i_bne  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0]; //bne 000101
   wire i_slti = ~Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]&~Op[0]; //slti 001010
   wire i_lui  = ~Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0]; //lui 001111
   wire i_andi = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]&~Op[0]; 
   wire i_lb   =  Op[5]&~Op[4]&~Op[3]&~Op[2]&~Op[1]&~Op[0]; 
   wire i_lh   =  Op[5]&~Op[4]&~Op[3]&~Op[2]&~Op[1]& Op[0]; 
   wire i_lbu  =  Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; 
   wire i_lhu  =  Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0]; 
   wire i_sb   =  Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; 
   wire i_sh   =  Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]& Op[0]; 
   
  // j format
   wire i_j    = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]&~Op[0];  // j
   wire i_jal  = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0];  // jal
  

  // generate control signals
  assign RegWrite   = rtype | i_lw | i_addi | i_ori | i_jal | i_jalr | i_slti | i_lui | i_andi | i_lb | i_lh | i_lbu | i_lhu | i_sb | i_sh ; // register write
  
   assign MemWrite   = i_sw |i_sb |i_sh;                           // memory write



  assign ALUSrc     = i_lb | i_lbu |i_lh | i_lhu |i_sb |i_sh| i_lw | i_sw | i_addi | i_ori | i_slti | i_lui | i_andi ;  // ALUsrc == 1: ALU's operand B is froms instruction immediate/offset

  assign ARegSel    = i_sll | i_srl | i_sra; //ARegSel == 1 :ALU's operand A froms shamt

  assign EXTOp      = i_addi | i_lw | i_sw |  i_slti | i_sltu |i_lb | i_lh | i_sb |i_sh| i_lbu |i_lhu  ;           // signed extension



  // GPRSel_RD   2'b00--R TYPE defalut
  // GPRSel_RT   2'b01---the destination operator is in [rt]
  // GPRSel_31   2'b10---the destination operator is in $ra

  assign GPRSel[0] = i_lb | i_lbu | i_lh |i_lhu |i_lw | i_addi | i_ori  | i_lui | i_andi | i_slti ;
  assign GPRSel[1] = i_jal | i_jalr;
  
  // WDSel_FromALU 2'b00
  // WDSel_FromMEM 2'b01
  // WDSel_FromPC  2'b10 

 assign WDSel[0] = i_lb | i_lbu | i_lh | i_lhu | i_lw;
 assign WDSel[1] = i_jal | i_jalr;

  // NPC_PLUS4   2'b00
  // NPC_BRANCH  2'b01
  // NPC_JUMP    2'b10
  // NPC_JR      2'b11
  assign NPCOp[0] = (i_beq & Zero) | (i_bne & ~Zero) | i_jr | i_jalr; //beq,bne == 01
  assign NPCOp[1] = i_j | i_jal | i_jr | i_jalr;//j, jal == 10
  //jr, jalr: 11
  
/*
`define ALU_NOP   5'b00000 
`define ALU_ADD   5'b00001
`define ALU_SUB   5'b00010 
`define ALU_AND   5'b00011
`define ALU_OR    5'b00100
`define ALU_SLT   5'b00101
`define ALU_SLTU  5'b00110
`define ALU_NOR   5'b00111
`define ALU_SLL   5'b01000
`define ALU_SRL   5'b01001
`define ALU_SRA   5'b01010
`define ALU_SLLV  5'b01011
`define ALU_SRLV  5'b01100
`define ALU_LUI   5'b01101
`define ALU_XOR   5'b01111
`define ALU_SRAV  5'b10000
*/

  assign ALUOp[0] = i_add | i_lw | i_sw | i_addi | i_and | i_slt | i_addu | i_nor | i_srl | i_sllv |i_slti |i_lui | i_andi |i_xor |i_lh| i_lhu |i_lb|i_lbu |i_sb |i_sh;
  assign ALUOp[1] = i_sub | i_beq | i_and | i_sltu | i_subu | i_bne | i_nor | i_sra | i_sllv| i_andi|i_xor;
  assign ALUOp[2] = i_or | i_ori | i_slt | i_sltu | i_nor | i_srlv | i_slti | i_lui |i_xor ;
  assign ALUOp[3] = i_sll | i_sra | i_srl | i_sllv | i_srlv | i_lui | i_xor;
  assign ALUOp[4] = i_srav;



endmodule