module DataBusControl #(
   parameter ADDR_WIDTH = 16,
   parameter DATA_WIDTH = 32
)(
   input      clk, wd, rd, 
   output     ready, // ready == 0 is busy
   input      [1:0]            to_size, from_size,
   input                       unsigned_value,
   input      [ADDR_WIDTH-1:0] addr_in, addr_out,
   input      [DATA_WIDTH-1:0] data_in, 
   output reg [DATA_WIDTH-1:0] data_out
);
localparam SIZE = 2**ADDR_WIDTH;

assign ready = 1'b1;
reg [DATA_WIDTH-1:0] memory [0:SIZE];

always @(posedge clk) begin
   if (wd) case (to_size)
      2'b00: begin
         memory[addr_in] <= {memory[addr_in][31:8],data_in[ 7:0]};
      end
      2'b01: begin
         memory[addr_in] <= {memory[addr_in][31:16],data_in[15:0]};
      end
      2'b10: begin
         memory[addr_in] <= data_in;
      end
   endcase

   if(rd) case (from_size)
      2'b00: begin
         data_out <= unsigned_value ? {{24'b0}                  , memory[addr_out][7:0]} : 
                                      {{24{memory[addr_out][7]}}, memory[addr_out][7:0]};
      end
      2'b01: begin
         data_out <= unsigned_value ? {{16'b0}                   , memory[addr_out][15:0]}: 
                                      {{16{memory[addr_out][15]}}, memory[addr_out][15:0]};
      end
//      2'b10: 
      default: begin 
         data_out <= memory[addr_out];
      end
   endcase
end

endmodule
