module IntegerBasicALU #(
   parameter DATA_WIDTH = 32
)(
   input         E,
   input         [15:0] alu_op,
   input  signed [DATA_WIDTH-1:0] A, B,
   output signed [DATA_WIDTH-1:0] out
);

localparam TYPE_IL      = 7'b0000011;
localparam TYPE_I       = 7'b0010011;
localparam TYPE_U_AUIPC = 7'b0010111;
localparam TYPE_U_LUI   = 7'b0110111;
localparam TYPE_R       = 7'b0110011;
localparam TYPE_S       = 7'b0100011;
localparam TYPE_B       = 7'b1100011;
localparam TYPE_IJ      = 7'b1100111;
localparam TYPE_J       = 7'b1101111;

localparam LUI     = {7'b0000000, 3'b000, TYPE_U_LUI  }; // b0000-0000-0001-1011  h001B
localparam AUIPC   = {7'b0000000, 3'b000, TYPE_U_AUIPC}; // b0000-0000-0000-1011  h000B
localparam JAL     = {7'b0000000, 3'b000, TYPE_J      }; // b0000-0000-0110-1111  h006F
localparam JALR    = {7'b0000000, 3'b000, TYPE_IJ     }; // b0000-0000-0110-0111  h0067

localparam BEQ     = {7'b0000000, 3'b000, TYPE_B      }; // b0000-0000-0110-0011  h0063
localparam BNE     = {7'b0000000, 3'b001, TYPE_B      }; // b0000-0000-1110-0011  h02E3
localparam BLT     = {7'b0000000, 3'b100, TYPE_B      }; // b0000-0010-0110-0011  h0263
localparam BGE     = {7'b0000000, 3'b101, TYPE_B      }; // b0000-0010-1110-0011  h02E3
localparam BLTU    = {7'b0000000, 3'b110, TYPE_B      }; // b0000-0011-0110-0011  h0363
localparam BGEU    = {7'b0000000, 3'b111, TYPE_B      }; // b0000-0011-1110-0011  h03E3

localparam LB      = {7'b0000000, 3'b000, TYPE_IL     }; // b0000-0000-0000-0011  h0003
localparam LH      = {7'b0000000, 3'b001, TYPE_IL     }; // b0000-0000-1000-0011  h0083
localparam LW      = {7'b0000000, 3'b010, TYPE_IL     }; // b0000-0001-0000-0011  h0103
localparam LBU     = {7'b0000000, 3'b100, TYPE_IL     }; // b0000-0010-0000-0011  h0203
localparam LHU     = {7'b0000000, 3'b101, TYPE_IL     }; // b0000-0010-1000-0011  h0283

localparam SB      = {7'b0000000, 3'b000, TYPE_S      }; // b0000-0000-0010-0011  h0023
localparam SH      = {7'b0000000, 3'b001, TYPE_S      }; // b0000-0000-1010-0011  h00A3
localparam SW      = {7'b0000000, 3'b010, TYPE_S      }; // b0000-0001-0010-0011  h0123

localparam ADDI    = {7'b0000000, 3'b000, TYPE_I      }; // b0000-0000-0001-0011  h0013
localparam SLTI    = {7'b0000000, 3'b010, TYPE_I      }; // b0000-0001-0001-0011  h0113
localparam SLTIU   = {7'b0000000, 3'b011, TYPE_I      }; // b0000-0001-1001-0011  h0193
localparam XORI    = {7'b0000000, 3'b100, TYPE_I      }; // b0000-0010-0001-0011  h0213
localparam ORI     = {7'b0000000, 3'b110, TYPE_I      }; // b0000-0011-0001-0011  h0313
localparam ANDI    = {7'b0000000, 3'b111, TYPE_I      }; // b0000-0011-1001-0011  h0393
localparam SLLI    = {7'b0000000, 3'b001, TYPE_I      }; // b0000-0000-1001-0011  h0093
localparam SRLI    = {7'b0000000, 3'b101, TYPE_I      }; // b0000-0010-1001-0011  h0293
localparam SRAI    = {7'b0100000, 3'b101, TYPE_I      }; // b0100-0010-1001-0011  h4293

localparam ADD     = {7'b0000000, 3'b000, TYPE_R      }; // b0000-0000-0011-0011  h0033
localparam SUB     = {7'b0100000, 3'b000, TYPE_R      }; // b0100-0000-0011-0011  h4033
localparam SLL     = {7'b0000000, 3'b001, TYPE_R      }; // b0000-0001-0011-0011  h0133
localparam SLT     = {7'b0000000, 3'b010, TYPE_R      }; // b0000-0010-0011-0011  h0233
localparam SLTU    = {7'b0000000, 3'b011, TYPE_R      }; // b0000-0011-0011-0011  h0333
localparam XOR     = {7'b0000000, 3'b100, TYPE_R      }; // b0000-0100-0011-0011  h0433
localparam SRL     = {7'b0000000, 3'b101, TYPE_R      }; // b0000-0101-0011-0011  h0533
localparam SRA     = {7'b0100000, 3'b101, TYPE_R      }; // b0100-0101-0011-0011  h4533
localparam OR      = {7'b0000000, 3'b110, TYPE_R      }; // b0000-0110-0011-0011  h0633
localparam AND     = {7'b0000000, 3'b111, TYPE_R      }; // b0000-0111-0011-0011  h0733

assign out = !E               ? {DATA_WIDTH{1'b0}}  :
             alu_op == JAL    ||
             alu_op == BEQ    ||
             alu_op == BNE    ||
             alu_op == BLT    ||
             alu_op == BGE    ||
             alu_op == BLTU   ||
             alu_op == BGEU   ||
             alu_op == AUIPC ||
             alu_op == ADD   ||
             alu_op == ADDI  ||
             alu_op == LB    ||
             alu_op == LBU   ||
             alu_op == LH    ||
             alu_op == LHU   ||
             alu_op == LW    ||
             alu_op == SB    ||
             alu_op == SH    ||
             alu_op == SW     ? $signed(A) + $signed(B) :

             alu_op == SUB    ? $signed(A) - $signed(B) :  

             alu_op == SLLI  ||
             alu_op == SLL    ? $signed(A) << $signed(B) :  

             alu_op == SRLI  ||
             alu_op == SRL    ? $signed(A) >> $signed(B) :  

             alu_op == SRAI  ||
             alu_op == SRA    ? $signed($signed(A) >>> B) :

             alu_op == SLTIU ?  A < B                  :

             alu_op == SLTI  ||
             alu_op == SLT    ? $signed(A) < $signed(B) :

             alu_op == AND   ||
             alu_op == ANDI   ? A & B                  :

             alu_op == OR    ||
             alu_op == ORI    ? A | B                  :

             alu_op == XOR   ||
             alu_op == XORI   ? A ^ B                  :

                               {DATA_WIDTH{1'b0}}; 


endmodule
