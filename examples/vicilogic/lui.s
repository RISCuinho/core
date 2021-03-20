Example lui instructions

U-type format lui x11, 0x00601 
                   imm[31:12]		 rd(4:0) opcode(6:0)
hex (0x): [  0    0    6    0    1     5     b    7 
bin (ob): [0000 0000 0110 0000 0001] [0101 1][011 0111]

============================
# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: reference [8], vicilogic RISC-V Architecture and Applications 

# assembly program            # Notes  (default imm format is decimal 0d)
main:
# assign x11 = 0x00601000
lui x11,  0x00601         # x11=0x00601000

# assign x11 = 0xf5f3e7ff  
lui  x11, 0xf5fee         # 1111 0101 1111 0011 1110 0000 0000 0000   # 0xf5f3e 
addi x11, x11, 0x7ff      # 1111 0101 1111 0011 1110 0111 1111 1111   # 0xf5f3e7ff
# Maximum positive addi argument is 0x7ff, ie., cannot use addi to add positive value greater than 0x7ff 

# assign x11 = 0xf5f3efff # bits (31:30) = 11
lui  x11, 0xebe7d         # 1110 1011 1110 0111 1101 0000 0000 0000   # 0xebe7d000, i.e, 0x75f3e000 shifted one bit to the left
srai x11, x11, 1          # 1111 0101 1111 0011 1110 1000 0000 0000   # 0xf5f3e800, shift 1-bit right, arithmetic
addi x11, x11, 0x7ff      # 1111 0101 1111 0011 1110 1111 1111 1111   # 0xf5f3efff

# assign x11 = 0xb5f3efff 
lui  x11, 0xb5f3e         # 1011 0101 1111 0011 1110 0000 0000 0000   # 0xb5f3e00
addi x11, x11, 0x7ff      # 1111 0101 1111 0011 1110 0111 1111 1111   # 0xb5f3e7ff
addi x10, x0,  1          # 0000 0000 0000 0000 0000 0000 0000 0001   # 0x       1
slli x10, x10, 11         # 0000 0000 0000 0000 0000 1000 0000 0000   # 0x     800
or   x11, x11, x10        # 1111 0101 1111 0011 1110 1111 1111 1111   # 0xb5f3efff


============================
Post-assembly program listing
PC instruction  basic assembly     original assembly      Notes
      (31:0)        code             code 
00 0x006015b7	lui x11 1537		lui x11, 0x00601 		# x11=0x00601000
04 0xf5f3e5b7	lui x11 1007422		lui x11, 0xf5f3e 		# 1111 0101 1111 0011 1110 0000 0000 0000 # 0xf5f3e
08 0x7ff58593	addi x11 x11 2047	addi x11, x11, 0x7ff 	# 1111 0101 1111 0011 1110 0111 1111 1111 # 0xf5f3e7ff
0c 0xebe7d5b7	lui x11 966269		lui x11, 0xebe7d 		# 1110 1011 1110 0111 1101 0000 0000 0000 # 0xebe7d000, i.e, 0x75f3e000 shifted one bit to the left
10 0x4015d593	srai x11 x11 1		srai x11, x11, 1 		# 1111 0101 1111 0011 1110 1000 0000 0000 # 0xf5f3e800, shift 1-bit right, arithmetic
14 0x7ff58593	addi x11 x11 2047	addi x11, x11, 0x7ff 	# 1111 0101 1111 0011 1110 1111 1111 1111 # 0xf5f3efff
18 0xb5f3e5b7	lui x11 745278		lui x11, 0xb5f3e 		# 1011 0101 1111 0011 1110 0000 0000 0000 # 0xb5f3e00
1c 0x7ff58593	addi x11 x11 2047	addi x11, x11, 0x7ff 	# 1111 0101 1111 0011 1110 0111 1111 1111 # 0xb5f3e7ff
20 0x00100513	addi x10 x0 1		addi x10, x0, 1 		# 0000 0000 0000 0000 0000 0000 0000 0001 # 0x 1
24 0x00b51513	slli x10 x10 11		slli x10, x10, 11 		# 0000 0000 0000 0000 0000 1000 0000 0000 # 0x 800
28 0x00a5e5b3	or x11 x11 x10		or x11, x11, x10 		# 1111 0101 1111 0011 1110 1111 1111 1111 # 0xb5f3efff


==============================
Venus 'dump' program binary============================
Program binary formatted for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
format: m = mod(n/8)
        instr(0) instr(1) instr(2)  instr(3)  instr(4) instr(5) instr(6) instr(7)

006015b7
f5f3e5b7
7ff58593
ebe7d5b7
4015d593
7ff58593
b5f3e5b7
7ff58593
00100513
00b51513
00a5e5b3

006015b7f5f3e5b77ff58593ebe7d5b74015d5937ff58593b5f3e5b77ff58593
0010051300b5151300a5e5b30000000000000000000000000000000000000000


006015b7f5f3e5b77ff58593ebe7d5b74015d5937ff585930000000000000000
