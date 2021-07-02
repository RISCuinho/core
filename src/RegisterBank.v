module RegisterBank #(
   parameter BANK_WIDTH = 5,
   parameter REGISTER_WIDTH = 32
)(
   input                           clk, rst,
   input      [BANK_WIDTH-1:0]     rs1_sel, rs2_sel, rd_sel,
   input                           reg_w,
   output     [REGISTER_WIDTH-1:0] rs1_data, rs2_data,
   input      [REGISTER_WIDTH-1:0] rd_data,
   output reg                      ready
`ifdef RISCUIN_DUMP
   ,input dump
`endif
);

localparam SIZE = 2**BANK_WIDTH;

reg [REGISTER_WIDTH-1:0] memory [0:SIZE-1];

reg [BANK_WIDTH:0] idx;

initial 
begin
   $display("Register Bank with %d registers", SIZE);
   idx = {BANK_WIDTH{1'b0}};
   ready <= 1'b0;
end

always @(posedge clk) begin
   if(rst && ready) begin
      idx  <= 0;
      ready <= 1'b0;
   end 
   else if (!ready) begin
      memory[idx]  <= {REGISTER_WIDTH{1'b0}};
      idx          <= idx + 1;
      ready        <= (idx == SIZE);
   end
end

assign rs1_data = !ready ? {BANK_WIDTH{1'bx}}    :
                  rs1_sel == {BANK_WIDTH{1'b0}} ? {REGISTER_WIDTH{1'b0}} : 
                  memory[rs1_sel];
assign rs2_data = !ready ? {BANK_WIDTH{1'bx}}    :
                  rs2_sel == {BANK_WIDTH{1'b0}} ? {REGISTER_WIDTH{1'b0}} : 
                  memory[rs2_sel];

always @(posedge clk) begin
   if(!rst && ready && reg_w) begin
      memory[rd_sel] <= rd_data;
   end   
end

`ifdef RISCUIN_DUMP
   integer i;
   integer fileDesc;
   always @(posedge clk) begin
      if(dump) begin
         $display("RegisterBank: Arquivo Dump: %s, %10t", `RISCUIN_DUMP_FILE_RB, $realtime);
         fileDesc = $fopen({"./dumps/",`RISCUIN_DUMP_FILE_RB},"a");
         $fwrite(fileDesc,"Dump Register Bank inicializado em:  %10t\n",$realtime);
         /*
   input                           clk, rst,
   input      [BANK_WIDTH-1:0]     rs1_sel, rs2_sel, rd_sel,
   input                           reg_w,
   output     [REGISTER_WIDTH-1:0] rs1_data, rs2_data,
   input      [REGISTER_WIDTH-1:0] rd_data,
   output reg                      ready
*/
         $fwrite(fileDesc,"rst: %0b, Reg Write: %0b, ready: %0b \n",rst, reg_w, ready);
         $fwrite(fileDesc,"Reg Sel 1: %2h, Data: %8h\n",rs1_sel,rs1_data);
         $fwrite(fileDesc,"Reg Sel 2: %2h, Data: %8h\n",rs2_sel,rs2_data);
         $fwrite(fileDesc,"Reg Sel dest: %2h, Data: %8h\n",rd_sel,rd_data);
         $fwrite(fileDesc,"========================================================= \n");
         $fwrite(fileDesc,"           0x00       0x01     0x02     0x03     0x04     0x05     0x06     0x07  \n");
         for (i=0; i<SIZE; i=i+8) begin:dump_memory
            $fwrite(fileDesc,"0x%8h - %8h %8h %8h %8h %8h %8h %8h %8h \n", i,
              memory[i+0], memory[i+1], memory[i+2], memory[i+3],
              memory[i+4], memory[i+5], memory[i+6], memory[i+7]);
         end
         $fwrite(fileDesc,"Dump finalizado em:  %10t\n",$realtime);
         $fwrite(fileDesc,"#########################################################\n");
         $fclose(fileDesc);
      end
    end
`endif

   
endmodule
