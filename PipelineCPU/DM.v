module dm(
  input MemWrite, //memory write enable
  input [11:2] addr, //address bus
  input [3:0] be, //byte enables
  input [31:0] din, //32-bit input data
  output [31:0] dout //32-bit memory output
  );
  
  reg[31:0] mem[31:0];
    
  /*write back data*/
  always@(*)
  begin
    if(MemWrite)
    begin
      case(be)
        4'b1111: mem[addr] = din;
        4'b0011: mem[addr][15:0] = din[15:0];
        4'b1100: mem[addr][31:16] = din[15:0];
        4'b0001: mem[addr][7:0] = din[7:0];
        4'b0010: mem[addr][15:8] = din[7:0];
        4'b0100: mem[addr][23:16] = din[7:0];
        4'b1000: mem[addr][31:24] = din[7:0];
      endcase
    end
 $display("dmem[0x%8X] = 0x%8X,", addr << 2, din); 

  end
  
  /*read data*/
  assign dout = mem[addr];
    
endmodule
      
