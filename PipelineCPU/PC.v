module pc(
  input clk,
  input PC_IFWrite,
  input [31:0] din,
  output [31:0] dout
  );
  
  reg[31:0] currentPC;
  
  initial
    currentPC = 32'h0000_3000; //reset PC

  
  always@(posedge clk)
  begin
    if(PC_IFWrite) // to support stalls from hazard detection unit
    begin
      currentPC = din;   //renew pc
      $display(" PC_current :0x%x ", currentPC); //display the current pc
    end
  end

  assign dout = currentPC;
endmodule
