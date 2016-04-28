module Midterm_Lab_Top(clk,rst,column_in,row_sweep,seven_out,seven_select);

		input clk,rst;
		input [3:0] column_in;

		output [3:0] row_sweep, seven_select;
		output [6:0] seven_out;
		wire [3:0] digit4,digit3,digit2,digit1;
		
		wire [7:0] enc_out;
		wire pressed;
		Keypad_Top pad(clk,rst, column_in, row_sweep,enc_out,pressed);
		
		
		Calculator_fsm  fsm_data(clk,rst,enc_out,pressed,digit4,digit3,digit2,digit1);
		
		
		Display dis(clk,rst,digit4,digit3,digit2,digit1,seven_out,seven_select);
				
		

endmodule

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


`define state_ini    7'b000_0001
`define store_1stD1  7'b000_0010
`define store_1stD0  7'b000_0100
`define store_op     7'b000_1000
`define store_2ndD1  7'b001_0000
`define store_2ndD0  7'b010_0000
`define EqualPressed 7'b100_0000


module Calculator_fsm(clk,rst,in,pressed,digit4,digit3,digit2,digit1);
    input clk,rst;
	input [7:0] in;
    input pressed;
	output reg [3:0] digit4,digit3,digit2,digit1;

	reg [6:0] next_st, state;
	wire [6:0] next_st_in;
    reg [7:0] A1,A0,B1,B0,OP;     // storage the in in differnet state
	//wire Unpressed = &in;



// ----------  Turn into wrie for CL of calculation module  ------
    wire [7:0] a1,a0,b1,b0,op;
    assign   a1=A1 ;
    assign   a0=A0 ;  
    assign	 op=OP ;
    assign   b1=B1 ;
    assign   b0=B0 ;
//------------------------------------------

    wire [13:0] answer;
	wire [15:0] ans_BCD;
	calculation cal(rst,a1,a0,op,b1,b0,answer);
    UniversalBCD result_to_BCD(answer,ans_BCD);

//----------------------------------------------------------------------
       reg press_clk;

       always@(clk)begin
				if(pressed) press_clk = clk;
	   end



//--------------------- DFF -----------------------------------
    always@(negedge pressed or posedge rst)begin
		if(rst)
				state <= `state_ini ;
		else
				state <= next_st_in;

	end
//------------------------------------------------------------



//---------------  Next State Combination Circuit----------------------------
	always@( press_clk or  rst )begin
		if(rst) begin
		A1 = 8'bz; 
		A0 = 8'bz;
		OP = 8'bz;
		B1 = 8'bz;
		B0 = 8'bz;
		end 


		else begin

		case(state)
		  `state_ini : begin
				if(pressed) begin
				next_st =  `store_1stD1; 
				A1  =  in; // assign to reg
				//  show sevenseg  BCD(rst,in,out)
				{digit4,digit3,digit2,digit1} = {4'bz,4'bz,4'bz,in[3:0]};
				end
				else
				next_st = `state_ini;
		  end

		   `store_1stD1: begin
				if(pressed) begin
				next_st = `store_1stD0;
				A0 = in;
				//  show_sevenseg BCD
				{digit4,digit3,digit2,digit1} = {4'bz,4'bz,A1[3:0],A0[3:0]};
				end

				else next_st = `store_1stD1;
		  end

		   `store_1stD0: begin  //   there is no dummy avoidance !!!!!!
				if(pressed) begin

						if( in[7] == 1'b1 )begin
						next_st = `store_op;
						OP = in;
						// No need to show
						end
						else next_st = `store_1stD0;
				end
				else next_st = `store_1stD0;
		   end
		   `store_op   : begin
				if(pressed) begin
				next_st= `store_2ndD1;
				B1 =  in;
				//show
				{digit4,digit3,digit2,digit1} = {4'bz,4'bz,4'bz,B1[3:0]};
				end

				else next_st = `store_op;
		  end

		   `store_2ndD1: begin
				if(pressed) begin
				next_st = `store_2ndD0;
				B0 = in;					
				//show
				{digit4,digit3,digit2,digit1} = {4'bz,4'bz,B1[3:0],B0[3:0]};
				end

				else next_st = `store_2ndD1;
		   end

		   `store_2ndD0: begin
				if(pressed) begin
				next_st = (in == `E_qual ) ? `EqualPressed  : `store_2ndD0;
				//no need to show
				end
				else next_st = `store_2ndD0;
		   end
		   `EqualPressed: begin
				//  combinational logic to calculate the result
				{digit4,digit3,digit2,digit1} = ans_BCD;
				// show
		   end
		
		   endcase
		
		end
		
end

		assign next_st_in = rst ? `state_ini : next_st;


endmodule


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

