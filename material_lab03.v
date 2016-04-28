



`define bit1  7'b0110100
`define bit2  7'b0100010
`define bit3  7'b0000010
`define bit4  7'b0000001

module frequency2(clk,rst, out);// ok !!
		parameter n = 200;
		input clk,rst;
		output out;
		reg [10:0] next, count;
		reg out1;
		always@(posedge clk or rst)begin
			if(rst) count = 10'b0; 
			else count <= next;
		end

		always@(posedge clk )begin
				if(count < n/2) begin
				out1 = 1'b0;
				next = count +1;
				end

				else if(count <n)begin
				out1 = 1'b1;
				next = count +1;
				end

				else 
				next = 10'b0;
		end

		assign out = rst ? 1'b0 : out1;
			
endmodule


module frequency400(clk,rst ,out); // ok!!
		input clk,rst ;
		output out;
		reg [20:0] next, count;
			
		reg out1;
		always@(posedge clk or rst)
		begin
				if(rst)count = 19'b0;
				else count <= next;
		end

		always@(posedge clk )begin
				

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





module display_4bit (clk_for_display,rst, in1, in2, in3, in4, out , seven_select );
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
					2'd0: {out,seven_select} = {in4[0]  , in3[0],  in2[0],  in1[0] , 4'b1110 }; 
				    2'd1: {out,seven_select} = {in4[1]  , in3[1],  in2[1],  in1[1] , 4'b1101 };
					2'd2: {out,seven_select} = {in4[2]  , in3[2],  in2[2],  in1[2] , 4'b1011 };
					2'd3: {out,seven_select} = {in4[3]  , in3[3],  in2[3],  in1[3] , 4'b0111 };
				endcase
		end


endmodule


module Counter_default4(clk,rst,count);
		parameter n =2;
		input rst, clk;
		output [n-1:0] count;

		wire [n-1:0] next =   rst ? 0: count+1;// this is the operation for calculate next
		DFF #(n) counter(clk, rst , next, count);//  store the next into DFF for each posedge clk
endmodule




module Shfit_Word(clk, rst, stop ,up_down, out1, out2, out3, out4);// ok !!
		input clk;
		input rst,up_down,stop;
		output [3:0] out1, out2, out3, out4;
		Shfit_Register #(.total_bit(7),.total_out(4)) sh1(clk,rst,stop,`bit1, up_down, out1);
		Shfit_Register #(.total_bit(7),.total_out(4)) sh2(clk,rst,stop,`bit2, up_down, out2);
		Shfit_Register #(.total_bit(7),.total_out(4)) sh3(clk,rst,stop,`bit3, up_down, out3);
		Shfit_Register #(.total_bit(7),.total_out(4)) sh4(clk,rst,stop,`bit4, up_down, out4);

endmodule




module Shfit_Register(clk, rst , stop ,init_all, up_down, out);
		parameter total_bit  = 7;  // total number of bit
		parameter total_out  = 7;
		input clk; // clock shifting
		input rst,up_down,stop;
		

		input [total_bit-1:0 ] init_all;
		output [total_out-1:0] out;

		reg [total_bit-1:0] next, current;

		always@(posedge clk || rst)
		begin
				if(rst) current <= init_all;
				else current <= next;
		end

		always@(posedge clk )
		begin	
			    if(up_down==1'b1&& stop == 1'b0)
						next = { current [ total_bit-2 : 0 ],current[total_bit-1] };
				else if(up_down==1'b0 && stop == 1'b0)
						next = { current [0] ,  current[total_bit-1 : 1] };
				else
						next = current;
		end

		assign out = current[total_out-1:0];

endmodule

module DFF (clk,rst ,in, out);
		parameter n=1;
		input clk,rst;
		input [n-1:0] in;
		output [n-1:0]out;

		reg [n-1:0] out;

		always@( posedge clk or rst)
		begin
				if(rst) out <= {n{1'b0}};
				else out <= in;
		end

endmodule
