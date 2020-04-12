module mips_tb();
  `timescale 1ns / 1ns
  reg clk;
  reg rst;

  initial
  begin
    clk = 0;
    rst = 1;

//       $readmemh( "mipstest_extloop.dat",mips.IM.InstrMem);
         $readmemh("mipstest_pipelineloop.dat",mips.IM.InstrMem);
//       $readmemh("mipstest_extloop.dat",mips.IM.InstrMem);
//       $readmemh("mipstestloopjal_sim.dat", mips.IM.InstrMem);
//       $readmemh("mipstestloop_sim.dat", mips.IM.InstrMem);
//  	 $readmemh("o_mipstest_extloop.dat", mips.IM.InstrMem);

    $monitor( "PC = 0x%8X, instr = 0%8X", mips.pc_current , mips.instr);
   //wait 50ns for global reset to finish
    #50; 
    clk = ~clk;
    #50;
    rst = 0;
    forever #50  
    begin
      clk = ~clk;
    end
  end
  
  mips mips(clk, rst);
endmodule

