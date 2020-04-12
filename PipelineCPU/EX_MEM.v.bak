module ex_mem(
  input clk,
  /*MEM control*/
  input MemRead_in,
  input MemWrite_in,
  /*WB control*/
  input RegWrite_in,
  input [1:0] MemtoReg_in,

  input [31:0] alu_result_in,
  input [31:0] dm_wd_in,
  input [31:0] wa_in,
  input [31:0] instr_in,
 
  output reg MemRead_out,
  output reg MemWrite_out,
  output reg RegWrite_out,
  output reg[1:0] MemtoReg_out,

  output reg[31:0] alu_result_out,
  output reg[31:0] dm_wd_out,
  output reg[31:0] wa_out,
  output reg[31:0] instr_out
  );
  
  always@(posedge clk)
  begin
    MemRead_out <= MemRead_in;
    MemWrite_out <= MemWrite_in;
    RegWrite_out <= RegWrite_in;
    MemtoReg_out <= MemtoReg_in;
    alu_result_out <= alu_result_in;
    dm_wd_out <= dm_wd_in;
    wa_out <= wa_in;
    instr_out <= instr_in;
  end
  
endmodule
