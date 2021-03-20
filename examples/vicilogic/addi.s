Example addi add immediate instructions
 addi rd, rs1, imm,    rd = rs1 + imm

# addi x3, x3, 5   instruction I-type format
I-type       imm(11:0)         rs1    f3    rd     opcode
hex (0x): [  0    0    5 ]    1     8       1     9    3
bin (ob): [0000 0000 0101] [0001 1][000] [0001 1][001 0011]

============================

# Copy/modify/paste this assembly program to Venus online assembler / simulator (Editor Window TAB) 
# https://www.kvakil.me/venus/
# Video tutorial: https://www.vicilogic.com/vicilearn/run_step/?s_id=1452

# assembly program            # Notes  (default imm format is decimal 0d)
main:
addi x3, x3, 5                # x3 = x3 + 5        
addi x3, x3, 5                # x3 = x3 + 5        
addi x3, x3, 5                # x3 = x3 + 5        

============================
Post-assembly program listing
PC instruction  basic assembly  original assembly    Notes
      (31:0)        code             code 
00 0x00518193	addi x3 x3 5	addi x3, x3, 5      # x3 = x3 + 5
04 0x00518193	addi x3 x3 5	addi x3, x3, 5      # x3 = x3 + 5
08 0x00518193	addi x3 x3 5	addi x3, x3, 5      # x3 = x3 + 5

==============================
Venus 'dump' program binary. No of instructions n = 11
00518193
00518193
00518193

============================
Program binary formatted for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
format: m = mod(n/8)
        instr(0) instr(1) instr(2)  instr(3)  instr(4) instr(5) instr(6) instr(7)
0051819300518193005181930000000000000000000000000000000000000000
