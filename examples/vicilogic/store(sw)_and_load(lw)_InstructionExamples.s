# RISC-V example data and stack 
#  store word (sw) and load word (lw) instructions
# Memory (MEM) write / read access
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: Mar 2020
#
#==============================
# RISC-V instruction formats/examples (instruction generator https://tinyurl.com/whsk5k4)

# S-type format for sw instruction, sw rs1,imm(rs2)
# e.g, sw x11,4(x2)        [similar to NUI Galway SCC processor instruction MOVBAMEM @(x2+4),x11 ] 
# S-type       imm(11:0)       rs1    f3     rd    opcode
# hex (0x): [  0    0    2     5      a      2    2      3
# bin (ob): [0000 0000 0010] [0101 1][010] [001 0][010 0011]

# I-type format for lw instruction, lw rd, rs1, imm
# e.g, lw x11,4(x2)        [similar to NUI Galway SCC processor instruction MOVAMEMR x11, @(x2+4) ]
# I-type       imm(11:0)         rs1    f3    rd      opcode
# hex (0x): [  0    0    4     1      2      5     8      3
# bin (ob): [0000 0000 0100] [0001 0][010] [0101 1] [000 0011]


# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# Venus https://www.kvakil.me/venus/

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

# [1] code for ~1 second delay 
# https://www.vicilogic.com/static/ext/RISCV/programExamples/exercises/programBasedDelayLoop_ToggleX10Bit0_or_invertX10.asm

# Default imm format is decimal 0d

# [2] vicilogic RISC-V (RISC-vici-1) data/stack memory and peripherals description
#   https://tinyurl.com/yx7mgjch     
# Example program for peripheral memory devices write and read 
#   https://www.vicilogic.com/static/ext/RISCV/programExamples/exercises/peripheralMemoryWriteAndRead.asm

# ============================
# assembly program            # Notes  (default imm format is decimal 0d)

addi x11,x0,255     # initialise data x11 = 0xff 
addi x2,x0,0xe0     # initialise MEM base address in x2

# Write 0xff to a series of MEM(x2+offset) locations, 
sw   x11,   0(x2)   # store to MEM(0xe0+0)
sw   x11,   4(x2)   # store to MEM(0xe4)
sw   x11,   8(x2)   # store to MEM(0xe8) 
sw   x11, 0xc(x2)   # store to MEM(0xec) 
sw   x11, 0x10(x2)  # store to MEM(0xf0) 
sw   x11, 0x14(x2)  # store to MEM(0xf4) 
sw   x11, 0x18(x2)  # store to MEM(0xf8) 
sw   x11, 0x1c(x2)  # store to MEM(0xfc) 

# Refer to [2]. Crossing upper 256 byte (64 x 32-bit) MEM boundary 
# data/stack memory uses only lower 8-bits of address  
sw   x11, 0x20(x2)  # store to MEM(0xe0+0x20) = MEM(0x100). Alias to MEM(0)
sw   x11, 0x24(x2)  # store to MEM(0xe0+0x24) = MEM(0x104). Alias to MEM(0x4)

# read data from two data/stack locations
lw   x12, 0x1c(x2)  # load from MEM(0xfc). Expect 0xff
lw   x13, 0x24(x2)  # load from MEM(0x14). Alias MEM(0x4). Expect 0xff


addi x11,x11,-1     # Change data x11 = 0xfe
addi x2,x0,0        # initialise MEM base address = 0
# Refer to [2]. Crossing lower 256 byte (64 x 32-bit) MEM boundary 
# data/stack memory uses only lower 8-bits of address  
# Alias MEM(0xfffffffc) is MEM(0xfc) for 256 byte data/stack memory size. 
sw   x11, -4(x2)  # store to  MEM(0xfffffffc). Alias MEM(0xfc)
lw   x13, -4(x2)  # load from MEM(0xfffffffc). Alias MEM(0xfc). Expect 0xfe

end: beq x0,x0,end

============================
Post-assembly program listing
PC instruction    basic assembly     original assembly             Notes
     (31:0)        code                 code 
00  0x0ff00593	addi x11 x0 255	addi x11,x0,255 # initialise data x11 = 0xff
04  0x0e000113	addi x2 x0 224	addi x2,x0,0xe0 # initialise MEM base address in x2
08  0x00b12023	sw x11 0(x2)	sw x11, 0(x2) # store to MEM(0xe0+0)
0c  0x00b12223	sw x11 4(x2)	sw x11, 4(x2) # store to MEM(0xe4)
10  0x00b12423	sw x11 8(x2)	sw x11, 8(x2) # store to MEM(0xe8)
14  0x00b12623	sw x11 12(x2)	sw x11, 0xc(x2) # store to MEM(0xec)
18  0x00b12823	sw x11 16(x2)	sw x11, 0x10(x2) # store to MEM(0xf0)
1c  0x00b12a23	sw x11 20(x2)	sw x11, 0x14(x2) # store to MEM(0xf4)
20  0x00b12c23	sw x11 24(x2)	sw x11, 0x18(x2) # store to MEM(0xf8)
24  0x00b12e23	sw x11 28(x2)	sw x11, 0x1c(x2) # store to MEM(0xfc)
28  0x02b12023	sw x11 32(x2)	sw x11, 0x20(x2) # store to MEM(0xe0+0x20) = MEM(0x100). Alias to MEM(0)
2c  0x02b12223	sw x11 36(x2)	sw x11, 0x24(x2) # store to MEM(0xe0+0x24) = MEM(0x104). Alias to MEM(0x4)
30  0x01c12603	lw x12 28(x2)	lw x12, 0x1c(x2) # load from MEM(0xfc). Expect 0xff
34  0x02412683	lw x13 36(x2)	lw x13, 0x24(x2) # load from MEM(0x14). Alias MEM(0x4). Expect 0xff
38  0xfff58593	addi x11 x11 -1	addi x11,x11,-1 # Change data x11 = 0xfe
3c  0x00000113	addi x2 x0 0	addi x2,x0,0 # initialise MEM base address = 0
40  0xfeb12e23	sw x11 -4(x2)	sw x11, -4(x2) # store to MEM(0xfffffffc). Alias MEM(0xfc)
44  0xffc12683	lw x13 -4(x2)	lw x13, -4(x2) # load from MEM(0xfffffffc). Alias MEM(0xfc). Expect 0xfe
48  0x00000063	beq x0 x0 0	end: beq x0,x0,end


============================
Venus 'dump' program binary 
0ff00593
0e000113
00b12023
00b12223
00b12423
00b12623
00b12823
00b12a23
00b12c23
00b12e23
02b12023
02b12223
01c12603
02412683
fff58593
00000113
feb12e23
ffc12683
00000063

============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
0ff005930e00011300b1202300b1222300b1242300b1262300b1282300b12a23
00b12c2300b12e2302b1202302b1222301c1260302412683fff5859300000113
feb12e23ffc12683000000630000000000000000000000000000000000000000
