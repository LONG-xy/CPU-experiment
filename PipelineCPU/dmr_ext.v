/* for lb lbu lh lhu lw*/
`include "./instr_def.v"

module dmr_ext(
  input [1:0] control,  //alu_result[1:0]
  input [5:0] OP,       //instr[31:26]
  input [31:0] din,     //dm_rd_wb
  output reg[31:0] dout //dm_rd_ext
  );
  
  always@(*)
  begin
    case(OP)
      `OP_LB: 
      begin
        case(control)
          2'b00: dout = {{24{din[7]}},din[7:0]};
          2'b01: dout = {{24{din[15]}},din[15:8]};
          2'b10: dout = {{24{din[23]}},din[23:16]};
          2'b11: dout = {{24{din[31]}},din[31:24]};
        endcase
      end
      `OP_LBU:
      begin
        case(control)
          2'b00: dout = {24'b0,din[7:0]};
          2'b01: dout = {24'b0,din[15:8]};
          2'b10: dout = {24'b0,din[23:16]};
          2'b11: dout = {24'b0,din[31:24]};
        endcase
      end
      `OP_LH:
      begin
        if(control[1])
          dout = {{16{din[31]}},din[31:16]};
        else
          dout = {{16{din[15]}},din[15:0]};
      end
      `OP_LHU: 
      begin
        if(control[1])
          dout = {16'b0,din[31:16]};
        else
          dout = {16'b0,din[15:0]};
      end
      `OP_LW: dout = din;
    endcase
  end
  
endmodule



