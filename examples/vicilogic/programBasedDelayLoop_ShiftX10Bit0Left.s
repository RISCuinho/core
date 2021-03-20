# RISC-V program, looping every ~1 sec and shifting x10 bit left 
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: Mar 2020

#==============================
# RISC-V instruction formats/examples (instruction generator https://www.vicilogic.com/vicilearn/run_step/?s_id=960)

# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: reference [8], vicilogic RISC-V Architecture and Applications 

# Convert Venus program dump (column of 32-bit instrs) to vicilogic instruction memory format (rows of 8x32-bit instrs)
# https://www.vicilogic.com/static/ext/RISCV/programExamples/convert_VenusProgramDump_to_vicilogicInstructionMemoryFormat.pdf

# [1] code for ~1 second delay 
# https://www.vicilogic.com/static/ext/RISCV/programExamples/exercises/programBasedDelayLoop_ToggleX10Bit0_or_invertX10.asm

# Default imm format is decimal 0d


#==============================
main:
addi x10,x0,1     # seeded with bit(0) asserted 
lui x11,0x00601   # loop delay value 0x0060100, max LUI value is 0xfffff 
loop1:            # ~1sec delay
 add x12,x11,x0   # load initial loop count
 delayLoop:       # decrement loop count until 0
  addi x12,x12,-1                 
  bne x12,x0,delayLoop  
  slli x10,x10,1  # shift 1-bit left. Drops off MSB 
beq x0,x0,loop1   # unconditional branch (looping)

============================
Post-assembly program listing
PC instruction    basic assembly     original assembly             Notes
      (31:0)        code                 code 
00 0x00100513	addi x10 x0 1	addi x10,x0,1 			# seeded with bit(0) asserted
04 0x006015b7	lui x11 1537	lui x11,0x00601 		# loop delay value 0x0060100, max LUI value is 0xfffff
08 0x00058633	add x12 x11 x0	add x12,x11,x0 			# load initial loop count
0c 0xfff60613	addi x12 x12 -1	addi x12,x12,-1
10 0xfe061ee3	bne x12 x0 -4	bne x12,x0,delayLoop
14 0x00151513	slli x10 x10 1	slli x10,x10,1 			# shift 1-bit left. Drops off MSB
18 0xfe0008e3	beq x0 x0 -16	beq x0,x0,loop1 		# unconditional branch (looping)


============================
Venus 'dump' program binary 
00100513
006015b7
00058633
fff60613
fe061ee3
00151513
fe0008e3


============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
format: m = mod(n/8)+1 = mod(6/8)+1 = 1, i.e, one line below
        instr(0) instr(1) instr(2)  instr(3)  instr(4) instr(5) instr(6) 00000000
00100513006015b700058633fff60613fe061ee300151513fe0008e300000000