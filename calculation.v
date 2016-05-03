`ifndef _calculation_v
`define _calculation_v

`include "keypad.v" //  this included for the define words  op
module calculation(rst,A1,A0,OP,B1,B0,out);
		input [7:0]A1,A0,B1,B0,OP;
		input rst;
		
		output reg [13:0]out;

		reg [13:0] A,B;

		
		always@(*)begin
				A = rst ? 14'b0 : (A1 *10 +A0);
				B = rst ? 14'b0 : (B1 *10+B0); // Both this two works ...
		end

		always@(*)begin
				casez(OP)
				`encout_ADD:
						out = A + B;
				`encout_SUB:
						out = A - B;
				`encout_Mult:
						out = A * B;
				`encout_Div:
						out = A / B;
				default:
						out = 14'bz;
				endcase
		end

endmodule
`endif
