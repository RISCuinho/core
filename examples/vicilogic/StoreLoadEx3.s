# RISC-V RV32I program using store and load instructions
#
# Created by Fearghal Morgan, National University of Ireland, Galway
# Creation date: Apr 2020
#
# Adaptad por Carlos Delfino: 23/03/2021
#==============================
# RISC-V instruction formats/examples (instruction generator https://www.vicilogic.com/vicilearn/run_step/?s_id=960)

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
0xfff58593	addi x11 x11 -1	addi x11,x11,-1 # Change data x11 = 0xfe
0x0000006f	jal x0 0	1b: jal zero,1b # repeat the NOP instruction, recommended rather than 1b: beq x0,x0,1b	

============================
Venus 'dump' program binary.  
0f400113
feedc537
0de50513
00a12423
00812583
fff58593
0000006f

============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, format: m = mod(n/8)+1 
0f400113feedc5370de5051300a12423008125830000006f0000000000000000
