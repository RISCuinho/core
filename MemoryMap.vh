// Mapeamento de Memória para DBC - Data Busc Control
`define DBC_RAM_START          							8'h00000000
`define DBC_RAM_END            							8'h0000FFFF
`define DBC_RAM_SIZE											65535
/*
https://github.com/DuinOS/riscuinho/wiki/DataBusControlRegister
32 BITS (UMA WORD)
00|| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
                     |   |   |   +-- Address-misaligned exception
                     +---+---+---+-- Tamanho da última leitura  (000 -> Byte, 001 -> Half, 010 -> Word)  
01|| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |  RESERVADO
02|| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |  RESERVADO
03|| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |  RESERVADO
*/
`define DBC_REGISTER_START 							8'h01000000
`define DBC_REGISTER_END 								8'h01000003

`define DBC_REGISTER_MISALIGNED_EXCEPTION_ADDR	8'h01000000
`define DBC_REGISTER_MISALIGNED_EXCEPTION_BIT	1'h1

`define DBC_REGISTER_EMPTY_ADDR_EXCPETION_ADDR	8'h01000000
`define DBC_REGISTER_EMPTY_ADDR_EXCEPTION_BIT	1'h1

`define DBC_REGISTER_LAST_DATA_SIZE_ADDR			8'h01000000
`define DBC_REGISTER_DATA_SIZE_BITS					1'b3   
`define DBC_REGISTER_DATA_SIZE_START_BIT			1'h1   // bit 1
`define DBC_REGISTER_DATA_SIZE_END_BIT				1'h2
