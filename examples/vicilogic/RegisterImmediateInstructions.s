# RISC-V integer register immediate instruction examples 
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: Apr 2020
#
# Syntax: instr rd, rs1, imm,  e.g, slti x7, x2, 3
# rd = instr [sign-extended imm(11:0) , rs1(*)]
# where instr is addi, slti, sltiu, xori, ori, andi
# excluding instruction slli, srli, srai instructions
#
# opcode(6:0) = 0010011 (fixed)
# f3(1:0)= 000 addi,  add immedate,                     rd = rs1 + sign-extended imm(11:0)  
# f3(1:0)= 001 slti,  set less than immediate,          rd = 1 if rs1 < sign-extended imm(11:0), else 0  
# f3(1:0)= 011 sltiu, set less than immediate unsigned, rd = 1 if rs1 < unsigned-extended imm(11:0), else 0  
# f3(1:0)= 100 xori,  xor immedate,                     rd = rs1 xor sign-extended imm(11:0)  
# f3(1:0)= 110 ori,   or  immedate,                     rd = rs1 or  sign-extended imm(11:0)  
# f3(1:0)= 111 andi,  and immedate,                     rd = rs1 and sign-extended imm(11:0)  
#
#
#Examples
# RISC-V instruction formats/examples (instruction generator https://tinyurl.com/whsk5k4)
#==============================
I-type format for instruction addi x2, x1, -2.    
#  12-bit siged format for -2 = 0b1111 1111 1110 = 0xffe
#  12-bit siged format for +2 = 0b0000 0000 0010 = 0x002 
#                 Invert bits = 0b1111 1111 1101  
#                       Add 1 = 0b1111 1111 1110 = 0xffe
#
# I-type    imm(11:0)=[0xffe] rs1=[1] f3=[0] rd=[2]   opcode
# hex (0x): [  f    f    e ]    0      8       1       1    3
# bin (ob): [1111 1111 1110] [0000 1] [000] [0001   0][001 0011]
#
# instruction format (I-type), e.g, slti x7, x2, 3
# I-type    imm(11:0)=[0x003] rs1=[2] f3=[2]  rd=[7]    opcode
# hex (0x): [  0    0    3 ]    1      2       3       9    3
# bin (ob): [0000 0000 0011] [0001 0] [010] [0011   1][001 0011]
#

# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: https://www.vicilogic.com/vicilearn/run_step/?s_id=1452

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

#============================

# assembly program              # Notes  (default imm format is decimal 0d)
main:
addi  x1,  x0, 3                # x1  = x0 + 3 = 3    rs1 = x0 (always 0) + imm offset = 3 
addi  x2,  x1, -5               # x2  = x1 - 5 = 3 + 0xfffffffb (-5 sign-extended to 32-bits) = -2 (0xfffffffe)   
xori  x3,  x1, 0xa              # x3  = x1 xor 0b1010 = 0b0011 xor 0b1010 = 0b1001
ori   x4,  x1, 0xa              # x4  = x1 or  0b1010 = 0b0011 or  0b1010 = 0b1011
andi  x5,  x1, 0xa              # x5  = x1 and 0b1010 = 0b0011 and 0b1010 = 0b0010
slti  x6,  x1, 4                # x6  = 1 if x1 (3)  < sign-extended (4),  else 0. Result = 1
slti  x7,  x1, 3                # x7  = 1 if x1 (3) < sign-extended (3),   else 0. Result = 0
slti  x8,  x2, -1               # x8  = 1 if x2 (-2) < sign-extended (-1), else 0. Result = 1
slti  x9,  x2, -3               # x9  = 1 if x2 (-2) < sign-extended (-3), else 0. Result = 0
sltiu x10, x2, -1               # x10 = 1 if x2 (0xfffffffe unsigned) < -1 (unsigned-extended = 0xffffffff), else 0. Result = 1
sltiu x11, x2, -2               # x11 = 1 if x2 (0xfffffffe unsigned) < -2 (unsigned-extended = 0xfffffffe), else 0. Result = 0
1b: jal zero,1b   		        # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	

============================
Post-assembly program listing
PC instruction  basic assembly  original assembly   Notes
      (31:0)        code              code 
00 0x00300093	addi x1 x0 3	addi x1, x0, 3    # x1 = x0 + 3 = 3 rs1 = x0 (always 0) + imm offset = 3
04 0xffb08113	addi x2 x1 -5	addi x2, x1, -5   # x2 = x1 - 5 = 3 + 0xfffffffb (-5 sign-extended to 32-bits) = -2 (0xfffffffe)
08 0x00a0c193	xori x3 x1 10	xori x3, x1, 0xa  # x3 = x1 xor 0b1010 = 0b0011 xor 0b1010 = 0b1001
0c 0x00a0e213	ori x4 x1 10	ori x4, x1, 0xa   # x4 = x1 or 0b1010 = 0b0011 or 0b1010 = 0b1011
10 0x00a0f293	andi x5 x1 10	andi x5, x1, 0xa  # x5 = x1 and 0b1010 = 0b0011 and 0b1010 = 0b0010
14 0x0040a313	slti x6 x1 4	slti x6, x1, 4    # x6 = 1 if x1 (3) < sign-extended (4), else 0. Result = 1
18 0x0030a393	slti x7 x1 3	slti x7, x1, 3    # x7 = 1 if x1 (3) < sign-extended (3), else 0. Result = 0
1c 0xfff12413	slti x8 x2 -1	slti x8, x2, -1   # x8 = 1 if x2 (-2) < sign-extended (-1), else 0. Result = 1
20 0xffd12493	slti x9 x2 -3	slti x9, x2, -3   # x9 = 1 if x2 (-2) < sign-extended (-3), else 0. Result = 0
24 0xfff13513	sltiu x10 x2 -1	sltiu x10, x2, -1 # x10 = 1 if x2 (0xfffffffe unsigned) < -1 (unsigned-extended = 0xffffffff), else 0. Result = 1
28 0xffe13593	sltiu x11 x2 -2	sltiu x11, x2, -2 # x10 = 1 if x2 (0xfffffffe unsigned) < -2 (unsigned-extended = 0xfffffffe), else 0. Result = 0
2c 0x0000006f	jal x0 0	    1b: jal zero,1b   # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b

============================
Venus 'dump' program binary
00300093
ffb08113
00a0c193
00a0e213
00a0f293
0040a313
0030a393
fff12413
ffd12493
fff13513
ffe13593
0000006f

https://www.vicilogic.com/vicilearn/edit_step/?s_id=931
============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions. format: m = mod(n/8)+1  
00300093ffb0811300a0c19300a0e21300a0f2930040a3130030a393fff12413
ffd12493fff13513ffe135930000006f00000000000000000000000000000000