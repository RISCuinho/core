# RISC-V Register-Register instructions (add, sub example)
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: Apr 2020

To describe operation P = (A + B) + (C - D)
Declare variable data values
Assume variable/register/data values 
A/x12=3, B/x13=4, C/x14=0xa, D/x15=8, using e.g, addi instruction
Use add, sub instructions
  x10=x12+x13
  x11=x14-x15
  x10=x10+x11 (overwrites previous x10 value)

#
Example: repeating add add immediate instruction
 add rd, rs1, rs2     # rd = rs1 + rs2  
 sub rd, rs1, rs2     # rd = rs1 - rs2  
 addi rd, rs1, imm    # rd = rs1 + imm (where imm is signed data)  

#==============================
R-type format for instruction add x5, x4, x3
# RISC-V instruction formats/examples (instruction generator https://tinyurl.com/whsk5k4)

R-type       f7       rs2=3  rs1=4   f3    rd=5    opcode
            (6:0)     (4:0)  (4:0)  (2:0) (4:0)    (6:0) 
hex (0x):    0    0      3    2     0      2     b     3
bin (ob): [0000 000][0 0011][0010 0][000][0010 1][011 0011]

# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: https://www.vicilogic.com/vicilearn/run_step/?s_id=1452

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

#============================

# Copy/paste this assembly program to Venus online assembler / simulator https://www.kvakil.me/venus/
# assembly program            # Notes  (default imm format is decimal 0d)
main:
addi x12, x0, 3               # x12 = 0 + 3 = 3       
addi x13, x0, 4               # x13 = 0 + 4 = 4       
addi x14, x0, 0xa             # x14 = 0 + 0d10 = 0xa
addi x15, x0, 8               # x15 = 0 + 8 = 3       
add  x10, x12, x13            # x10 = x12 + x13 = 3 + 4 = 7
sub  x11, x14, x15            # x11 = x14 - x15 = 0xa - 8 = 0d10 - 8 = 2
add  x10, x10, x11            # x10 = x10 + x11 = 7 + 2 = 9
1b:  jal x0,1b                # repeating NOP instruction (no operation)

============================
Post-assembly program listing
PC instruction  basic assembly   original assembly    Notes
      (31:0)        code              code 
00 0x00300613	addi x12 x0 3 	 addi x12, x0, 3    # x12 = 0 + 3 = 3
04 0x00400693	addi x13 x0 4 	 addi x13, x0, 4    # x13 = 0 + 4 = 3
08 0x00a00713	addi x14 x0 10	 addi x14, x0, 0xa  # x14 = 0 + 0d10 = 0xa
0c 0x00800793	addi x15 x0 8	 addi x15, x0, 8    # x15 = 0 + 8 = 3
10 0x00d60533	add x10 x12 x13	 add x10, x12, x13  # x10 = x12 + x13
14 0x40f705b3	sub x11 x14 x15	 sub x11, x14, x15  # x11 = x14 - x15
18 0x00b50533	add x10 x10 x11	 add x10, x10, x11  # x10 = x10 + x11
1c 0x0000006f	jal x0 0	     1b: jal x0,1b      # repeaing NOP instruction (no operation)

==============================
Venus 'dump' program binary. No of instructions n = 11
00300613
00400693
00a00713
00800793
00d60533
40f705b3
00b50533
0000006f

============================
Program binary formatted for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, format: m = mod(n/8)
003006130040069300a007130080079300d6053340f705b300b505330000006f