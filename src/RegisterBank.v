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

wire [BANK_WIDTH:0] mux_idx_rd_sel = (rst && ready) || !ready ? idx : rd_sel;

always @(posedge clk) begin

   if(!rst && ready && reg_w) begin
      memory[mux_idx_rd_sel] <= rd_data;
   end   
   else
   if(rst && ready) begin
      idx  <= 0;
      ready <= 1'b0;
   end 
   else if (!ready) begin
      memory[mux_idx_rd_sel]  <= {REGISTER_WIDTH{1'b0}};
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

endmodule
