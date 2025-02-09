module forwarding(
  input [4:0] rs,
  input [4:0] rt,
  input [4:0] rs_ex,
  input [4:0] rt_ex,
  input [31:0] rf_wa,
  input [31:0] rf_wa_mem,
  input [31:0] rf_wa_wb,
  input [1:0] Jump,
  input MemRead_mem,
  input RegWrite_ex,
  input RegWrite_mem,
  input RegWrite_wb,
  
  output reg[1:0] forwardA,
  output reg[1:0] forwardB,
  output reg[1:0] forwardC,
  output reg[1:0] forwardD,

  output reg[1:0] JRegDst
  );

  always@(*)
  begin
    //mux_4 ForwardA_mux(ForwardA, rf_rd1_ex---00, rf_wd---01, alu_result_mem----10, 0, forwardA_result);
    /*EX hazard A*/
    if((RegWrite_mem && rf_wa_mem != 0) && (rf_wa_mem == rs_ex)) //from ALUresult_men
      forwardA = 2'b10;
    /*MEM hazard A*/
    else if((RegWrite_wb && rf_wa_wb != 0) && (rf_wa_wb == rs_ex)
            && !((RegWrite_mem && rf_wa_mem != 0) && (rf_wa_mem == rs_ex)))  //EX has no hazard
      forwardA = 2'b01;  //from rf_wd
    else
      forwardA = 2'b00;  //from rf_rd1_ex

    //  mux_4 ForwardB_mux(ForwardB, rf_rd2_ex---00, rf_wd---01, alu_result_mem---10, 0, forwardB_result);
    /*EX hazard B*/
    if((RegWrite_mem && rf_wa_mem != 0) && (rf_wa_mem == rt_ex))
      forwardB = 2'b10;
    /*MEM hazard B*/
    else if((RegWrite_wb && rf_wa_wb != 0) && (rf_wa_wb == rt_ex)
            && !((RegWrite_mem && rf_wa_mem != 0) && (rf_wa_mem == rt_ex))) 
      forwardB = 2'b01;
    else
      forwardB = 2'b00;

//***beq,bne hazard***
    if((RegWrite_ex && rf_wa!= 0) && (rf_wa == rs)) //from ALUresult
      forwardC = 2'b10;
    else if((RegWrite_wb && rf_wa_wb != 0) && (rf_wa_wb == rs_ex)
            && !((RegWrite_mem && rf_wa_mem != 0) && (rf_wa_mem == rs_ex)))  //EX has no hazard
      forwardC = 2'b01;  //from rf_wd
    else
      forwardC = 2'b00;  //from rf_rd1_ex

    if((RegWrite_ex && rf_wa != 0) && (rf_wa == rt))
      forwardD = 2'b10;
    
    else if((RegWrite_wb && rf_wa_wb != 0) && (rf_wa_wb == rt_ex)
            && !((RegWrite_mem && rf_wa_mem != 0) && (rf_wa_mem == rt_ex))) 
      forwardD = 2'b01;
    else
      forwardD = 2'b00;
//***************************
    /*JR or JALR hazard*/
//    if(RegWrite_mem && Jump == 2'b10 && ( == rt || rf_wa == rs )) 
    if(RegWrite_ex && Jump == 2'b10) 
      begin
//  mux_4 JRegDst_mux(JRegDst, rf_rd1---00, alu_result---01, dm_rd---10, 0, jreg_dst);
      if(MemRead_mem)  // load + jr/jalr( PC <- GPR[RS])
        JRegDst = 2'b10;
      else if (rs == rf_wa )          //alu + jr/jalr
        JRegDst = 2'b01;
      end
    else
      JRegDst = 2'b00;
  end
  
endmodule


