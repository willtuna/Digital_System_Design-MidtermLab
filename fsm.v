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
  /*     reg press_clk;

       always@(clk)begin
				if(pressed) press_clk = clk;
	   end*/



//--------------------- DFF -----------------------------------
    always@(negedge pressed or posedge rst)begin
		if(rst)
				state <= `state_ini ;
		else
				state <= next_st_in;

	end
//------------------------------------------------------------



//---------------  Next State Combination Circuit----------------------------
	always@( * )begin
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



