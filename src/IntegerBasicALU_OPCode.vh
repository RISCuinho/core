`define ALU_ADD  5'b00000
`define ALU_SUB  5'b00001

`define ALU_SLL  5'b00010
`define ALU_LTS  5'b00100
`define ALU_LTU  5'b00110 // SLTU - Set if Less Than, Unsigned
`define ALU_XOR  5'b01000
`define ALU_SRL  5'b01010
`define ALU_SRA  5'b01011
`define ALU_OR   5'b01100
`define ALU_AND  5'b01110

// ONLY FOR BRANCH
`define B_EQ     5'b10000  
`define B_NE     5'b10001 
`define B_LT     5'b10100 
`define B_GE     5'b10101 
`define B_LTU    5'b10110 
`define B_GEU    5'b10111 
