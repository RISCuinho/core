// Configuration File
`ifdef __ICARUS__
`define SIMULATOR 1
`elsif __YOSYS__
`define SIMULATOR 1
`else 
`define DATA_MEMORY_WIDTH 10
`endif 

`ifdef SIMULATOR
`define MEMORY_PROG_32  "./memory/prog_32.hex"
`define MEMORY_PROG_64  "./memory/prog_64.hex"
`define MEMORY_PROG_128 "./memory/prog_128.hex"
`define MEMORY_PROG_256 "./memory/prog_256.hex"

`define DBC_USE_BUSY FALSE
`define MEM_DATA_ADDR_WIDTH 10
`define MEM_DATA_WIDTH 32
`define INTERNAL_DATA_WIDTH 32 
`define INSTR_ADDR_WIDTH 5
`else
`define MEMORY_PROG_32  "../memory/prog_32.hex"
`define MEMORY_PROG_64  "../memory/prog_64.hex"
`define MEMORY_PROG_128 "../memory/prog_128.hex"
`define MEMORY_PROG_256 "../memory/prog_256.hex"

`define MEM_DATA_ADDR_WIDTH 10
`define MEM_DATA_WIDTH 32
`define INTERNAL_DATA_WIDTH 32 
`define INSTR_ADDR_WIDTH 5
`endif
