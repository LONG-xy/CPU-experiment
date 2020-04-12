module mips(
  input clk,
  input rst
  );
  
  //DATAPATH WIRES
  wire[31:0] pc_current;
  wire[31:0] pc_temp;
  wire[31:0] pc_new;
  wire[31:0] im_rd;
  wire[31:0]	instr;
  wire[31:0] instr_ex;
  wire[31:0] instr_mem;
  wire[31:0] instr_wb;
  wire[31:0] pc_next_if;
  wire[31:0] pc_next_id;
  wire[31:0] pc_next_ex;
  wire[31:0]	ext_result;
  wire[31:0] ext_result_ex;

 wire[31:0]	rf_wa; 
 wire[31:0]	rf_wa_mem;  
 wire[31:0]	rf_wa_wb;  
 wire[31:0] rf_wd; 

  wire[31:0] rf_rd1;
  wire[31:0] rf_rd1_ex;
  wire[31:0] rf_rd2;
  wire[31:0] rf_rd2_ex;

 wire[31:0]	alu_srcA;
 wire[31:0]	alu_srcB;
 
  wire[31:0] alu_result;
  wire[31:0] alu_result_mem;
  wire[31:0] alu_result_wb;

  wire[31:0] forwardA_result;
  wire[31:0] forwardB_result;
  wire[31:0] forwardC_result;
  wire[31:0] forwardD_result;
 

	wire[3:0] be;
	wire[31:0] dm_rd;
	wire[31:0] dm_rd_ext;
	wire[31:0] dm_rd_wb;
	wire[31:0] dm_wd;
	wire[4:0] rs;
	wire[4:0] rs_ex;
	wire[4:0] rt;
	wire[4:0] rt_ex;
	wire[4:0] rd;
	wire[4:0] rd_ex;
	wire[31:0] shamt;
	wire[31:0] shamt_ex;
	wire[31:0] branch_offset_ext;
	wire[31:0] jreg_dst;
  
  //SIGNALS
  wire[1:0] RegDst_id;
  wire[1:0] RegDst_ex;
  wire[4:0] ALUOp_id;
  wire[4:0] ALUOp_ex;
  wire[1:0] ALUSrcA_id;
  wire[1:0] ALUSrcA_ex;
  wire[1:0] ALUSrcB_id;
  wire[1:0] ALUSrcB_ex;

  wire[1:0] ForwardA;
  wire[1:0] ForwardB;
  wire[1:0] ForwardC;
  wire[1:0] ForwardD;

  wire MemRead_id;
  wire MemRead_ex;
  wire MemWrite_id;
  wire MemWrite_ex;
  wire MemWrite_mem;
  wire RegWrite_id;
  wire RegWrite_ex;
  wire RegWrite_mem;
  wire RegWrite_wb;
  wire[1:0] MemtoReg_id;
  wire[1:0] MemtoReg_ex;
  wire[1:0] MemtoReg_mem;
  wire[1:0] MemtoReg_wb;
  wire[1:0] EXTOp;  
  wire IF_flush;
  wire stall;

  wire[1:0] Branch;
  wire branch_equal;
  wire[1:0] Jump;
  wire[1:0] JRegDst;
  wire PC_IFWrite;
  
  assign rs = instr[25:21];
  assign rt = instr[20:16];
  assign rd = instr[15:11];
  assign shamt = {27'b0, instr[10:6]};
  assign branch_offset_ext = {{16{im_rd[15]}}, im_rd[15:0]};  
  assign pc_next_if = pc_current + 4;

  //------------------Link Modules---------------------//
  /*
  module mux_4 (
  input [1:0] control, 
  input [31:0] d0,
  input [31:0] d1,
  input [31:0] d2,
  input [31:0] d3,
  output reg[31:0] dout
  );
  */
  mux_4 MemtoReg_mux(MemtoReg_wb, alu_result_wb, dm_rd_ext, pc_current, 0, rf_wd);// dm DM(MemWrite_mem, alu_result_mem[11:2], be, dm_wd, dm_rd);
  
  mux_4 RegDst_mux(RegDst_ex, {27'b0,rt_ex}, {27'b0,rd_ex}, 31, 0, rf_wa); 

  mux_4 ForwardA_mux(ForwardA, rf_rd1_ex, rf_wd, alu_result_mem, 0, forwardA_result);
  mux_4 ForwardB_mux(ForwardB, rf_rd2_ex, rf_wd, alu_result_mem, 0, forwardB_result);

  mux_4 ForwardC_mux(ForwardC, rf_rd1, rf_wd, alu_result, 0, forwardC_result);//*******************
  mux_4 ForwardD_mux(ForwardD, rf_rd2, rf_wd, alu_result, 0, forwardD_result);//*******************


  mux_4 ALUSrcA_mux(ALUSrcA_ex, forwardA_result, shamt_ex, pc_next_ex, 0, alu_srcA);
  mux_4 ALUSrcB_mux(ALUSrcB_ex, forwardB_result, ext_result_ex, 0, 0, alu_srcB);   
  

  mux_4 PC_Branch_mux(Branch, pc_next_if, pc_next_if+{branch_offset_ext[29:0], 2'b00}, pc_next_id, 0, pc_temp); 
  mux_4 JRegDst_mux(JRegDst, rf_rd1, alu_result, dm_rd, 0, jreg_dst);

  mux_4 PC_Jump_mux(Jump, pc_temp, {pc_next_id[31:28], instr[25:0], 2'b00}, jreg_dst, 0, pc_new);

  branch_equal Branch_Equal(forwardC_result,forwardD_result,branch_equal);

//  mux_4 ForwardBeq_mux(ForwardBeq,  rf_rd
  
  /*
  module ext(
  input [1:0] EXTOp,  
  input [15:0] Imm16, 
  output reg[31:0] Imm32  
  );
  */
  ext EXT(EXTOp, instr[15:0], ext_result);
  
  /*
  module be_ext(
  input [1:0] control,  
  input [5:0] OP,       
  output reg[3:0] be   
  );
  */
  be_ext beEXT(alu_result_mem[1:0], instr_mem[31:26], be);
  /*
  module dmr_ext(
  input [1:0] control,  
  input [5:0] OP,       
  input [31:0] din,
  output reg[31:0] dout
  );
  */
  dmr_ext dmrEXT(alu_result_mem[1:0], instr_wb[31:26],dm_rd_wb, dm_rd_ext); /* for lb lbu lh lhu lw*/
  
  /*
  module pc(
  input clk,
  input PC_IFWrite,
  input [31:0] din,
  output [31:0] dout
  );
  */
  pc PC(clk, PC_IFWrite, pc_new, pc_current);
  
  /*
  module im( 
  input [11:2] addr, 
  output reg[31:0] dout 
  );
  */
  im IM(pc_current[11:2], im_rd);
  
  /*
  module rf(
  input RegWrite,
  input [4:0] RA1, 
  input [4:0] RA2, 
  input [31:0] WA,  
  input [31:0] WD, 
  output [31:0] RD1, 
  output [31:0] RD2  
  );
  */
  rf RF(RegWrite_wb, rs, rt, rf_wa_wb, rf_wd, rf_rd1, rf_rd2);

  /*
  module alu(
  input [31:0] A,    
  input [31:0] B,    
  input [4:0] ALUOp,
  output reg[31:0] result 
  );
  */
  alu ALU(alu_srcA, alu_srcB, ALUOp_ex, alu_result);
  
  /*
  module dm(
  input MemWrite, 
  input [11:2] addr,
  input [3:0] be, 
  input [31:0] din, 
  output [31:0] dout 
  );
  */
  dm DM(MemWrite_mem, alu_result_mem[11:2], be, dm_wd, dm_rd);
  
  /*
  module if_id(
  input clk,
  input PC_IFWrite,
  input IF_flush,
  input [31:0] pc_in,
  input [31:0] din,
  output reg[31:0] pc_out,
  output reg[31:0] dout
  );
  */
  if_id IF_ID(clk, PC_IFWrite, IF_flush, pc_next_if, im_rd, pc_next_id, instr);
    
  /*
  module id_ex(
  input clk,
  input stall,
  input [1:0] RegDst_in,    
  input [4:0] ALUOp_in,
  input [1:0] ALUSrcA_in,
  input [1:0] ALUSrcB_in,
  input MemRead_in,
  input MemWrite_in,
  input RegWrite_in,
  input [1:0] MemtoReg_in,
  input [31:0] rd1_in,
  input [31:0] rd2_in,
  input [31:0] shamt_in,
  input [31:0] ext_in,
  input [4:0] rs_in,
  input [4:0] rt_in,
  input [4:0] rd_in,
  input [31:0] instr_in,
  input [31:0] pc_in,
  
  output reg[1:0] RegDst_out,
  output reg[4:0] ALUOp_out,
  output reg[1:0] ALUSrcA_out,
  output reg[1:0] ALUSrcB_out,
  output reg MemRead_out,
  output reg MemWrite_out,
  output reg RegWrite_out,
  output reg[1:0] MemtoReg_out,
  output reg[31:0] rd1_out,
  output reg[31:0] rd2_out,
  output reg[31:0] shamt_out,
  output reg[31:0] ext_out,
  output reg[4:0] rs_out,
  output reg[4:0] rt_out,
  output reg[4:0] rd_out,
  output reg[31:0] instr_out,
  output reg[31:0] pc_out
  );
  */
  id_ex ID_EX(clk, stall, RegDst_id, ALUOp_id, ALUSrcA_id, ALUSrcB_id, MemRead_id, MemWrite_id, RegWrite_id, MemtoReg_id,
              rf_rd1, rf_rd2, shamt, ext_result, rs, rt, rd, instr, pc_next_id,
              RegDst_ex, ALUOp_ex, ALUSrcA_ex, ALUSrcB_ex, MemRead_ex, MemWrite_ex, RegWrite_ex, MemtoReg_ex,
              rf_rd1_ex, rf_rd2_ex, shamt_ex, ext_result_ex, rs_ex, rt_ex, rd_ex, instr_ex, pc_next_ex);
              
  /*
  module ex_mem(
  input clk,
  input MemRead_in,
  input MemWrite_in,
  input RegWrite_in,
  input [1:0]MemtoReg_in,
  input [31:0] alu_result_in,
  input dm_wd_in,
  input wa_in,
  input [31:0] instr_in,
  
  output reg MemRead_out,
  output reg MemWrite_out,
  output reg RegWrite_out,
  output reg[1:0] MemtoReg_out,
  output reg[31:0] alu_result_out, 
  output reg dm_wd_out,
  output reg wa_out,
  output reg[31:0] instr_out
  );
  */
  ex_mem EX_MEM(clk, MemRead_ex, MemWrite_ex, RegWrite_ex, MemtoReg_ex, alu_result, forwardB_result, rf_wa, instr_ex,
                MemRead_mem, MemWrite_mem, RegWrite_mem, MemtoReg_mem, alu_result_mem, dm_wd, rf_wa_mem, instr_mem);
  
  /*
  module mem_wb(
  input clk,
  input RegWrite_in,
  input [1:0] MemtoReg_in,
  input [31:0] rd_in,
  input [31:0]alu_result_in,
  input [31:0] wa_in,
  input [31:0] instr_in,
  
  output reg RegWrite_out,
  output reg[1:0] MemtoReg_out,
  output reg[31:0] rd_out,
  output reg[31:0] alu_result_out,
  output reg[31:0] wa_out,
  output reg[31:0] instr_out
  );
  */
  mem_wb MEM_WB(clk, RegWrite_mem, MemtoReg_mem, dm_rd, alu_result_mem, rf_wa_mem, instr_mem,
                RegWrite_wb, MemtoReg_wb, dm_rd_wb, alu_result_wb, rf_wa_wb, instr_wb);
                
  /*
 module forwarding(
  input [4:0] rs,
  input [4:0] rt,
  input [4:0] rs_ex,
  input [4:0] rt_ex,
  input  [31:)]rf_wa,
  input [31:0] rf_wa_mem,
  input [31:0] rf_wa_wb,
  input [1:0] Jump,
  input MemRead_mem,
  RegWrite_ex,
  input RegWrite_mem,
  input RegWrite_wb,
  output reg[1:0] forwardA,
  output reg[1:0] forwardB,
  output reg[1:0] JumpDst
  );
  */
  forwarding FWD(rs, rt, rs_ex, rt_ex, rf_wa, rf_wa_mem, rf_wa_wb, Jump, MemRead_mem, RegWrite_ex, RegWrite_mem, RegWrite_wb, ForwardA, ForwardB, ForwardC, ForwardD, JRegDst);
  
  /*
  module hazard_detection(
  input [4:0] rs,
  input [4:0] rt,
  input [31:0] rf_wa,
  input MemRead_ex,
  input RegWrite_ex,
  output reg PC_IFWrite,
  output reg stall
  ); 
  */
  hazard_detection HazardD(rs, rt, rf_wa, MemRead_ex, RegWrite_ex, PC_IFWrite, stall);
  
  /*
  module branch_jump_ctrl(
  input [5:0] OP_if,
  input [5:0] OP_id,
  input [4:0] rt_id,
  input [31:0] rf_rd1,
  input [31:0] rf_rd2,
  input [1:0] Jump,
  input branch_equal,
  output reg[1:0] Branch,
  output reg IF_flush
  );
  */
 branch_jump_ctrl B_J_CTRL(im_rd[31:26], instr[31:26], instr[20:16], Jump, branch_equal, Branch, IF_flush);
 

  /*
  module ctrl(
  input [31:0] instr,
  output reg[1:0] RegDst,
  output reg[4:0] ALUOp,
  output reg[1:0] ALUSrcA,
  output reg[1:0] ALUSrcB,
  output reg[1:0] EXTOp,
  output reg MemRead,
  output reg MemWrite,
  output reg RegWrite,
  output reg[1:0] MemtoReg,
  output reg[1:0] Jump
  );
  */
  ctrl CTRL(instr, RegDst_id, ALUOp_id, ALUSrcA_id, ALUSrcB_id, EXTOp, 
            MemRead_id, MemWrite_id, RegWrite_id, MemtoReg_id, Jump);
endmodule