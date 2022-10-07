`include "./BranchControlUnit_OpCodes.vh"

module BranchControlUnit(
 input [2:0] branch_op, 
 input 		 A, B, 
 input 		 branch_sel, 
 output 		 branch_e
);


assign branch_e =		branch_sel && (
							branch_op == `BEQ    ?         A  ==         B :
                     branch_op == `BNE    ?         A  !=         B :
                     branch_op == `BLT    ? $signed(A) <  $signed(B) :
                     branch_op == `BGE    ? $signed(A) >  $signed(B) :
                     branch_op == `BLTU   ?         A  <          B :
                     branch_op == `BGEU   ?         A  >          B :
                                                         1'b0
											  );

endmodule
