# RISC-V register shift instruction examples(sll, srl, sra)
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: May 2020
#
# R-type syntax: instr rd, rs1, rs2, e.g, sll x8, x4, x5:        rd = rs1 << rs2  shift register rs1 data left, by rs2 bits
#
# instruction  f7(6:0)  rs2(4:0) rs1(4:0)  f3(2:0)  rd(4:0))  opcode(6:0)   description
# sll          0000000                        001                0110011    register shift left logical      rd = rs1 << rs2
# srl          0000000                        101                0110011    register shift right logical     rd = rs1 >> rs2
# sra          0100000                        101                0110011    register shift right arithmetic  rd = rs1 >> rs2 arithmetic

R-type format for instruction add x8, x4, x5    
instruction(31:0)   (31:25)   (24:20)    (19:15)   (14:12)  (11:7)      (6:0)   
                    f7(6:0)  rs2(4:0)=5 rs1(4:0)=4 f3(2:0) rd(4:0)=8 opcode(6:0)
             0b   (0000 000) (0 0101)   (0010  0)  (001)  (0100   0)  (011 0011)
             0x     0    0       5        2          1      4       3       3
		   		   
# RISC-V instruction formats/examples (instruction generator https://www.vicilogic.com/vicilearn/run_step/?s_id=960)
		   
# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: reference [8], vicilogic RISC-V Architecture and Applications 

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

#============================

# assembly program              # Notes  (default imm format is decimal 0d)
# Program modifies registers x2-x8
# Refer to ShiftImmediateInstruction(slli srli srai).asm which executes the same steps, using immediate instructions
# The use of x12-x16 provide the shift values used in the ShiftImmediateInstruction program
#
main:
# initialise data registers x1=3, x2=-2 
addi  x1,  x0, 3                # x1   = x0 + 3 = 3   rs1 = x0 (always 0) + imm offset = 3 
addi  x2,  x1, -5               # x2   = x1 - 5 = 3 + 0xfffffffb (-5 sign-extended to 32-bits) = -2 (0xfffffffe)   
#
# initialise shift value registers x12-x16 
addi  x12, x0, 1                # x12  = 1  
addi  x13, x0, 12               # x13  = 12  
addi  x14, x0, 31               # x14  = 31  
addi  x15, x0, 28               # x15  = 28  
addi  x16, x0, 3                # x16  = 3  
addi  x17, x0, 30               # x17  = 30  

sll   x3,  x1, x12              # x3   = 0b110        shift 0b11       logical left 1 bit
sll   x4,  x2, x13              # x4   = 0xffffe000   shift 0xfffffffe logical left 12 bits
sll   x5,  x1, x14              # x5   = 0x80000000   shift 0b11       logical left 31 bits. Bit 1 drops off to left
	 
srl   x6,  x1, x12              # x6   = 0b1          shift 0b11       logical right 1 bit 
srl   x7,  x2, x12              # x7   = 0x7fffffff,  shifts 0 into bit 31. Shifts (31:1) to (30:0). Bit 0 drops off to right
srl   x8,  x2, x15              # x8   = 0x0000000f,  shifts 0s into bits (31:4). Shifts (31:28) to (3:0). Bits (27:0) drop off to right
	 
sra   x9,  x5, x12              # x9   = 0xc0000000,  shift 1 into bit 31. Shift bits (31:1) to (30:0). Bit 0 drops off to right
sra   x10, x5, x16              # x10  = 0xf0000000,  shifts 1s into bits (31:29). Shifts (28:3) to (25:0). Bits (2:0) drop off to right
sra   x11, x5, x17              # x11  = 0xfffffffe,  shifts 1s into bits (31:2). Shifts (31:30) to (1:0). Bits (29:0) drop off to right

1b:   jal zero,1b   		    # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	

============================
Post-assembly program listing
PC instruction  basic assembly  original assembly   Notes
      (31:0)        code              code 
00 0x00300093	addi x1 x0 3	addi x1, x0, 3      # x1 = x0 + 3 = 3 rs1 = x0 (always 0) + imm offset = 3
04 0xffb08113	addi x2 x1 -5	addi x2, x1, -5     # x2 = x1 - 5 = 3 + 0xfffffffb (-5 sign-extended to 32-bits) = -2 (0xfffffffe)
08 0x00100613	addi x12 x0 1	addi x12, x0, 1     # x12 = 1
0c 0x00c00693	addi x13 x0 12	addi x13, x0, 12    # x13 = 12
10 0x01f00713	addi x14 x0 31	addi x14, x0, 31    # x14 = 31
14 0x01c00793	addi x15 x0 28	addi x15, x0, 28    # x15 = 28
18 0x00300813	addi x16 x0 3	addi x16, x0, 3     # x16 = 3
1c 0x01e00893	addi x17 x0 30	addi x17, x0, 30    # x17 = 30
20 0x00c091b3	sll x3 x1 x12	sll x3, x1, x12     # x3 = 0b110 shift 0b11 logical left 1 bit
24 0x00d11233	sll x4 x2 x13	sll x4, x2, x13     # x4 = 0xffffe000 shift 0xfffffffe logical left 12 bits
28 0x00e092b3	sll x5 x1 x14	sll x5, x1, x14     # x5 = 0x80000000 shift 0b11 logical left 31 bits. Bit 1 drops off to left
2c 0x00c0d333	srl x6 x1 x12	srl x6, x1, x12     # x6 = 0b1 shift 0b11 logical right 1 bit
30 0x00c153b3	srl x7 x2 x12	srl x7, x2, x12     # x7 = 0x7fffffff, shifts 0 into bit 31. Shifts (31:1) to (30:0). Bit 0 drops off to right
34 0x00f15433	srl x8 x2 x15	srl x8, x2, x15     # x8 = 0x0000000f, shifts 0s into bits (31:4). Shifts (31:28) to (3:0). Bits (27:0) drop off to right
38 0x40c2d4b3	sra x9 x5 x12	sra x9, x5, x12     # x9 = 0xc0000000, shift 1 into bit 31. Shift bits (31:1) to (30:0). Bit 0 drops off to right
3c 0x4102d533	sra x10 x5 x16	sra x10, x5, x16    # x10 = 0xf0000000, shifts 1s into bits (31:29). Shifts (28:3) to (25:0). Bits (2:0) drop off to right
40 0x4112d5b3	sra x11 x5 x17	sra x11, x5, x17    # x11 = 0xfffffffe, shifts 1s into bits (31:2). Shifts (31:30) to (1:0). Bits (29:0) drop off to right
44 0x0000006f	jal x0 0	    1b: jal zero,1b     # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b 

============================
Venus 'dump' program binary
00300093
ffb08113
00100613
00c00693
01f00713
01c00793
00300813
01e00893
00c091b3
00d11233
00e092b3
00c0d333
00c153b3
00f15433
40c2d4b3
4102d533
4112d5b3
0000006f

https://www.vicilogic.com/vicilearn/edit_step/?s_id=931
============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions. format: m = mod(n/8)+1  
00300093ffb081130010061300c0069301f0071301c007930030081301e00893
00c091b300d1123300e092b300c0d33300c153b300f1543340c2d4b34102d533
4112d5b30000006f000000000000000000000000000000000000000000000000