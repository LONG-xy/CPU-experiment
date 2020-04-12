`include "./ctrl_def.v"
`include "./instr_def.v"
//ID --decode, produce instruction control signal
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
  
  wire[5:0] OP;
  wire[5:0] Funct;
  
  assign OP = instr[31:26];
  assign Funct = instr[5:0];  
  
  initial
  begin
    RegDst = 2'b00;
    ALUOp = `ALUOP_ADD;
    ALUSrcA = 2'b00;
    ALUSrcB = 2'b00;
    EXTOp = `EXTOP_ZERO;
    MemRead = 0;
    MemWrite = 0;
    RegWrite = 0;
    MemtoReg = 2'b00;
    Jump = 2'b00;
  end
  
  /*------SIGNAL CONTROL------*/
  always@(*) 
  begin
    case(OP)
      `OP_RTYPE:
      begin
        case(Funct)
          `FUNCT_ADD,
          `FUNCT_ADDU:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_ADD;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
          
          `FUNCT_SUB,
          `FUNCT_SUBU:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SUB;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_AND:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_AND;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_OR:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_OR;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_XOR:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_XOR;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_NOR:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_NOR;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_SLT:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SLT;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_SLTU:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SLTU;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_SLL:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SLL;
            ALUSrcA = 2'b01;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
          
          `FUNCT_SLLV:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SLL;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_SRA:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SRA;
            ALUSrcA = 2'b01;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
          
          `FUNCT_SRAV:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SRA;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
            
          `FUNCT_SRL:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SRL;
            ALUSrcA = 2'b01;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
          
          `FUNCT_SRLV:
          begin 
            RegDst = 2'b01;
            ALUOp = `ALUOP_SRL;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b00;
          end
              
          `FUNCT_JALR:
          begin 
            RegDst = 2'b10;  //$31 return address
            ALUOp = `ALUOP_ADD;
            ALUSrcA = 2'b10;
            ALUSrcB = 2'b10;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 2'b00;
            Jump = 2'b10;  
          end
          
          `FUNCT_JR:
          begin 
            RegDst = 2'b00; 
            ALUOp = `ALUOP_ADD;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            EXTOp = `EXTOP_ZERO;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 0;
            MemtoReg = 2'b00;
            Jump = 2'b10;
          end
        endcase
      end
              
      `OP_ADDI:
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_ADD;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b01;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 1;
        MemtoReg = 2'b00;
        Jump = 2'b00;
      end
        
      
      `OP_ANDI:
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_AND;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b01;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 1;
        MemtoReg = 2'b00;
        Jump = 2'b00;
      end
        
      `OP_ORI:
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_OR;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b01;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 1;
        MemtoReg = 2'b00;
        Jump = 2'b00;
      end
        
      `OP_XORI:
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_XOR;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b01;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 1;
        MemtoReg = 2'b00;
        Jump = 2'b00;
      end
        
      `OP_LUI:
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_LUI;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b01;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 1;
        MemtoReg = 2'b00;
        Jump = 2'b00;
      end
        
      `OP_SLTI:
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_SLT;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b01;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 1;
        MemtoReg = 2'b00;
        Jump = 2'b00;
      end
        
    
      `OP_LB,
      `OP_LBU,
      `OP_LH,
      `OP_LHU,
      `OP_LW:
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_ADD;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b01;
        EXTOp = `EXTOP_ZERO;
        MemRead = 1;
        MemWrite = 0;
        RegWrite = 1;
        MemtoReg = 2'b01;
        Jump = 2'b00; 
      end
      
      `OP_SB,
      `OP_SH,
      `OP_SW:
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_ADD;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b01;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 1;
        RegWrite = 0;
        MemtoReg = 2'b00;
        Jump = 2'b00;
      end
      
      
        
      `OP_BEQ,
      `OP_BNE:  //don't need specific signals
      begin
        RegDst = 2'b00;
        ALUOp = `ALUOP_SUB;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b00;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
        MemtoReg = 2'b00;
        Jump = 2'b00;
      end
      
      `OP_J:
      begin 
        RegDst = 2'b00;
        ALUOp = `ALUOP_ADD;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b00;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
        MemtoReg = 2'b00;
        Jump = 2'b01;
      end
      
      `OP_JAL:
      begin 
        RegDst = 2'b10;
        ALUOp = `ALUOP_ADD;
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b10;
        EXTOp = `EXTOP_ZERO;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 1;
        MemtoReg = 2'b00;
        Jump = 2'b01;
      end
    endcase
  end 
     
endmodule