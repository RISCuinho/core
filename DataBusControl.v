`include "MemoryMap.vh"

module DataBusControl #(
   parameter RAM_ADDR_WIDTH = 16
)(
   input      clk, wd, rd, 
   output     ready, // ready == 0 is busy
   input      [1:0]            to_size, from_size,
	
   input                       unsigned_value,
	
   input      [31:0]           addr_in, addr_out,
	
   input      [31:0]				 data_in, 
   output     [31:0] 			 data_out
);

//localparam SIZE = 2**ADDR_WIDTH;

reg [127:0] dbc_register;

assign ready = 1'b1;

reg [31:0] memory [0:`DBC_RAM_SIZE];

reg [31:0] local_data_out;

wire ram_addrs = (addr_out >= `DBC_RAM_START && addr_out <= `DBC_RAM_END) || 
                 (addr_in  >= `DBC_RAM_START && addr_in  <= `DBC_RAM_END);
wire dbc_register_addrs = addr_out >= `DBC_REGISTER_START || addr_out <= `DBC_REGISTER_END;

assign data_out = dbc_register_addrs                                   ?
						addr_out == `DBC_REGISTER_MISALIGNED_EXCEPTION_ADDR              ||
						addr_out == `DBC_REGISTER_EMPTY_ADDR_EXCPETION_ADDR              ||
						addr_out == `DBC_REGISTER_LAST_DATA_SIZE_ADDR                    ?
						dbc_register[31:0]                                               :
						dbc_register[31:0]                                               :
						local_data_out;
						

always @(posedge clk ) begin
   dbc_register[`DBC_REGISTER_EMPTY_ADDR_EXCEPTION_BIT] =
                                 !ram_addrs &&
                                 !dbc_register_addrs ; 
   dbc_register[`DBC_REGISTER_MISALIGNED_EXCEPTION_BIT] = 
                                 addr_in[0]  != 1'b0 || addr_in[1]  != 1'b0 ||
                                 addr_out[0] != 1'b0 || addr_out[1] != 1'b0 ;
end

always @(posedge clk) begin
   if(ram_addrs) begin
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
         local_data_out <= unsigned_value ? {{24'b0}                  , memory[addr_out][7:0]} : 
                                      {{24{memory[addr_out][7]}}, memory[addr_out][7:0]};
      end
      2'b01: begin
         local_data_out <= unsigned_value ? {{16'b0}                   , memory[addr_out][15:0]}: 
                                      {{16{memory[addr_out][15]}}, memory[addr_out][15:0]};
      end
//      2'b10: 
      default: begin 
         local_data_out <= memory[addr_out];
      end
   endcase
	end
end

endmodule
