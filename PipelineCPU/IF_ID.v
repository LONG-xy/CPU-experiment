module if_id(
  input clk,
  input PC_IFWrite,
  input IF_flush,
  input [31:0] pc_in,
  input [31:0] din,  //im_id
  output reg[31:0] pc_out,
  output reg[31:0] dout
  );

  always@(posedge clk)
  begin
    if(IF_flush)
    begin
      dout <= 0;
      pc_out <= 0;
    end
    else
    begin
     if(PC_IFWrite )
     begin
       dout <= din;  //im_id->instr
       pc_out = pc_in;
     end
   end
 end

endmodule