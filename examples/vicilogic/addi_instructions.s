# RISC-V addi instruction examples 
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: Mar 2020
#
Example: repeating addi add immediate instruction
 addi rd, rs1, imm,     # rd = rs1 + imm

#==============================
I-type format for instruction addi x2, x1, -2.    
#  12-bit siged format for -2 = 0b1111 1111 1110 = 0xffe
#  12-bit siged format for +2 = 0b0000 0000 0010 = 0x002 
#                 Invert bits = 0b1111 1111 1101  
#                       Add 1 = 0b1111 1111 1110 = 0xffe
#
# RISC-V instruction formats/examples (instruction generator https://tinyurl.com/whsk5k4)

I-type    imm(11:0)=[0xffe] rs1=[1] f3=[0] rd=[2]   opcode
hex (0x): [  f    f    e ]    0      8       1      1    3
bin (ob): [1111 1111 1110] [0000 1] [000] [0001   0][001 0011]

# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: https://www.vicilogic.com/vicilearn/run_step/?s_id=1452

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

#============================

# assembly program            # Notes  (default imm format is decimal 0d)
main:
addi x1, x0, 3                # x1 = x0 + 3       x1 = x0 (always 0) + 32-bit sign-extended immediate offset (3) 
addi x2, x1, -2               # x2 = x1 - 2       x2 = x1 + 32-bit sign-extended offset 0xfffffffe. (-2 = 0xffe as 12-bit sign-extended)
addi x3, x0, 504              # x3 = x0 + 504     imm offset uses  decimal imm offset format (0d504 prefix optional = 0x1f8 hex format)
addi x4, x2, 0x1f8            # x4 = x2 + 0x1f8   using                hex imm offset (0d504 decimal format) 
addi x5, x0, 2047             # x5 = x0 + 2047    maximum positive decimal imm offset (=0x7ff)
addi x6, x0, 0x7ff            # x6 = x0 + 0x7ff   maximum positive hex     imm offset (hex format)
addi x7, x0, -2048            # x7 = x0 - 2048    maximum negative decimal imm offset (=0x800)
addi x8, x0, -0x7ff           # x8 = x0 - 0x7ff   (maximum-1) negative hex imm offset (= -0d2047)
addi x9, x0, -0x800           # x9 = x0 - 0x800   maximum negative hex     imm offset (= -0d2048)
addi x10, x0, -0b100000000000 # x10 = x0 - 0x800  maximum negative binary  imm offset 
addi x0, x0, 0                # x0 = x0 + 0       x0 is always 0. x0 is never written, i.e, NOP (no operation) instruction
addi x0, x0, 1                # x0 = x0 + 1       No change in x0 since x0 is always = 0.
1b: jal zero,1b   		      # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	


# Using ABI register names
# assembly program           # Notes  (default imm format is decimal 0d)
main:
addi ra,zero,3               # x1 = x0 + 3       x1 = x0 (always 0) + 32-bit sign-extended immediate offset (3) 
addi sp,ra,-2                # x2 = x1 - 2       x2 = x1 + 32-bit sign-extended offset 0xfffffffe. (-2 = 0xffe as 12-bit sign-extended)
addi gp,zero,504             # x3 = x0 + 504     imm offset uses  decimal imm offset format (0d504 prefix optional = 0x1f8 hex format)
addi tp,sp,0x1f8             # x4 = x2 + 0x1f8   using                hex imm offset (0d504 decimal format) 
addi t0,zero,2047            # x5 = x0 + 2047    maximum positive decimal imm offset (=0x7ff)
addi t1,zero,0x7ff           # x6 = x0 + 0x7ff   maximum positive hex     imm offset (hex format)
addi s0,zero,-2048           # x7 = x0 - 2048    maximum negative decimal imm offset (=0x800)
addi s1,zero,-0x7ff          # x8 = x0 - 0x7ff   (maximum-1) negative hex imm offset (= -0d2047)
addi s2,zero,-0x800          # x9 = x0 - 0x800   maximum negative hex     imm offset (= -0d2048)
addi a0,zero,-0b100000000000 # x10 = x0 - 0x800  maximum negative binary  imm offset 
addi zero,zero,0             # x0 = x0 + 0       x0 is always 0. x0 is never written, i.e, NOP (no operation) instruction
addi zero,zero,1             # x0 = x0 + 1       No change in x0 since x0 is always = 0.
1b: jal zero,1b   		     # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	

============================
Post-assembly program listing
PC instruction    basic assembly     original assembly             Notes
      (31:0)        code                 code 
00 0x00300093	addi x1 x0 3		addi x1, x0, 3 					# x1 = x0 (always 0) + 32-bit sign-extended immediate offset (3) 
04 0xffe08113	addi x2 x1 -2		addi x2, x1, -2 				# x2 = x1 + 32-bit sign-extended offset 0xfffffffe. (-2 = 0xffe as 12-bit sign-extended)
08 0x1f800193	addi x3 x0 504		addi x3, x0, 504 				# imm offset uses  decimal imm offset format (0d504 prefix optional = 0x1f8 hex format)
0c 0x1f810213	addi x4 x2 504		addi x4, x2, 0x1f8 				# using                hex imm offset (0d504 decimal format) 
10 0x7ff00293	addi x5 x0 2047		addi x5, x0, 2047 				# maximum positive decimal imm offset (=0x7ff)
14 0x7ff00313	addi x6 x0 2047		addi x6, x0, 0x7ff 				# maximum positive hex     imm offset (hex format)
18 0x80000393	addi x7 x0 -2048	addi x7, x0, -2048 				# maximum negative decimal imm offset (=0x800)
1c 0x80100413	addi x8 x0 -2047	addi x8, x0, -0x7ff 			# (maximum-1) negative hex imm offset (= -0d2047)
20 0x80000493	addi x9 x0 -2048	addi x9, x0, -0x800 			# maximum negative hex     imm offset (= -0d2048)
24 0x80000513	addi x10 x0 -2048	addi x10, x0, -0b100000000000   # maximum negative binary  imm offset 
28 0x00000013	addi x0 x0 0		addi x0, x0, 0 					# x0 is always 0. x0 is never written, i.e, NOP (no operation) instruction
2c 0x00100013	addi x0 x0 1		addi x0, x0, 1 					# No change in x0 since x0 is always = 0.
30 0x0000006f	jal x0 0            1b: jal zero,1b 				# repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b

============================
Venus 'dump' program binary. No of instructions n = 12
00300093
ffe08113
1f800193
1f810213
7ff00293
7ff00313
80000393
80100413
80000493
80000513
00000013
00100013
0000006f

============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
format: m = mod(n/8)+1 = mod(11/8)+1 = 2, i.e, two lines below 
        instr(0) instr(1) instr(2)  instr(3)  instr(4) instr(5) instr(6) instr(7)
		instr(8) instr(9) instr(10) instr(11) 00000000 00000000 00000000 00000000   

00300093ffe081131f8001931f8102137ff002937ff003138000039380100413
800004938000051300000013001000130000006f000000000000000000000000
