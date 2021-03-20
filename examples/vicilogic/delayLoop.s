Example RISC-V program, using branch instructions
Fearghal Morgan, National University of Ireland, Galway
Mar 2020

Branch assembly instruction: 
  bne rs2, rs1, imm   i.e, relative branch (from current PC) if rs2 is not equal to rs1

Uses B-type format, e.g, branch instruction at PC = 08
  bne x1, x0, decrAndBNELoop
  instruction(31:0) = 0xfe009ee3

B-type  imm(12¦10:5)	 rs2	 rs1   funct3  imm(4:1¦11)	 opcode	
hex (0x):    f      e     0       0     9        e         e      3
bin (ob): (1 111  111)(0 0000) (0000 1)(001)   (1110    1) (110 0011)

imm(12:1) = 1 1 111 111 1110
imm(0) = 0
imm(12:0) = 1 1 111 111 1110 0 = 1 1111 1111 1100 = 0x1ffc
extImm    = 0xfffffffc 
============================

# RISC-V instruction formats/examples (instruction generator https://www.vicilogic.com/vicilearn/run_step/?s_id=960)

# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: reference [8], vicilogic RISC-V Architecture and Applications 

# assembly program           # Notes  (default imm format is decimal 0d)

delayLoop:                   # register-based decrementing delay loop 
 addi x1, x0, 3              # initial count value, counting 2-0
 decrAndBNELoop:
  addi x1, x1, -1            # decrement count   
  bne x1, x0, decrAndBNELoop # stay in loop if count > 0
  beq x0, x0, delayLoop      # restart delayLoop


============================
Post-assembly program listing
PC instruction    basic assembly     original assembly             Notes
      (31:0)        code                 code 
00 0x00300093   addi x1 x0 3	 addi x1, x0, 3              # initial count value, counting 2-0
04 0xfff08093   addi x1 x1 -1	 addi x1, x1, -1             # decrement count
08 0xfe009ee3   bne x1 x0 -4	 bne x1, x0, decrAndBNELoop  # stay in loop if count > 0
0C 0xfe000ae3   beq x0 x0 -12	 beq x0, x0, delayLoop       # restart delayLoop (unconditional branch)



============================
Venus 'dump' program binary. No of instructions n = 4
00300093
fff08093
fe009ee3
fe000ae3

============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
format: m = mod(n/8)+1 = mod(4/8)+1 = 1, i.e, one line below
        instr(0) instr(1) instr(2)  instr(3)  instr(4) instr(5) 00000000 00000000
	
00300093fff08093fe009ee3fe000ae300000000000000000000000000000000
