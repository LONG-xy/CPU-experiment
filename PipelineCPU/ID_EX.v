module id_ex(
  input clk,
  input stall,
  /*EX control*/
  input [1:0] RegDst_in,    
  input [4:0] ALUOp_in,
  input [1:0] ALUSrcA_in,
  input [1:0] ALUSrcB_in,
  /*MEM control*/
  input MemRead_in,
  input MemWrite_in,
  /*WB control*/
  input RegWrite_in,
  input [1:0] MemtoReg_in,
  
  input [31:0] rd1_in,
  input [31:0] rd2_in,
  input [31:0] shamt_in,
  input [31:0] ext_in,
  input [4:0] rs_in,
  input [4:0] rt_in,
  input [4:0] rd_in,
  input [31:0] instr_in,
  input [31:0] pc_in,
  
  output reg[1:0] RegDst_out,
  output reg[4:0] ALUOp_out,
  output reg[1:0] ALUSrcA_out,
  output reg[1:0] ALUSrcB_out,
  output reg MemRead_out,
  output reg MemWrite_out,
  output reg RegWrite_out,
  output reg[1:0] MemtoReg_out,
  
  output reg[31:0] rd1_out,
  output reg[31:0] rd2_out,
  output reg[31:0] shamt_out,
  output reg[31:0] ext_out,
  output reg[4:0] rs_out,
  output reg[4:0] rt_out,
  output reg[4:0] rd_out,
  output reg[31:0] instr_out,
  output reg[31:0] pc_out
  );
  
  always@(posedge clk)
  begin
    rd1_out <= rd1_in;
    rd2_out <= rd2_in;
    shamt_out <= shamt_in;
    ext_out <= ext_in;
    rs_out <= rs_in;
    rt_out <= rt_in;
    rd_out <= rd_in;
    instr_out <= instr_in;
    pc_out <= pc_in;
    
    if(stall)
    begin
      RegDst_out <= 0;
      ALUOp_out <= 0;
      ALUSrcA_out <= 0;
      ALUSrcB_out <= 0;
      MemRead_out <= 0;
      MemWrite_out <= 0;
      RegWrite_out <= 0;
      MemtoReg_out <= 0;
    end
    
    else
    begin
      RegDst_out <= RegDst_in;
      ALUOp_out <= ALUOp_in;
      ALUSrcA_out <= ALUSrcA_in;
      ALUSrcB_out <= ALUSrcB_in;
      MemRead_out <= MemRead_in;
      MemWrite_out <= MemWrite_in;
      RegWrite_out <= RegWrite_in;
      MemtoReg_out <= MemtoReg_in;
    end
  end
  
endmodule