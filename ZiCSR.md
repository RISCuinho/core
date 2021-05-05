“Zicsr”, Instruções de Controle e Registradores de Status (CSR) Versão 2.0
==========================================================================

O RISC-V define um espaço de endereçamento especial de 4096 posições, Registradores de Controle e Status associados com cada hart. o Capítulo 10 da RISC-V Spec Draft 20210402 define o conjunto completo de instruções CSR que operam estes CSRs. 

| fn12 | xxxxx | fn3 |  rd  |  icode  | Instruction |
| ---- | ----- | --- | ---- | ------- | ----------- | 
| csr  |  rs1  | 001 |  rd  | 1110011 | CSRRW       |
| csr  |  rs1  | 010 |  rd  | 1110011 | CSRRS       |
| csr  |  rs1  | 011 |  rd  | 1110011 | CSRRC       |
| csr  | uimm  | 101 |  rd  | 1110011 | CSRRWI      |
| csr  | uimm  | 110 |  rd  | 1110011 | CSRRSI      |
| csr  | uimm  | 111 |  rd  | 1110011 | CSRRCI      |

A tabela acima lista as instruções CSR.

Abaixo listo os endereços dos registradores CSR. Timers contadores e ponto-flutuantes. Mais detalhes na especificação.

Floating-Point Control and Status Registers
| Number | Privilege | Name | Description |
| ------ | --------- | ---- | ----------- |
| 0x001 | Read/write | fflags | Floating-Point Accrued Exceptions. |
| 0x002 | Read/write | frm    | Floating-Point Dynamic Rounding Mode. |
| 0x003 | Read/write | fcsr | Floating-Point Control and Status Register (frm + fflags). |

Counters and Timers
| Number | Privilege |   Name   | Description |
| ------ | --------- | -------- | ----------- |
| 0xC00  | Read-only | cycle    | Cycle counter for RDCYCLE instruction. |
| 0xC01  | Read-only | time     | Timer for RDTIME instruction. |
| 0xC02  | Read-only | instret  | Instructions-retired counter for RDINSTRET instruction. |
| 0xC80  | Read-only | cycleh   | Upper 32 bits of cycle, RV32I only. |
| 0xC81  | Read-only | timeh    | Upper 32 bits of time, RV32I only. |
| 0xC82  | Read-only | instreth | Upper 32 bits of instret, RV32I only. |
