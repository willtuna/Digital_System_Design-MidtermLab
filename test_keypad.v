`include "keypad.v"
`timescale 1ns/1ps
module Test_keypad;

    reg clk, rst;
	reg [3:0]in ;
	wire [7:0]press_pos;
	wire [3:0] row_select;
	wire [7:0] enc_out;
	wire pressed; 
    Keypad_Top keypad(clk, rst, in, row_select,enc_out,pressed);
    /*initial begin
		$fsdbDumpfile("waveform.fsdb");
		$fsdbDumpvars;
    end*/
    

    initial
    begin
//	outfile= $fopen("OUTPUT.out");
	clk= 1'b0;
	rst= 1'b0;
    in = 4'b0;
    end

    always begin
	#1 clk= ~clk;
    end
    
/*    always@(out)
    begin
	#5 $fdisplay(outfile, "%d out= %b   an=%d\n", $time, out, an);
    end
*/    
    initial 
    begin
	#1 rst= 1'b1;
    #10 rst = 1'b0;
	end
    initial begin
    #10000_0000 in =4'b0100;
    #10000_0000 in =4'b0000;
    #10000_0000 in =4'b0100;
    #10000_0000 in =4'b0000;
    #10000_0000 in =4'b0100;
    #10000_0000 in =4'b0000;
    #10000_0000 in =4'b1000;
    #10000_0000 in =4'b0000;
    #10000_0000 in =4'b0001;
    #10000_0000 in =4'b0000;
    #10000_0000 $stop;
    end

endmodule
