# Example RISC-V program-based delay, using branch instructions, and x10(0) bit toggle
# Fearghal Morgan, National University of Ireladn, Galway
# Mar 2020

# ============================
# RISC-V instruction formats/examples (instruction generator https://tinyurl.com/whsk5k4)

# ============================
# Creating ~1 second delay
# Assume clk frequency is 12.5MHz
# Using 2-cycle program counter loop for a 1-second delay, 
# Use 12.5M/2 (6,250,000) x 2 instructions, i.e, 'decrement' and 'branch if not zero'
# Load counter register x10 with 0d6,250,000-1 = 0x5f5e10-1 = 0x5f5e0f
# Note: One additional intruction is required for loading counter register (ignore this though)
#
# Instructions for exact 1 second delay
# Write x10=0x005f5e0f
#
#  lui x10, 0x5f5  # x10 = 0x005f5000. load upper 20 bits using lui instruction 
#
#  # 0xe10 = 0d3600. Cannot use addi x11,x11,3600 (0x0xe10) since addi supports max value +2047 (0x7ff)
#  # So, load shift this value left 1-bit, load lower bits in x11 using addi, then slli 1-bit left,
#  addi x11,x11, 0x707 # load lower bits in x11 (shifted right 1-bit 0xe0f -> 0x707) 
#  slli x11, x11, 1    # 0x707 << 1 = 0xe0e, i.e, 0b0111 0000 0111 << 1 = 0b1110 0000 1110
#
#  add  x10, x11, x10   # add registers x11 and x10, i.e, x10=0x005f5e0e
#  addi x10, x10, 1     # add 1, x10=0x005f5e0f
#
# Alternative instructions to load count for approximately 1 second delay
# May be acceptable to use a delay interval close to, but not exactly, 1 second, 
# though a value that can be loaded into the delay counter register in a single instruction,
# e.g, load 0d6,295,552, i.e, 0x00601000 
# The lower 12 bits are 0, so a single LUI instruction (lui x11, 0x00601) can be used.
# This completes the 2-cycle program counter loop (assuming 12.5MHz clk frequency) in 
# 2 x 0d6,295,552 = 12,591,104 clk cycles (close to 1 second)
lui x11,0x00601     # x12=0x00601000
# ============================

# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# Venus https://www.kvakil.me/venus/

# ============================
# assembly program           # Notes  (default imm format is decimal 0d)
                             # x10 = 0 initially, so x10(0) deasserted
delayLoop:                   # register-based decrementing delay loop 
 xori x10,x10,1              # toggle x10 bit 0, using asserted in bit 0 mask
 # xori x11,x10,-1           # invert x10 using xor x10 with 0xffffffff
 #addi x12,x0,3              # initial count value = 3, i.e, counting loop is 2-0
 lui x12,0x00601             # initial count value = 0x00601000 
 decrAndBNELoop:
  addi x12,x12,-1            # decrement count   
  bne x12,x0,decrAndBNELoop  # stay in loop if x12 count > 0
  beq x0,x0,delayLoop        # restart delayLoop (unconditional branch)

============================
Post-assembly program listing

PC instruction    basic assembly     original assembly             Notes
      (31:0)        code                 code 
00 0x00154513	xori x10 x10 1	     xori x10,x10,1            # toggle x10 bit 0, using asserted in bit 0 mask
04 0x00601637	lui x12 1537	     lui x12,0x00601           # initial count value = 0x00601000
08 0xfff60613	addi x12 x12 -1	     addi x12,x12,-1           # decrement count
0C 0xfe061ee3	bne x12 x0 -4	     bne x12,x0,decrAndBNELoop # stay in loop if x12 count > 0
10 0xfe0008e3	beq x0 x0 -16	     beq x0,x0,delayLoop       # restart delayLoop (unconditional branch)


============================
Venus 'dump' program binary. No of instructions n = 4
00154513
00601637
fff60613
fe061ee3
fe0008e3

============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
format: m = mod(n/8)+1 = mod(4/8)+1 = 1, i.e, one line below
        instr(0) instr(1) instr(2)  instr(3) instr(4) 00000000 00000000 00000000
	
0015451300601637fff60613fe061ee3fe0008e3000000000000000000000000