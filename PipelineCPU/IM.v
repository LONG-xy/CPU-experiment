module im( 
  input [11:2] addr, //address bus
  output reg[31:0] dout //32-bit memory output
  );
   
 // `timescale 1ns/1ns
  
  reg[31:0] InstrMem[128:0];
   /* reg[31:0] instr_temp;
  integer fd, cnt, pointer;
    
  //get instruction hex code
  initial
  begin
   // fd = $fopen("./test.txt","r"); 
    fd = $fopen("mipstest_pipelinedloop.dat","r"); 
    for(pointer = 0; pointer < 128; pointer = pointer+1)
    begin
      cnt = $fscanf(fd, "%x", instr_temp);
      InstrMem[pointer] = instr_temp;
      $display("IM read instruction %d: 0x%x", pointer, instr_temp);  //display the instructions 
    end
    $fclose(fd);
  end
    */
  /*read instruction*/  
  always@(*)
    dout <= InstrMem[addr];  
  
endmodule

