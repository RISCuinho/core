// Mapeamento de Memória para DBC - Data Busc Control
`define DBC_RAM_START          							8'h00000000
`define DBC_RAM_END            							8'h0000FFFF
`define DBC_RAM_SIZE											65535
`define DBC_RAM_ADDR_WIDTH                         16

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

`define DBC_REGISTER_BUS_BUSY_ADDR             8'h01000000
`define DBC_REGISTER_BUS_BUSY_BITS             1'h1
`define DBC_REGISTER_BUS_BUSY_START_BIT        1'h0        // bit 0

`define DBC_REGISTER_MISALIGNED_EXCEPTION_ADDR	8'h01000000
`define DBC_REGISTER_MISALIGNED_EXCEPTION_BITS	1'h1
`define DBC_REGISTER_MISALIGNED_EXCEPTION_START_BIT 1'h1   // bit 1

`define DBC_REGISTER_EMPTY_ADDR_EXCPETION_ADDR	8'h01000000
`define DBC_REGISTER_EMPTY_ADDR_EXCEPTION_BITS	1'h1
`define DBC_REGISTER_EMPTY_ADDR_EXCEPTION_START_BIT 1'h7   // bit 7

`define DBC_REGISTER_LAST_DATA_ADDR             8'h01000004
`define DBC_REGISTER_LAST_DATA_BITS					128   
`define DBC_REGISTER_LAST_DATA_START_BIT			0   // bit 1
`define DBC_REGISTER_LAST_DATA_END_BIT				127
