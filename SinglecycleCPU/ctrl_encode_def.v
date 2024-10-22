
// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10 
`define NPC_JR      2'b11  

// EXT control signal
//`define EXT_ZERO    2'b00
//`define EXT_SIGNED  2'b01
//`define EXT_HIGHPOS 2'b10

// ALU control signal
`define ALU_NOP   5'b00000 
`define ALU_ADD   5'b00001
`define ALU_SUB   5'b00010 
`define ALU_AND   5'b00011
`define ALU_OR    5'b00100
`define ALU_SLT   5'b00101
`define ALU_SLTU  5'b00110
`define ALU_NOR   5'b00111
`define ALU_SLL   5'b01000
`define ALU_SRL   5'b01001
`define ALU_SRA   5'b01010
`define ALU_SLLV  5'b01011
`define ALU_SRLV  5'b01100
`define ALU_LUI   5'b01101
`define ALU_XOR   5'b01111
`define ALU_SRAV  5'b10000

// GPR control signal
`define GPRSel_RD   2'b00
`define GPRSel_RT   2'b01
`define GPRSel_31   2'b10

`define WDSel_FromALU 2'b00
`define WDSel_FromMEM 2'b01
`define WDSel_FromPC  2'b10 

`define OP_LB 6'b100000
`define OP_LBU 6'b100100
`define OP_LH 6'b100001
`define OP_LHU 6'b100101
`define OP_LW 6'b100011
`define OP_SW 6'b101011
`define OP_SB 6'b101000
`define OP_SH 6'b101001

