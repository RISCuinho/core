module ProgramCountControlUnit #(
   parameter INSTR_ADDR_WIDTH   = 20,
   parameter STEP = 0
)(
   input      clk, rst, E, pc_src, // pc_src, se 0 segue normalmente (pc_plus), se 1 usa pc_branch
   output reg [INSTR_ADDR_WIDTH-1:0] pc, 
   output     [INSTR_ADDR_WIDTH-1:0] pc_next, pc_plus, 
   input      [INSTR_ADDR_WIDTH-1:0] pc_branch,
   output     pc_end
);

initial begin
//   $display("Contador de programa com comprimento de %d bits",INSTR_ADDR_WIDTH);
   pc       = {INSTR_ADDR_WIDTH{1'b0}};  
end

assign pc_plus = pc + (1'b1)<<STEP;
assign pc_next = pc_src ? pc_branch : pc_plus;
assign pc_end  = pc == {INSTR_ADDR_WIDTH{1'b1}};

always @(posedge clk or posedge rst) begin
   if(rst)
		pc      <= {INSTR_ADDR_WIDTH{1'b0}};
	else if(E)
      pc <= pc_next;
end

endmodule
