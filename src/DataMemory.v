module DataMemory #(
   parameter ADDR_WIDTH = 16,
   parameter DATA_WIDTH = 32
)(
   input      clk, wd, rd,
   input      [1:0] size,
   input      [ADDR_WIDTH-1:0] addr,
   input      [DATA_WIDTH-1:0] data_in, 
   output     [DATA_WIDTH-1:0] data_out
);
   localparam RAM_SIZE = 2**ADDR_WIDTH;

   initial begin
      $display("Memory Bank, memory word %0d bits, address width %0d bits, total words %0d", 
                                                                              DATA_WIDTH, ADDR_WIDTH, SIZE);
   end

   reg [DATA_WIDTH-1:0] memory [0:RAM_SIZE];

   always @(posedge clk) begin
      if(wd)
         memory[addr_in]   <= data_in;
      if(rd)
         data_out       <= memory[addr_out];
   end

endmodule
