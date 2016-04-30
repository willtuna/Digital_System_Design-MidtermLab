`ifndef _UniversalBCD_v
`define _UniversalBCD_v
module UniversalBCD(in,out);
		 // up to 9999
		 // Default is 4 digit
		input [13:0]in;
		output reg [15:0] out;
		


		integer i ;
		always@(*)begin
		out = 16'b0;
		

				for(i = 13 ; i>=0;  i = i-1) begin
				
				if(out[15:12] >=5 )
						out[15 :12] = out[15:12] + 3;
				if(out[11:8] >= 5)
						out[11:8] = out[11:8] +3;
				if(out[7:4] >= 5)
						out[7:4]  = out[7:4] +3;
				if(out[3:0] >= 5)
						out[3:0] = out[3:0] +3 ;

				// Shift left one 
				out[15:12] = out[15:12] <<1;
				out[12] = out[11];
				out[11:8] = out[11:8] <<1;
				out[8] = out[7];
				out[7:4] = out[7:4] <<1;
				out[4] = out[3];
				out[3:0] = out[3:0] <<1;
				out[0] = in[i];
				end
		end

endmodule
`endif
