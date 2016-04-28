// ---------------------------------  Seven Segment Decoder -----------------------------//



`define SS_0  7'b1111110
`define SS_1  7'b0110000
`define SS_2  7'b1101101
`define SS_3  7'b1111001
`define SS_4  7'b0110011
`define SS_5  7'b1011011
`define SS_6  7'b1011111
`define SS_7  7'b1110000
`define SS_8  7'b1111111
`define SS_9  7'b1111011


module seven_seg_decoder(bin,out);
		input [3:0] bin;
		output [6:0] out;
		reg [6:0] segs;
		
		always@(*) begin
				case(bin)
						0: segs = `SS_0; 
						1: segs = `SS_1;
						2: segs = `SS_2;
						3: segs = `SS_3;
						4: segs = `SS_4;
						5: segs = `SS_5;
						6: segs = `SS_6;
						7: segs = `SS_7;
						8: segs = `SS_8;
						9: segs = `SS_9;
				default: segs = 7'b0;
				endcase
		end

		assign out = segs;// common cathode by default
		//assign out = segs ^ 7'b1111_111;
endmodule
// ---------------- Seven Segment Reverse for checking ---------
module seven_seg_reverse(segs,out);
		output [3:0] out;
		input [6:0] segs;
		reg [3:0] out;
		
		always@(*) begin
				case(segs)
				`SS_0	: out =4'd0 ;
				`SS_1	: out =4'd1 ;
				`SS_2	: out =4'd2 ;
				`SS_3	: out =4'd3 ;
				`SS_4	: out =4'd4 ;
				`SS_5	: out =4'd5 ;
				`SS_6	: out =4'd6 ;
				`SS_7	: out =4'd7 ;
				`SS_8	: out =4'd8 ;
				`SS_9	: out =4'd9 ;
				default: out = 4'd0;
				endcase
		end
endmodule
