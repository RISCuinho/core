# RISC-V RV32I program using store and load instructions
#
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: Apr 2020
#
#==============================
# RISC-V instruction formats/examples (instruction generator https://www.vicilogic.com/vicilearn/run_step/?s_id=960)

# S-type format for sw instruction, sw rs1,imm(rs2)
# e.g, sw x10,8(x2)  
# S-type     imm(11:5)   rs2      rs1   f3   imm(4:0)  opcode
# hex (0x): [  0    0      a     1     2       4     2     3
# bin (ob): [0000 000][0 1010] [0001 0][010] [0100 0][010 0011]

# I-type format for lw instruction, lw rd, rs1, imm
# e.g, lw x11,8(x2)  
# I-type       imm(11:0)         rs1    f3    rd      opcode
# hex (0x): [  0    0    8     1      2      5     8      3
# bin (ob): [0000 0000 1000] [0001 0][010] [0101 1] [000 0011]
#
#==============================
# RISC-V instruction formats/examples (instruction generator https://tinyurl.com/whsk5k4)

# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: reference [8], vicilogic RISC-V Architecture and Applications 

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

# [1] code for ~1 second delay 
# https://www.vicilogic.com/static/ext/RISCV/programExamples/exercises/programBasedDelayLoop_ToggleX10Bit0_or_invertX10.asm

# Default imm format is decimal 0d

# User x0-x31 registers or thier ABI register names   
# https://github.com/riscv/riscv-asm-manual/blob/master/riscv-asm.md

# ===========================
# Remote RISC-V processor:
#   data/stack size is 256 bytes, byes addresses 0x00-0xff.
#   All addresses 0x0-0xffffffff alias to 0x0-0xff (except addresses 0x401-0x403)
# =================================================================

# assembly program             # Notes  (default imm format is decimal 0d)
main:
 # setup base address and x10 register data to write to memory
 addi x2,x0,0xf4    # assign memory base address = 0xf4
 lui  x10,0xfeedc   # x10 = 0xfeedc000
 addi x10,x10,0x0de # x10 = data value A = 0xfeedc0de

 # store register to memory mem(base address + offset); word (32-bit), half-word (16-bit), byte (8-bit)
 sw x10, 0x8(x2)    # Store A(31:0), word,      in mem(0xfc), i.e, base byte address + 8, i.e, mem(0xfc)

 # load from mem(x2); word (32-bit), half-word (16-bit), byte (8-bit), signed (default)/unsigned
 lw  x11,8(x2)      # load mem(0xfc)(31:0), word,               to register x11
 
 1b: jal zero,1b   	# repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	

============================
Post-assembly program listing
PC instruction  basic assembly  original assembly   Notes
      (31:0)        code              code 
# setup base address and x10 register data to write to memory
0x0f400113	addi x2 x0 244	addi x2,x0,0xf4 # assign memory base address = 0xf4
0xfeedc537	lui x10 1044188	lui x10,0xfeedc # x10 = 0xfeedc000
0x0de50513	addi x10 x10 222	addi x10,x10,0x0de # x10 = data value A = 0xfeedc0de
# store register to memory mem(base address + offset); word (32-bit), half-word (16-bit), byte (8-bit)
0x00a12423	sw x10 8(x2)	sw x10, 0x8(x2) # Store A(31:0), word, in mem(0xfc), i.e, base byte address + 8, i.e, mem(0xfc)
# load from mem(x2); word (32-bit), half-word (16-bit), byte (8-bit), signed (default)/unsigned
0x00812583	lw x11 8(x2)	lw x11,8(x2) # load mem(0xfc)(31:0), word, to register x11
0x0000006f	jal x0 0	1b: jal zero,1b # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	

============================
Venus 'dump' program binary.  
0f400113
feedc537
0de50513
00a12423
00812583
0000006f

============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, format: m = mod(n/8)+1 
0f400113feedc5370de5051300a12423008125830000006f0000000000000000
