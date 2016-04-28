`include "keypad.v"
`include "fsm.v"
`include "Display.v"
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
