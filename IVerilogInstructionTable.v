module IVerilogInstructionTable(
   input  [31:0] instr,
   input [15:0] full_op_code,
   input [ 1:0] rd_data_sel, 
   input [ 4:0] rs1_sel, rs2_sel, rd_sel,
   input [31:0] rs1_data, rs2_data, rd_data, imm // quando instrução do control usar os 12 primeiros bits para csr
   );

   initial begin
      $display("IVerilog Instruction Table!");

      //$monitor("Instruction: 0x%8h, 0b%32b, 0h%4h, 0b%16b.",instr,instr,full_op_code,full_op_code);
      //$monitor("Immediate: 0b%32b",imm);
      $monitor("fullop(%4h): rs1(x%02d): 0h%04h, rs2(x%02d): 0h%04h, rd(x%02d): 0h%04h,  imm(%0d)", 
                                full_op_code, rs1_sel, rs1_data, rs2_sel, rs2_data, rd_sel, rd_data, imm);
   end
endmodule
