module Display (clk,rst,digit4,digit3,digit2,digit1,SevensegOut, VCC_select);  // tested
		input clk, rst;
		input [3:0]   digit4,digit3,digit2,digit1;
		output [6:0] SevensegOut;
		output [3:0] VCC_select;
		
		wire  [3:0]seven_select;


		wire freq400;
		wire [3:0]Seven_in;  //  output of display_4bit   , input of seven_seg_decoder

		frequency400  freqfor400 (clk, rst,freq400);


		display_4bit display(freq400, rst , digit1, digit2, digit3, digit4, Seven_in, seven_select);

		seven_seg_decoder seven_dec(Seven_in, SevensegOut);

		assign VCC_select = seven_select;      // common cathode by default
		//assign VCC_select = seven_select ^ 4'b1111; // common anode

endmodule

//    Common Cathode Seven Seg Decoder // OK!!
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
				casez(bin)
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

		//assign out = segs;             // common cathode by default
		assign out = segs ^ 7'b1111_111; // common anode
endmodule


module frequency400(clk,rst ,out); // ok!!
		input clk,rst ;
		output out;
		reg [20:0] next, count;
			
		reg out1;
			

		always@(posedge clk or posedge rst )
		begin
				if(rst)count <= 19'b0;
				else count <= next;
		end

		always@(posedge clk)begin
				

				if(count < 156250 )begin
				out1 = 1'b0;
				next = count +1;
				end

				else if (count < 312500)begin
				out1 = 1'b1; 
				next = count +1;
				end

				else 
				next = 19'b0;
		end
		assign out = rst ? 1'b0: out1;
endmodule





module display_4bit (clk_for_display,rst, in1, in2, in3, in4, out , seven_select );//  Nedd Checking !!!!
		input [3:0] in1, in2, in3, in4;
		input clk_for_display,rst;
		output [3:0]seven_select;//  select one of the four sevenseg
		output [3:0] out;
		
		wire [1:0] count;

		reg [3:0] seven_select;
		reg [3:0] out;

		Counter_default4 counter(clk_for_display,rst,count );

		always@(count)
		begin
				case(count)
					2'd0: {out,seven_select} = {in1, 4'b1110 }; 
				    2'd1: {out,seven_select} = {in2, 4'b1101 };
					2'd2: {out,seven_select} = {in3, 4'b1011 };
					2'd3: {out,seven_select} = {in4, 4'b0111 };
				endcase
		end


endmodule


module Counter_default4(clk,rst,count);//   OK!!!!
		parameter n =2;
		input rst, clk;
		output [n-1:0] count;

		wire [n-1:0] next =   rst ? 0: count+1;// this is the operation for calculate next
		DFF #(n) counter(clk, rst , next, count);//  store the next into DFF for each posedge clk
endmodule



module DFF (clk,rst ,in, out);
		parameter n=1;
		input clk,rst;
		input [n-1:0] in;
		output [n-1:0]out;

		reg [n-1:0] out;
		//   reset

		

		always@( posedge clk or posedge rst )
		begin
				if(rst) out <= {n{1'b0}};
				else  out <= in;
		end

endmodule


