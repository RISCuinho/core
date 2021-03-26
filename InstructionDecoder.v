module IntegerBasicInstructionDecoder (
   input  [31:0] instr,
   output [15:0] full_op_code,

   output jump,

   output        alu_sel,

   output [ 1:0] rd_data_sel, 

   output [ 4:0] rs1_sel,
   output [ 4:0] rs2_sel,
   output [ 4:0] rd_sel,
   
   output [31:0] imm,
   output        imm_rs2_sel,
   output        reg_w,
   output        data_w, data_r, unsigned_value,
   output [ 1:0] data_size
);
initial begin
   $display("Instruction Decoder");
 end

//0000000 00000 00001 100 00011 0000011
wire [ 6:0] code    = instr[6:0];
wire [ 2:0] FN3     = instr[14:12];
wire [ 4:0] FN5     = instr[11:7];
wire [ 6:0] FN7     = instr[31:25];
wire [11:0] FN12    = instr[31:20];
               
wire TYPE_IF  = code == 7'b0001111;
wire TYPE_IJ  = code == 7'b1100111;
wire TYPE_IL  = code == 7'b0000011;
wire TYPE_IA  = code == 7'b0010011;
wire TYPE_I   = TYPE_IA || TYPE_IL || TYPE_IF | TYPE_IJ;
wire TYPE_S   = code == 7'b0100011;
wire TYPE_R   = code == 7'b0110011;
wire TYPE_U   = code == 7'b0110111 || code == 7'b0010111;
wire TYPE_B   = code == 7'b1100011;
wire TYPE_J   = code == 7'b1101111;

wire LUI     = code == 7'b0110111;

wire AUIPC   = code == 7'b0010111;

wire JAL     = code == 7'b1101111;
wire JALR    = TYPE_IJ && FN3 == 3'b000;

wire BEQ     = TYPE_B && FN3 == 3'b000;
wire BNE     = TYPE_B && FN3 == 3'b001;
wire BLT     = TYPE_B && FN3 == 3'b100;
wire BGE     = TYPE_B && FN3 == 3'b101;
wire BLTU    = TYPE_B && FN3 == 3'b110;
wire BGEU    = TYPE_B && FN3 == 3'b111;

wire LB      = TYPE_IL && FN3 == 3'b000;
wire LH      = TYPE_IL && FN3 == 3'b001;
wire LW      = TYPE_IL && FN3 == 3'b010;
wire LBU     = TYPE_IL && FN3 == 3'b100;
wire LHU     = TYPE_IL && FN3 == 3'b101;

wire SB      = TYPE_S && FN3 == 3'b000;
wire SH      = TYPE_S && FN3 == 3'b001;
wire SW      = TYPE_S && FN3 == 3'b010;

wire ADDI    = TYPE_IA && FN3 == 3'b000;
wire SLTI    = TYPE_IA && FN3 == 3'b010;
wire SLTIU   = TYPE_IA && FN3 == 3'b011;
wire XORI    = TYPE_IA && FN3 == 3'b100;
wire ORI     = TYPE_IA && FN3 == 3'b110;
wire ANDI    = TYPE_IA && FN3 == 3'b111;
wire SLLI    = TYPE_IA && FN3 == 3'b001 && FN7 == 7'b0000000;
wire SRLI    = TYPE_IA && FN3 == 3'b101 && FN7 == 7'b0000000;
wire SRAI    = TYPE_IA && FN3 == 3'b101 && FN7 == 7'b0100000;

wire ADD     = TYPE_R && FN3 == 3'b000 && FN7 == 7'b0000000;
wire SUB     = TYPE_R && FN3 == 3'b000 && FN7 == 7'b0100000;
wire SLL     = TYPE_R && FN3 == 3'b001 && FN7 == 7'b0000000;
wire SLT     = TYPE_R && FN3 == 3'b010 && FN7 == 7'b0000000;
wire SLTU    = TYPE_R && FN3 == 3'b011 && FN7 == 7'b0000000;
wire XOR     = TYPE_R && FN3 == 3'b100 && FN7 == 7'b0000000;
wire SRL     = TYPE_R && FN3 == 3'b101 && FN7 == 7'b0000000;
wire SRA     = TYPE_R && FN3 == 3'b101 && FN7 == 7'b0100000;
wire OR      = TYPE_R && FN3 == 3'b110 && FN7 == 7'b0000000;
wire AND     = TYPE_R && FN3 == 3'b111 && FN7 == 7'b0000000;

wire [11:0] imm_I   = instr[31:20];
wire [19:0] imm_U   = instr[31:12];   
wire [11:0] imm_S   = {instr[31:25], instr[11:7]};   
wire [12:0] imm_B   = {instr[31:31], instr[7:7], instr[30:25], instr[11:8]};   
wire [20:0] imm_J   = {instr[31:31], instr[19:12], instr[20:20], instr[30:21]};   

wire [ 4:0] shamt   = instr[24:20];

assign imm          = SLLI || SRLI || SRAI ? {    27'b0      ,  shamt} :
                      TYPE_I               ? {{20{imm_I[11]}},  imm_I        }  : 
                      TYPE_B               ? {{19{imm_B[12]}},  imm_B, {1'b0}}  : 
                      TYPE_S               ? {{19{imm_S[11]}},  imm_S        }  : 
                      TYPE_J               ? {{11{imm_J[20]}},  imm_J, {1'b0}}  : 
                      TYPE_U               ? {    imm_U      ,  {12'b0}      }  : 
                      32'bx;

assign full_op_code = SLLI || SRLI || SRAI || 
                      TYPE_R               ? {FN7 ,  FN3, code}  :
                      TYPE_S ||
                      TYPE_I || TYPE_IL ||
                      TYPE_B               ? {7'b0,  FN3, code} :
                      TYPE_J ||
                      TYPE_U               ? {7'b0, 3'b0, code} :
                      16'bx;

assign rd_sel       = TYPE_I || TYPE_IL ||
                      TYPE_U || TYPE_J || TYPE_R                     ? instr[11:7] : 
                      5'bx;

assign rs1_sel      = TYPE_I                    ||
                      TYPE_B || TYPE_S || TYPE_R                     ? instr[19:15] : 
                      5'bx;
assign rs2_sel      = TYPE_B || TYPE_S || TYPE_R                     ? instr[24:20] : 
                      5'bx;

assign imm_rs2_sel  = TYPE_I || TYPE_S;

// Indica se ativa ou não a ALU
// quais instruções fazem uso da ALU?
// apenas ativa se for uma das instruções que usam a ALU, as demais ignora
assign alu_sel      =   ADDI || ADD   ||
                        SLTI || SLTIU || SLT  || 
                        LBU  || LHU   ||
                        LB   || LH    || LW   ||
                        SB   || SH    || SW   ||
                        SUB  ||
                        XORI || ORI   || OR   ||
                        ANDI || AND   ||
                        SLLI || SRLI  || SRAI ||
                        SLL  || SRL   || SRA
                      ;

/*
   Seleciona quem será a fonte de rd_data.

   00 -> alu
   01 -> bus (data_out)
   10 -> imm
   11 -> pc + 4
 */
assign rd_data_sel = SLTI || SLTIU || SLT ? 2'b00 :
                     LB   || LH    || LW || 
                     LBU  || LHU          ? 2'b01 :
                     LUI                  ? 2'b10 : 
                     JAL  || JALR         ? 2'b11 :
                                            2'b00 ;

// indica que deve escrever no registrador
assign reg_w        = LB  || LH  || LW || 
                      LBU || LHU ||
                      TYPE_U || TYPE_J || TYPE_R ||
                      TYPE_I ;


/*
 Escolhe o tamanho da memória, se byte, half-word ou word.
   00 -> 8bits
   01 -> 16bits 
   10 -> 32bits 
 */
assign data_size     = FN3[1:0]; 

assign data_w        = TYPE_S;
assign data_r        = TYPE_IL;

assign unsigned_value = LBU || LHU || SLTIU; // no caso LBU e LHU fn3 tem o bit 2 igual a 1

assign jump = TYPE_J || AUIPC;

endmodule
