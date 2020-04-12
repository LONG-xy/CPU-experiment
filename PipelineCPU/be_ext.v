/* for sb sh sw */
`include "./instr_def.v"

module be_ext(
  input [1:0] control,  //alu_result[1:0]
  input [5:0] OP,       //instr[31:26]
  output reg[3:0] be   //byte enables
  );
   
  always@(*)
  begin
    case(OP)
      `OP_SW: be = 4'b1111;
      `OP_SH:
      begin
        if(control[1])
          be = 4'b1100;
        else
          be = 4'b0011;
      end
      `OP_SB:
      begin
        case(control)
          2'b00: be = 4'b0001;
          2'b01: be = 4'b0010;
          2'b10: be = 4'b0100;
          2'b11: be = 4'b1000;
        endcase
      end
    endcase
  end
  
endmodule




