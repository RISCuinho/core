module InstructionDecoderCSO (
   input        E,
   input [31:0] instr,
   output [ 4:0] rd_sel, rs1_sel,
   input [31:0] rd_data, rs1_data
);

wire [ 6:0] code    = instr[6:0];

wire TYPE_IF  = code == 7'b0001111;
wire TYPE_IC  = code == 7'b1110011;
wire TYPE_IL  = code == 7'b0000011;
wire TYPE_I   = code == 7'b0010011 || code == TYPE_IL || code == TYPE_IC || code == TYPE_IF;

wire [ 2:0] FN3     = instr[14:12];
wire [ 3:0] FN4_A   = instr[31:28];
wire [ 3:0] FN4_B   = instr[27:24];
wire [ 3:0] FN4_C   = instr[23:20];
wire [ 4:0] FN5     = instr[11:7];
wire [ 6:0] FN7     = instr[31:25];
wire [11:0] FN12    = instr[31:20];

wire FENCE   = TYPE_IF && FN3 == 3'b000 && FN5 == 5'b00000 && 
               FN4_A == 4'b0000;
wire FENCE_I = TYPE_IF && FN3 == 3'b001 && FN5 == 5'b00000 && 
               FN4_A == 4'b0000 && FN4_B == 4'b0000 && FN4_C == 4'b0000;
wire ECAL    = TYPE_IC && FN3 == 3'b000 && FN5 == 5'b00000 &&
               FN12 == 12'b00000000000;
wire EBREAK  = TYPE_IC && FN3 == 3'b000 && FN5 == 5'b00000 &&
               FN12 == 12'b00000000001;

wire CSRRW    = TYPE_IC && FN3 == 3'b001;
wire CSRRS    = TYPE_IC && FN3 == 3'b010;
wire CSRRC    = TYPE_IC && FN3 == 3'b011;
wire CSRRWI   = TYPE_IC && FN3 == 3'b101;
wire CSRRSI   = TYPE_IC && FN3 == 3'b110;
wire CSRRCI   = TYPE_IC && FN3 == 3'b111;

wire SYNCH   = FENCE || FENCE_I;
wire SYSTEM  = ECAL || EBREAK;
wire CONTROL = CSRRW || CSRRS || CSRRC || CSRRWI || CSRRSI || CSRRCI;


assign rd_sel       = TYPE_I                                    ? instr[11:7] : 5'bx;

assign rs1_sel      = CSRRW  || CSRRS  || CSRRC ||
                      (TYPE_I && !(CONTROL || SYNCH || SYSTEM)) ? instr[19:15] : 5'bx;

endmodule
