//need another frequency divider for down_scale frequency
/********************************************************
Pseudo:

Row    :  Sweep by the clcok , each 4 clk cycle change to next row
Column :  Sweep for each row,  when the bottom is pressed
		  it would output 1 , such as 0100 for the current column


But there is a problem, what if  I keep pressing the buttom,
but the column detector would output 0100 every 16 clk cycle,
In this scenario, how do we know, we are presssing or double pressing.

Solution 1
		Since all my circuit is trigger through column_select !!
if we detect the pressed, and the bottom is still be pressed,
I first stop the column from shifting to next ~~ Stop sweeping the column
until I realeased the bottom, (negative edge trigger)

		What about the row ?? 
		Since my row is shifted by my column_select....
So, if I didn't change my column, my row wouldn't changed....
Therefore my row is never been shifted ...... That is the reason why
I could fixed my detection at the same row_select and column_select


Remark :
		There is other solution for sigle counter triggering 
We choose the pull up circuit configuration of the input(column)......

Solution2 :

As my row is select through 0111
      row 
		0          p
		1
		1
		1
		 ------------  -VCC connected
          1  1  1  0

as pressed is detected , we just fix the row output ...
as pressed is released, row start shifting ........

  ******************************************************/
`ifndef _keypad_v
`define _keypad_v
module Keypad_Top(clk, rst, col_in, row_out, enc_out, pressed);
		input clk, rst;
		input [3:0] col_in;
		output [3:0] row_out;
		output [7:0] enc_out;
		output pressed;
		wire keypad_clk;
		wire [7:0] keypad_code;  //   pattern {col[3:0], row[3:0]}
		Freq_Keypad freq_for_keypad(clk, rst, keypad_clk);

		Keypad keypad_sweep(keypad_clk,rst,col_in,row_out,keypad_code, pressed);

		Keypad_Encoder keypad_enc(keypad_code, enc_out);

endmodule






module Freq_Keypad(clk, rst ,keypad_clk);
		input clk,rst;
		output reg keypad_clk;

		integer i =0 ;

		always@(posedge clk or posedge rst)begin
		if(rst) begin
				i =0;
				keypad_clk = 1'b0;
				end

		else if(i<312500)begin
				keypad_clk = 1'b0;
				i = i +1;
				end

		else if(i<625000)begin
				keypad_clk = 1'b1;
				i = i +1;		
				end

		else i = 0;

		end



endmodule




module  Keypad( clk, rst, in, row_sweep,press_pos, pressed );
		input clk, rst;
		input [3:0] in;
		output [3:0] row_sweep; // updated 
		output [7:0]press_pos;
		output reg pressed;
		reg [3:0] col_next, col_current;
     	reg [3:0] row_next, row_current;

		reg [7:0] press_pos;

		always@(posedge clk or posedge rst)begin
				if(rst) col_current <= 4'b1000;
				else if( in == col_current) ; // to stop the clock of col_current  *************
				else col_current <=  col_next;
		end


		





//   This is for press detection
		always@(*)begin

				if(in == col_current) begin
				press_pos =  rst ? {8{1'b1}}  : {in,row_current};
				pressed = 1'b1;
				end

				else pressed = 1'b0;
		end

//  Because of our keypad configuration is {column[3:0], row[3:0] }


		always@(col_current)begin//  as col_current_chaged !!! execute 
				col_next = {col_current[0] , col_current[3:1]} ;// shift right
		end



		always@(negedge col_current[3] or posedge rst)begin
				if(rst) row_current<= 4'b1000;
				else row_current <= row_next;
		end

		always@(row_current)begin
				row_next = {row_current[0], row_current[3:1]} ;
		end

		assign row_sweep = row_current;


endmodule


`define zero   8'b10000001
`define one    8'b01000001
`define two    8'b01000010
`define three  8'b01000100
`define four   8'b00100001
`define five   8'b00100010
`define six    8'b00100100
`define seven  8'b00010001
`define eight  8'b00010010
`define nine   8'b00010100
`define A_add  8'b10000010
`define B_sub  8'b10000100
`define f_mult 8'b10001000
`define Cclear 8'b00011000
`define E_qual 8'b01001000
`define D_ivid 8'b00101000

module Keypad_Encoder(in,out);
		input [7:0] in;
		output reg [7:0] out;
		always@(*) begin
				casez(in)
				`zero  : out =  8'b0;
				`one   : out =  8'd1;
				`two   : out =  8'd2;
				`three : out =  8'd3;
				`four  : out =  8'd4;
				`five  : out =  8'd5;
				`six   : out =  8'd6;
				`seven : out =  8'd7;
				`eight : out =  8'd8;
				`nine  : out =  8'd9;

				`A_add : out = `A_add;
				`B_sub : out = `B_sub;
				`f_mult: out = `f_mult;
				`E_qual: out = `E_qual;
				`D_ivid: out = `D_ivid;
				`Cclear: out = `Cclear;
				
				default : out = 8'b11111111;
		endcase
		end
endmodule




`endif
