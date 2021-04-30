`define __TANGNANO__ TRUE
`define __GOWIN__    TRUE

// Configuration File
`ifdef __ICARUS__
`define SIMULATOR 1
`elsif __YOSYS__
`define SIMULATOR 1
`else 
`define DATA_MEMORY_WIDTH 10
`endif 

`ifdef SIMULATOR
`define DBC_USE_BUSY FALSE
`define MEM_DATA_ADDR_WIDTH 10
`define MEM_DATA_WIDTH 32
`define INTERNAL_DATA_WIDTH 32 
`define INSTR_ADDR_WIDTH 5
`else
`define MEM_DATA_ADDR_WIDTH 10
`define MEM_DATA_WIDTH 32
`define INTERNAL_DATA_WIDTH 32 
`define INSTR_ADDR_WIDTH 5
`endif
