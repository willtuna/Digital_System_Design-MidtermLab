`include "keypad.v" //  this included for the define words  op
module calculation(rst,A1,A0,OP,B1,B0,out);
		input [7:0]A1,A0,B1,B0,OP;
		input rst;
		
		output reg [13:0]out;

		reg [13:0] A,B;

		
		always@(*)begin
				A = rst ? 14'bz: A1 *10 +A0;
				B = rst ? 14'bz :  { {6{1'b0}} ,B1 }* 10 + {  {6{1'b0}},B0}; // Both this two works ...
		end

		always@(*)begin
				casez(OP)
				`A_add:
						out = A + B;
				`B_sub:
						out = A - B;
				`f_mult:
						out = A * B;
				//`D_ivid:
				default:
						out = 14'bz;
				endcase
		end

endmodule
