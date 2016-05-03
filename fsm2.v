`ifndef _fsm_v
`define _fsm_v

`include "UniversalBCD.v"
`include "calculation.v"
`include "keypad.v"

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

    always@(negedge pressed or posedge rst)begin
	
