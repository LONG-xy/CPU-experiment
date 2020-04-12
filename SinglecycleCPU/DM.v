
// data memory
module dm( clk, DMWr, be, addr, din, dout);

   input          clk;
   input          DMWr;
   input  [3:0]   be; //byte enables
   input  [8:2]   addr; 
   input  [31:0]  din;
   output [31:0]  dout;
     
   reg [31:0] dmem[127:0];
 

    always @(posedge clk) 
    begin
      if (DMWr)
	  begin
	case(be)
        4'b1111: dmem[addr] = din;
        4'b0011: dmem[addr][15:0] = din[15:0];
        4'b1100: dmem[addr][31:16] = din[15:0]; 
        4'b0001: dmem[addr][7:0] = din[7:0];    
        4'b0010: dmem[addr][15:8] = din[7:0];  
        4'b0100: dmem[addr][23:16] = din[7:0];  
        4'b1000: dmem[addr][31:24] = din[7:0];   
      endcase
    end

          $display("dmem[0x%8X] = 0x%8X,", addr << 2, din); 
        
         end
   

 assign dout = dmem[addr];

  
endmodule 

