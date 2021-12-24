module DataMemory #(
   parameter ADDR_WIDTH = 16,
   parameter DATA_WIDTH = 8
)(
   input      clk, wd, rd,
   input      [ADDR_WIDTH-1:0] addr_in, addr_out,
   input      [DATA_WIDTH-1:0] data_in, 
   output reg [DATA_WIDTH-1:0] data_out
);
localparam SIZE = 2**ADDR_WIDTH;

initial begin
   `ifndef __YOSYS__
   $display("Memory Bank, memory word %0d bits, address width %0d bits, total words %0d", 
   `else
   $display("Memory Bank, memory word %d bits, address width %d bits, total words %d", 
   `endif
             DATA_WIDTH, ADDR_WIDTH, SIZE);
end
reg [DATA_WIDTH-1:0] memory [0:SIZE];
always @(posedge clk) begin
   if(wd)
      memory[addr_in]   <= data_in;
   if(rd)
      data_out       <= memory[addr_out];
end
endmodule
