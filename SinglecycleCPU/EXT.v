
module EXT( Imm16, EXTOp, Imm32 );

input [15:0] Imm16;
input EXTOp;
output[31:0] Imm32;

assign Imm32=(EXTOp)?{  {16{Imm16[15]}},Imm16  }:{16'd0,Imm16};
//EXTOp==1  signed-extension
//EXTOp==0  zero-extension

endmodule