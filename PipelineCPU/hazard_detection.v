// when detect hazard condition in ID , hazard_detector output 2 signal
`include "./instr_def.v"
module hazard_detection(
  input [4:0] rs,
  input [4:0] rt,
  input [31:0] rf_wa,
  input MemRead_ex, 
  input RegWrite_ex,
  
  output reg PC_IFWrite,  // forbid PC & IF/ID receive new value(data)
  output reg stall  //clear up ID/EX 's content (signal of EX, MEM, WB)
  );

  always@(*)
  begin
    if(MemRead_ex && (rf_wa == rt || rf_wa == rs)) //load hazard: MemRead signal in ID/EX || **destination :[ex.rd_wa]** || **source:[id.rs / id.rt]** 
    begin
      stall = 1;
      PC_IFWrite = 0;
    end
    else
    begin
      stall = 0;
      PC_IFWrite = 1;
    end
  end
  
endmodule
      