`include "keypad.v"
`include "Display.v"

module keypad_physical_test(clk,rst,column_in,row_sweep,seven_out,seven_select);

		input clk,rst;
		input [3:0] column_in;

		output [3:0] row_sweep, seven_select;
		output [6:0] seven_out;
		wire [3:0] digit4,digit3,digit2,digit1;
		
		wire [7:0] enc_out;
		wire pressed;
    Keypad_Top keypad(clk,rst,column_in,row_sweep,enc_out,pressed);
    Display dis(clk,rst,digit4,digit3,{3'b0,pressed},enc_out[3:0],seven_out,seven_select);
	
endmodule
