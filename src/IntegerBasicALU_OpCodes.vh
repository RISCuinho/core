`define ALU_OP_PLUS             5'b00001 // Soma
`define ALU_OP_SUB              5'b00010 // Subtração

`define ALU_OP_SHIFT_LEFT       5'b01001 // Shift Left
`define ALU_OP_SHIFT_RIGHT      5'b01010 // Shift Right
`define ALU_OP_SHIFT_RIGHT_A    5'b01011 // Shift Right Aritimético
`define ALU_OP_SHIFT_LEFT_U     5'b01111 // Shift Left Sem sinal

`define ALU_OP_SET_LESS_THAN_U  5'b10001 // Seta bit se "menor que" sem considerar o sinal
`define ALU_OP_SET_LESS_THAN    5'b10010 // Seta bit se "menor que" considerando o sinal

`define ALU_OP_AND              5'b10101 // "E" comum
`define ALU_OP_OR               5'b10110 // "Ou" comum
`define ALU_OP_XOR              5'b10111 // "Ou exclusivo"
