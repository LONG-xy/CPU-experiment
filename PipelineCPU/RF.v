module rf(
  input RegWrite,
  input [4:0] RA1, //1st reg address to read
  input [4:0] RA2, //2nd reg address to read

  input [31:0] WA,  //reg address to write
  
  input [31:0] WD, //reg data to write

  output [31:0] RD1, //1st reg data to read
  output [31:0] RD2  //2nd reg data to read
  );
  
  reg[31:0] rf[31:0];
 integer i;
   
  initial
  begin
    for(i=0; i<32; i=i+1)
      rf[i] = 32'b0;
  end
  
  /*register write*/
  always@(*)
  begin
    if((WA != 0) && RegWrite)
      begin
        rf[WA] <= WD;   
 
        $display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]);
        $display("r[08-15]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[8], rf[9], rf[10], rf[11], rf[12], rf[13], rf[14], rf[15]);
        $display("r[16-23]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[16], rf[17], rf[18], rf[19], rf[20], rf[21], rf[22], rf[23]);
        $display("r[24-31]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[24], rf[25], rf[26], rf[27], rf[28], rf[29], rf[30], rf[31]);
        $display("r[%2d] = 0x%8X,", WA, WD); 
	end   

  end
  
   /*register read*/
//  assign RD1 = (RegWrite == 0)? 0: rf[RA1];//[rs]
  assign RD1 = rf[RA1];
  assign RD2 = rf[RA2];//[rt]
  
endmodule
      
