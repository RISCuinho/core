# RISC-V constant shift instruction examples (slli, srli, srai)
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: May 2020
#
# Syntax: instr rd, rs1, constant,  e.g, add x8, x4, 3
# rd = instr rs1 + rs2 
# where instr is slli, srli, srai 
#
# instruction  f7(6:0)  shamt(4:0) rs1(4:0)  f3(2:0)  rd(4:0))  opcode(6:0)   description
# slli         0000000                        001                0010011    constant shift left logical (immediate)      rd = rs1 << rs2
# srli         0000000                        101                0010011    constant shift right logical (immediate)     rd = rs1 >> rs2
# srai         0100000                        101                0010011    constant shift right arithmetic (immediate)  rd = rs1 >> rs2 arithmetic
#
#Examples
# RISC-V instruction formats/examples (instruction generator https://www.vicilogic.com/vicilearn/run_step/?s_id=960)
#==============================
# instruction format (I-type), e.g, slli x8, x4, 3
# I-type    imm(11:0)=[0x003] rs1=[4] f3=[1]  rd=[8]    opcode
# hex (0x): [  0    0    3 ]    2      1       4       1    3
# bin (ob): [0000 0000 0011] [0010 0][001]  [0100   0][001 0011]
		   
# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: reference [8], vicilogic RISC-V Architecture and Applications 

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

#============================

# assembly program              # Notes  (default imm format is decimal 0d)
# Program modifies registers x2-x8
main:
# initialise x1=2 and x2=-5 (0xfffffffb)
addi  x1,  x0, 3                # x1   = x0 + 3 = 3   rs1 = x0 (always 0) + imm offset = 3 
addi  x2,  x1, -5               # x2   = x1 - 5 = 3 + 0xfffffffb (-5 sign-extended to 32-bits) = -2 (0xfffffffe)   

slli  x3,  x1, 1                # x3   = 0b110        shift 0b11       logical left 1 bit
slli  x4,  x2, 12               # x4   = 0xffffe000   shift 0xfffffffe logical left 12 bits
slli  x5,  x1, 31               # x5   = 0x80000000   shift 0b11       logical left 31 bits. Bit 1 drops off to left

srli  x6,  x1, 1                # x6   = 0b1          shift 0b11       logical right 1 bit 
srli  x7,  x2, 1                # x7   = 0x7fffffff,  shifts 0 into bit 31. Shifts (31:1) to (30:0). Bit 0 drops off to right
srli  x8,  x2, 28               # x8   = 0x0000000f,  shifts 0s into bits (31:4). Shifts (31:28) to (3:0). Bits (27:0) drop off to right

srai  x9,  x5, 1                # x9   = 0xc0000000,  shift 1 into bit 31. Shift bits (31:1) to (30:0). Bit 0 drops off to right
srai  x10, x5, 3                # x10  = 0xf0000000,  shifts 1s into bits (31:29). Shifts (28:3) to (25:0). Bits (2:0) drop off to right
srai  x11, x5, 30               # x11  = 0xfffffffe,  shifts 1s into bits (31:2). Shifts (31:30) to (1:0). Bits (29:0) drop off to right

1b:   jal zero,1b   		    # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	

============================
Post-assembly program listing
PC instruction  basic assembly  original assembly   Notes
      (31:0)        code              code 
# initialise x1=2 and x2=-5 (0xfffffffb)
00 0x00300093	addi x1 x0 3	addi x1, x0, 3     # x1 = x0 + 3 = 3 rs1 = x0 (always 0) + imm offset = 3
04 0xffb08113	addi x2 x1 -5	addi x2, x1, -5    # x2 = x1 - 5 = 3 + 0xfffffffb (-5 sign-extended to 32-bits) = -2 (0xfffffffe)
08 0x00109193	slli x3 x1 1	slli x3, x1, 1     # x3 = 0b110        shift 0b11       logical left 1 bit
0c 0x00c11213	slli x4 x2 12	slli x4, x2, 12    # x4 = 0xffffe000   shift 0xfffffffe logical left 12 bits
10 0x01f09293	slli x5 x1 31	slli x5, x1, 31    # x5 = 0x80000000   shift 0b11       logical left 31 bits. Bit 1 drops off to left 
14 0x0010d313	srli x6 x1 1	srli x6, x1, 1     # x6 = 0b1          shift 0b11       logical right 1 bit 
18 0x00115393	srli x7 x2 1	srli x7, x2, 1     # x7 = 0x7fffffff,  shifts 0 into bit 31. Shifts (31:1) to (30:0). Bit 0 drops off to right
1c 0x01c15413	srli x8 x2 28	srli x8, x2, 28    # x8 = 0x0000000f,  shifts 0s into bits (31:4). Shifts (31:28) to (3:0). Bits (27:0) drop off to right
20 0x4012d493	srai x9 x5 1	srai x9, x5, 1     # x9 = 0xc0000000,  shift 1 into bit 31. Shift bits (31:1) to (30:0). Bit 0 drops off to right
24 0x4032d513	srai x10 x5 3	srai x10, x5, 3    # x10 = 0xf0000000, shifts 1s into bits (31:29). Shifts (28:3) to (25:0). Bits (2:0) drop off to right
28 0x41e2d513	srai x11 x5 30	srai x10, x5, 30   # x10 = 0xfffffffe, shifts 1s into bits (31:2). Shifts (31:30) to (1:0). Bits (29:0) drop off to right
2c 0x0000006f	jal x0 0	    1b: jal zero,1b    # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b

============================
Venus 'dump' program binary
00300093
ffb08113
00109193
00c11213
01f09293
0010d313
00115393
01c15413
4012d493
4032d513
41e2d513
0000006f

https://www.vicilogic.com/vicilearn/edit_step/?s_id=931
============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions. format: m = mod(n/8)+1  
00300093ffb081130010919300c1121301f092930010d3130011539301c15413
4012d4934032d51341e2d5130000006f00000000000000000000000000000000



00300093ffb08113000000000000000000000000000000000000000000000000
