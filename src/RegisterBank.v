module RegisterBank #(
   parameter BANK_WIDTH = 5,
   parameter REGISTER_WIDTH = 32
)(
   input                           clk, rst,
   input      [BANK_WIDTH-1:0]     rs1_sel, rs2_sel, rd_sel,
   input                           reg_w,
   output     [REGISTER_WIDTH-1:0] rs1_data, rs2_data,
   input      [REGISTER_WIDTH-1:0] rd_data /*,
   output reg                      ready */
);

localparam SIZE = 2**BANK_WIDTH;

reg [REGISTER_WIDTH-1:0] registerFile [0:SIZE-1]; //* synthesis syn_ramstyle = "block_ram" */;


always @(posedge clk) begin

   if(!rst && reg_w) begin 
      registerFile[rd_sel] <= rd_data;
   end    
end

assign rs1_data = rs1_sel == {BANK_WIDTH{1'b0}} ? {REGISTER_WIDTH{1'b0}} : 
                  registerFile[rs1_sel];
assign rs2_data = rs2_sel == {BANK_WIDTH{1'b0}} ? {REGISTER_WIDTH{1'b0}} : 
                  registerFile[rs2_sel];

endmodule
