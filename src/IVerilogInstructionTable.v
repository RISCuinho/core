module IVerilogInstructionTable(
   input rst,
   input clk,
   input [31:0] instr,
   input [4:0] alu_opcode,
   input [ 1:0] rd_data_sel, 
   input [ 4:0] rs1_sel, rs2_sel, rd_sel,
   input [31:0] rs1_data, rs2_data, rd_data, imm // quando instrução do control usar os 12 primeiros bits para csr
   );

   initial begin
      $display("IVerilog Instruction Table!");

      //$monitor("Instruction: 0x%8h, 0b%32b, 0h%4h, 0b%16b.",instr,instr,alu_opcode,alu_opcode);
      //$monitor("Immediate: 0b%32b",imm);
//      $monitor("rst: %b, clk: %b, fullop(%4h): rs1(x%02d): 0h%04h, rs2(x%02d): 0h%04h, rd(x%02d): 0h%04h,  imm(%0d)", 
  //                       rst, clk, alu_opcode, rs1_sel, rs1_data, rs2_sel, rs2_data, rd_sel, rd_data, imm);
      $monitor("rst: %b, alu_opcode(%4h): rs1(x%02d): 0h%04h, rs2(x%02d): 0h%04h, rd(x%02d): 0h%04h,  imm(%0d)", 
                       rst, alu_opcode, rs1_sel, rs1_data, rs2_sel, rs2_data, rd_sel, rd_data, imm);
   end
endmodule
