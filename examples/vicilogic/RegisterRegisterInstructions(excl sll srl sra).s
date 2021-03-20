# RISC-V integer register-register instruction examples (excluding shift instructions)
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: May 2020
#
# Syntax: instr rd, rs1, rs2,  e.g, add x8, x4, x5
# rd = instr rs1 + rs2 
# where instr is add, sub, sll, slt, sltu, xor, srl, sra, or, and 
# excluding sll, srl, sra instructions
#
# opcode(6:0) = 0110011 (fixed)
# instruction  f7(6:0) f3(1:0)  opcode(6:0)   description
# add          0000000   000      0110011    add (register)                     rd = rs1 + rs2
# sub          0100000   000      0110011    subtract (register)                rd = rs1 - rs2
# slt          0000000   010      0110011    set less than (register)           rd = 1 if signed(rs1)   < signed(rs2),   else 0  
# sltu         0000000   011      0110011    set less than unsigned (register)  rd = 1 if unsigned(rs1) < unsigned(rs2), else 0  
# xor          0000000   100      0110011    xor (register)                     rd = rs1 xor rs2
# or           0000000   110      0110011    or (register)                      rd = rs1 or rs2
# and          0000000   111      0110011    and (register)                     rd = rs1 and rs2
#
#Examples
# RISC-V instruction formats/examples (instruction generator https://tinyurl.com/whsk5k4)
#==============================
R-type format for instruction add x8, x4, x5    
instruction(31:0)   (31:25)   (24:20)  (19:15) (14:12)  (11:7)      (6:0)   
                    f7(6:0)  rs2(4:0) rs1(4:0) f3(2:0) rd(4:0)   opcode(6:0)
             0b   (0000 000) (0 0101) (0010 0) (000)  (0010  1) (011 0011)
             0x     0    0       5       1     0        5      b     3
		   
# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: https://www.vicilogic.com/vicilearn/run_step/?s_id=1452

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

#============================

# assembly program              # Notes  (default imm format is decimal 0d)
main:
# initialise x1=2 and x2=-5 (0xfffffffb)
addi  x1,  x0, 3                # x1   = x0 + 3 = 3   rs1 = x0 (always 0) + imm offset = 3 
addi  x2,  x1, -5               # x2   = x1 - 5 = 3 + 0xfffffffb (-5 sign-extended to 32-bits) = -2 (0xfffffffe)   

add   x3,  x1, x2               # x3   = x1 and x2 
sub   x4,  x1, x2               # x4   = x1 sub x2 
slt   x5,  x1, x2               # x5   = rd = 1 if signed(x1)   < signed(x2),   else 0  
slt   x6,  x2, x1               # x6   = rd = 1 if signed(x2)   < signed(x1),   else 0  
sltu  x7,  x1, x2               # x7   = rd = 1 if unsigned(x1) < unsigned(x2), else 0  
sltu  x8,  x2, x1               # x8   = rd = 1 if unsigned(x2) < unsigned(x1), else 0  
xor   x9,  x1, x2               # x9   = x1 xor x2 
or    x10, x1, x2               # x10  = x1 or x2
and   x11, x1, x2               # x11  = x1 and x2 
1b:   jal zero,1b   		    # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	

============================
Post-assembly program listing
PC instruction  basic assembly  original assembly   Notes
      (31:0)        code              code 
# initialise x1=2 and x2=-5 (0xfffffffb)
00 0x00300093	addi x1 x0 3	addi x1, x0, 3     # x1  = x0 + 3 = 3 rs1 = x0 (always 0) + imm offset = 3
04 0xffb08113	addi x2 x1 -5	addi x2, x1, -5    # x2  = x1 - 5 = 3 + 0xfffffffb (-5 sign-extended to 32-bits) = -2 (0xfffffffe)

08 0x002081b3	add x3 x1 x2	add x3, x1, x2     # x3  = x1 and x2
0c 0x40208233	sub x4 x1 x2	sub x4, x1, x2     # x4  = x1 sub x2
10 0x0020a2b3	slt x5 x1 x2	slt x5, x1, x2     # x5  = rd = 1 if signed(x1) < signed(x2), else 0
14 0x00112333	slt x6 x2 x1	slt x6, x2, x1     # x6  = rd = 1 if signed(x2) < signed(x1), else 0
18 0x0020b3b3	sltu x7 x1 x2	sltu x7, x1, x2    # x7  = rd = 1 if unsigned(x1) < unsigned(x2), else 0
1c 0x00113433	sltu x8 x2 x1	sltu x8, x2, x1    # x8  = rd = 1 if unsigned(x2) < unsigned(x1), else 0
20 0x0020c4b3	xor x9 x1 x2	xor x9, x1, x2     # x9  = x1 xor x2
24 0x0020e533	or x10 x1 x2	or x10, x1, x2     # x10 = x1 or x2
28 0x0020f5b3	and x11 x1 x2	and x11, x1, x2    # x11 = x1 and x2
2c 0x0000006f	jal x0 0		1b: jal zero,1b    # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b

============================
Venus 'dump' program binary
00300093
ffb08113
002081b3
40208233
0020a2b3
00112333
0020b3b3
00113433
0020c4b3
0020e533
0020f5b3
0000006f


https://www.vicilogic.com/vicilearn/edit_step/?s_id=931
============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions. format: m = mod(n/8)+1  
00300093ffb08113002081b3402082330020a2b3001123330020b3b300113433
0020c4b30020e5330020f5b30000006f00000000000000000000000000000000
