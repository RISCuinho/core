// Mapeamento de Memória para DBC - Data Busc Control
`define DBC_RAM_START                                 32'h00000000
`define DBC_RAM_END                                   32'h000001FF
`define DBC_RAM_SIZE                                  (`DBC_RAM_END - `DBC_RAM_START)
//`ifndef XILINX_ISIM
//`define DBC_RAM_ADDR_WIDTH                            ($clog2(`DBC_RAM_END - `DBC_RAM_START+1))
//`else
`define DBC_RAM_ADDR_WIDTH                            15
//`endif

`define DBC_RAM_GLASS_START                           32'h7ffff000
`define DBC_RAM_GLASS_END                             32'h7ffff1FF

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
`define DBC_REGISTER_START                            32'h01000000
`define DBC_REGISTER_END                              32'h01000003

`define DBC_REGISTER_BUS_BUSY_ADDR                    32'h01000000
`define DBC_REGISTER_BUS_BUSY_BITS                    8'h1
`define DBC_REGISTER_BUS_BUSY_START_BIT               8'h0        // bit 0

`define DBC_REGISTER_MISALIGNED_EXCEPTION_ADDR        32'h01000000
`define DBC_REGISTER_MISALIGNED_EXCEPTION_BITS        8'h1
`define DBC_REGISTER_MISALIGNED_EXCEPTION_START_BIT   8'h1   // bit 1

`define DBC_REGISTER_EMPTY_ADDR_EXCPETION_ADDR        32'h01000000
`define DBC_REGISTER_EMPTY_ADDR_EXCEPTION_BITS        8'h1
`define DBC_REGISTER_EMPTY_ADDR_EXCEPTION_START_BIT   8'h7   // bit 7

`define DBC_REGISTER_LAST_DATA_ADDR                   32'h01000004
`define DBC_REGISTER_LAST_DATA_BITS                   128   
`define DBC_REGISTER_LAST_DATA_START_BIT              0   // bit 1
`define DBC_REGISTER_LAST_DATA_END_BIT                127
