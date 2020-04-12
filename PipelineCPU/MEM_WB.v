module mem_wb(
  input clk,
  /*WB control*/
  input RegWrite_in,
  input [1:0]MemtoReg_in,
  
  input [31:0] rd_in,
  input [31:0]alu_result_in,
  input [31:0] wa_in,
  input [31:0] instr_in,
  
  output reg RegWrite_out,
  output reg[1:0] MemtoReg_out,
  
  output reg[31:0] rd_out,
  output reg[31:0] alu_result_out,
  output reg[31:0] wa_out,
  output reg[31:0] instr_out
  );
   
  always@(posedge clk)
  begin
    RegWrite_out <= RegWrite_in;
    MemtoReg_out <= MemtoReg_in;
    rd_out <= rd_in;
    alu_result_out <= alu_result_in;
    wa_out <= wa_in;
    instr_out <= instr_in;
  end
  
endmodule
