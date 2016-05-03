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
		if(rst)begin
				state <= `state_ini ;
				end
		else
				state <= next_st;

	end
//------------------------------------------------------------



//---------------  Next State Combination Circuit----------------------------
	always@(posedge pressed or posedge rst)begin
		if( (`encout_Clear == in) || rst) begin
		A1 = 8'bz; 
		A0 = 8'bz;
		OP = 8'bz;
		B1 = 8'bz;
		B0 = 8'bz;
		next_st = `state_ini;
		{digit4,digit3,digit2,digit1} = {4'd0,4'bz,4'bz,4'bz};
		end 


		else begin

		casez(state)
		  `state_ini : begin
				if(pressed && (in[7]==1'b0)) begin
				next_st =  `store_1stD1; 
				A1  =  in; // assign to reg
				end
				else begin
				next_st = `state_ini;
				{digit4,digit3,digit2,digit1} = {4'd0,4'bz,4'bz,4'bz};
				end
		  end

		   `store_1stD1: begin
				if(pressed && (in[7]==1'b0) ) begin
				next_st = `store_1stD0;
				A0 = in;
				//  show_sevenseg BCD
				end

				else begin
				next_st = `store_1stD1;
				{digit4,digit3,digit2,digit1} = {4'd1,4'bz,4'bz,A1[3:0]};
				end

		  end

		   `store_1stD0: begin  //   there is no dummy avoidance !!!!!!
				if(pressed) begin

						if( in[7:4] == 4'b1111 )begin
						next_st = `store_op;
						OP = in;
						end
						else next_st = `store_1stD0;
				end
				else begin 
				next_st = `store_1stD0;
				{digit4,digit3,digit2,digit1} = {4'd2,4'bz,A1[3:0],A0[3:0]};
				end
		   end
		   `store_op   : begin
				if(pressed && (in[7]==1'b0) ) begin
				next_st= `store_2ndD1;
				B1 =  in;
				//show
				end

				else begin
				next_st = `store_op;
				{digit4,digit3,digit2,digit1} = {4'd3,4'bz,4'bz,4'bz};
				end
		  end
				
		   `store_2ndD1: begin
				if(pressed && (in[7]==1'b0)) begin
				next_st = `store_2ndD0;
				B0 = in;					
				end

				else begin
				next_st = `store_2ndD1;
				{digit4,digit3,digit2,digit1} = {4'd3,4'bz,4'bz,B1[3:0]};
				end
		   end

		   `store_2ndD0: begin
				if(pressed) begin
				next_st = (in == `encout_Equ ) ? `EqualPressed: `store_2ndD0;
				//no need to show
				end
				else begin
				next_st = `store_2ndD0;
				{digit4,digit3,digit2,digit1} = {4'd4,4'bz,B1[3:0],B0[3:0]};
				end
		   end
		   `EqualPressed: begin
				//  combinational logic to calculate the result
				{digit4,digit3,digit2,digit1} = ans_BCD;
				// show
		   end
           default:  begin
				  	{digit4,digit3,digit2,digit1} = {4'd9,4'd9,4'd9,4'd9};
		   end

		   
		   endcase
		
		end
		
end



endmodule


`endif
