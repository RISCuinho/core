Example auipc instructions

U-type format auipc x11, 0x7ffff 
                   imm[31:12]		 rd(4:0) opcode(6:0)
hex (0x): [  f    f    f    f    f     5     9    7 
bin (ob): [0111 1111 1111 1111 1111] [0101 1][001 0111]

============================

# Copy/paste the assembly program to Venus online assembler / simulator https://www.kvakil.me/venus/
# assembly program            # Notes  (default imm format is decimal 0d)
main:
addi x12, x0,  -1    # x12 = 0xffffffff
auipc x11, 0x7ffff   # x11 = 0x7ffff004 (since current PC = 4)
nop
nop
nop
nop
sw    x12, 0x8(x11)  # store x12 in MEM(x11 + 8) = MEM(0x7ffff00c)

============================
Post-assembly program listing
PC instruction  basic assembly     original assembly      Notes
      (31:0)        code             code 
00 0xfff00613	addi x12 x0 -1		addi x12, x0, -1 	# x12 = 0xffffffff
04 0x7ffff597	auipc x11 524287	auipc x11, 0x7ffff 	# x11 = 0x7ffff004 (since current PC = 4)
08 0x00c5a423	sw x12 8(x11)		sw x12, 0x8(x11) 	# store x12 in MEM(x11 + 8) = MEM(0x7ffff00c)

==============================
Venus 'dump' program binary
fff00613
7ffff597
00c5a423

============================
Program binary formatted for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
format: m = mod(n/8)
        instr(0) instr(1) instr(2)  instr(3)  instr(4) instr(5) instr(6) instr(7)
fff006137ffff59700c5a4230000000000000000000000000000000000000000



00300093004081130000001300000013005081930060011300000063003100b3