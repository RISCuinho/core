// 12'd4096 =  12'h1000
// Counters and Timers
// read-only CSR registers 0xC00–0xC1F (12BITS)
// with the upper 32 bits accessed via CSR registers 0xC80–0xC9F on RV32
`define CSR_COUNTERS_TIMERS_DATA_SIZE                 32
`define CSR_COUNTERS_TIMERS_START                     32'h01000C00
`define CSR_COUNTERS_TIMERS_END                       32'h01000C1F
`define CSR_COUNTERS_TIMERS_START_H                   32'h01000C80
`define CSR_COUNTERS_TIMERS_END_H                     32'h01000C9F
