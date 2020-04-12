module mux_4 (
  input [1:0] control, //mux signal
  input [31:0] d0,
  input [31:0] d1,
  input [31:0] d2,
  input [31:0] d3,
  output reg[31:0] dout
  );
 
  always@(*)
  begin
    case(control)
      2'b00: dout = d0;
      2'b01: dout = d1;
      2'b10: dout = d2;
      2'b11: dout = d3;
    endcase
  end
endmodule


