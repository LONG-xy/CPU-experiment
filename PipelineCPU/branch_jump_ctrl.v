`include "./instr_def.v"

module branch_jump_ctrl(
  input [5:0] OP_if,
  input [5:0] OP_id,
  input [4:0] rt_id,

  input [1:0] Jump,
  input branch_equal,
  output reg[1:0] Branch,
  output reg IF_flush   //clear  up the pipeline  [IF/ID]
  );

  always@(*)
  begin
    /*for Branch*/
    /*Whether the branch is actually taken or not*/
    if( (OP_id ==`OP_BEQ && (!branch_equal))  || (OP_id == `OP_BNE && (branch_equal) )) //id.rs id.rt  **judge branch in ID**
    begin
      Branch = 2'b10;
      IF_flush = 1;
    end
    
    /*Always assume the branch taken*/   
    else if(OP_if == `OP_BEQ || OP_if == `OP_BNE )
    begin
      Branch = 2'b01; 
      IF_flush = 0;
    end

    else 
    begin
      Branch = 2'b00;
      IF_flush = 0;
    end
      
    /*for Jump*/
    if(Jump == 2'b01 || Jump == 2'b10)
      IF_flush = 1;
  end
  
endmodule     
