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
// ## Configura Dump de mémoria e registradores
// ## esta configuração deve ser desativada nos 
// ## branchs que wires para FPGA
//`ifndef __RISCUIN_DUMP
`define RISCUIN_DUMP             1
`define RISCUIN_DUMP_COUNT_CLOCK 1300
`define RISCUIN_DUMP_COUNT_PC    1350
`define RISCUIN_DUMP_PC_END      1
`define RISCUIN_DUMP_FILE_DBC "RISCuin_DataBusControl.dump"
`define RISCUIN_DUMP_FILE_RB  "RISCuin_RegisterBank.dump"
//`endif
// ## finaliza configuração do DUMP
`define RISCUIN_WATCHDOG_START    5   // CLOCKS PARA INICIALIZAR O PROCESSADOR, ORIGINALMENTE 30
`define RISCUIN_WATCHDOG_TIMEOUT  70  // CLOCKS PARA REINICIALIZAR O PROCESSAOR CASO NÃO SEJA GERADO EXCEÇÃO TIMEOUT
`define RISCUIN_WATCHDOG_RST      700 // CLOCKS PARA RESETAR O PROCESSADOR APÓS ELE TER INICIALIZADO
`define RISCUIN_CLOCK_WAIT_FINISH 20  // CLOCKS PARA ESPERAR PARA FINISH DEPOIS DO SINAL DE HALT/PC_END/INTERNAL_RST/FINISH_RST
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
