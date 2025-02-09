`include "./ctrl_def.v"

module alu(
  input signed [31:0] A,    
  input signed [31:0] B,    
  input [4:0] ALUOp,
  output reg [31:0] result
  );
  
  
  always@(*)
  begin
    case(ALUOp)
      `ALUOP_NOR: 
	result = ~(A | B);
      `ALUOP_ADD:
        result = A + B;
      `ALUOP_SUB:
        result = A - B;
      `ALUOP_SLL:
        result = B << A[4:0];
      `ALUOP_SRL:
        result = B >> A[4:0];
      `ALUOP_SRA:
        result = B >>> A[4:0];
      `ALUOP_AND:
        result = A & B;
      `ALUOP_OR:
        result = A | B;
      `ALUOP_XOR:
        result = A ^ B;
      `ALUOP_SLT:
        result = (A < B)? 32'h1 : 32'h0;
      `ALUOP_SLTU:
        result = ({1'b0, A} < {1'b0, B}) ? 32'd1 : 32'd0;
      `ALUOP_LUI:
        result = {B[15:0],16'b0};
     
     
        default: result = 32'b0;
    endcase
  end
  
endmodule


