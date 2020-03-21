
module im(input  [8:2]  addr,  // an instruction takes 4 Bytes space; the next instruction's address
          output [31:0] dout );

  reg  [31:0] ROM [127:0];//128== 2^7

  assign dout = ROM[addr]; // word aligned
endmodule  
