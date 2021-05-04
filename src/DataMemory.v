`timescale 1ns / 100ps

module DataMemory #(
   parameter ADDR_WIDTH = 8,
   parameter DATA_WIDTH = 32
)(
   input      clk, we,rst,
   input      [1:0] size,
   input      [ADDR_WIDTH-1:0] addr,
   input      [DATA_WIDTH-1:0] data_in, 
   output reg [DATA_WIDTH-1:0] data_out
);
   localparam RAM_SIZE = 2**ADDR_WIDTH;

   initial begin
      $display("Memory Bank, memory word %0d bits, address width %0d bits, total words %0d", 
                                                                              DATA_WIDTH, ADDR_WIDTH, RAM_SIZE);
   end

   reg [DATA_WIDTH-1:0] mem [DATA_WIDTH-1:0] /* synthesis syn_ramstyle = "no_rw_check,block_ram" */; // diretiva especifica do GoWin para sinteizar BSRAN

   always @ (posedge clk)
      if (rst == 1)
         data_out <= 0;
      else
         data_out <= mem[addr];
    
  
   always @(posedge clk)
      if (we)
         mem[addr] = data_in;

endmodule
