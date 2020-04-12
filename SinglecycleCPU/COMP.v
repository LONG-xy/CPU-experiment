

module sccomp(clk, rstn, reg_sel, reg_data);
   input          clk;
   input          rstn;
   input  [4:0]    reg_sel;
   output [31:0]  reg_data;


   
   wire [31:0]    instr;
   wire [31:0]    PC;
   wire           MemWrite;
   wire [31:0]    dm_addr, dm_din, dm_dout;
//*************
    wire[31:0] dm_rd_ext;
   wire[3:0] be;
 
   
   wire rst = ~rstn;



 // instantiation of intruction memory (used for simulation)
   im    U_IM ( 
      .addr(PC[8:2]),     // input:  rom address
      .dout(instr)        // output: instruction
   );
   dm    U_DM(
         .clk(clk),
         .be(be),
         .DMWr(MemWrite),     // input:  ram write
         .addr(dm_addr[8:2]), // input:  ram address
         .din(dm_din),        // input:  data to ram
         .dout(dm_dout)       // output: data from ram
         );
  // instantiation of single-cycle CPU   

   sccpu U_SCPU(
         .clk(clk),                 // input:  cpu clock
         .rst(rst),                 // input:  reset
         .instr(instr),             // input:  instruction
         .dm_rd_ext(dm_rd_ext),     // input:  data to register  
         .MemWrite(MemWrite),       // output: memory write signal
         .PC(PC),                   // output: PC
         .aluout(dm_addr),          // output: address from cpu to memory
         .writedata(dm_din),        // output: data from cpu to memory
         .reg_sel(reg_sel),         // input:  register selection
         .reg_data(reg_data)        // output: register data
         );
         
 
         

        
endmodule