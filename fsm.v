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
`define error_state  7'b111_1111

module Calculator_fsm(clk,rst,in,pressed,digit4,digit3,digit2,digit1);
    input clk,rst;
	input [7:0] in;
    input pressed;
	output reg [3:0] digit4,digit3,digit2,digit1;

	reg [6:0] next_st, state;
    reg [7:0] A1,A0,B1,B0,OP;     // storage the in in differnet state
	//wire Unpressed = &in;



// ----------  Turn into wrie for CL of calculation module  ------
	reg [7:0] ad1,ad0,bd1,bd0,opreg;

    wire [7:0] a1,a0,b1,b0,op;
    assign   a1=ad1 ;
    assign   a0=ad0 ;  
    assign	 op=opreg ;
    assign   b1=bd1;
    assign   b0=bd0 ;
//------------------------------------------
//--------------------calculation---------------------
    wire [13:0] answer;
	wire [15:0] ans_BCD;
	calculation cal(rst,a1,a0,op,b1,b0,answer);
    UniversalBCD result_to_BCD(answer,ans_BCD);


  
//----------------------------------------------------------------------
  /*      reg press_clk;

       always@(clk)begin
				if(pressed) press_clk = clk;
				else;
	   end*/
// ------------------- FF structure  ---- Store pressed value -------------
     always@(negedge pressed or posedge rst)begin
				if(rst) begin
				{ad1,ad0,opreg,bd1,bd0} <=  24'b0 ;
				end
				else if (in == `encout_Clear)
		        {ad1,ad0,opreg,bd1,bd0} <=  24'b0 ;
				else
				{ad1,ad0,opreg,bd1,bd0} <= {A1,A0,OP,B1,B0} ;
     end
//---------------------------------------------------------------------------
	 always@( pressed)begin

		if(pressed) begin
				case(state) 
					`state_ini :  
					    begin
								if(in[7:4]== 4'b0)
								A1 = in;
								else;
						end
					`store_1stD1:
						begin
								if(in[7:4]== 4'b0)
								A0 = in;
								else;
						end
					`store_1stD0:
						begin
								if(in[7:4]== 4'b1111)
								OP = in;
								else;
						end
				    `store_op:
				        begin
								if(in[7:4]== 4'b0)
								B1 = in;
								else;
						end
				    `store_2ndD1:
					    begin
								if(in[7:4]==4'b0)
								B0 = in;
								else;
						end 
						default: begin
						       A1 =A1;
							   A0 =A0;
							   B1=B1;
							   B0=B0;
							   OP=OP;
					    end

					endcase
		end
		else; /*begin
		A1 =A1;
		A0 =A0;
		B1=B1;
		B0=B0;
		OP=OP;
		end*/
end
								




//--------------------- DFF -----------------------------------
    always@(negedge pressed or posedge rst)begin
		if(rst)begin
				state <= `state_ini ;
				end
		else begin
				state <= next_st;
		end
	end
//------------------------------------------------------------

//---------------  Next State Combination Circuit----------------------------
always@(  pressed  )begin
		if( in == `encout_Clear ) begin
		next_st = `state_ini;
		end 

				else begin

				case(state)
						`state_ini : begin
							if(pressed && (in[7:4]==4'b0000)) begin
							next_st =  `store_1stD1; 
							end
							else next_st = `state_ini;
				end

						`store_1stD1: begin
						if(pressed && (in[7:4]==4'b0000) ) begin
						next_st = `store_1stD0;
						end
						else	next_st = `store_1stD1;
		        end
		                `store_1stD0: begin  //   there is no dummy avoidance !!!!!!
				        if(pressed && (in[7:4]== 4'b1111)) begin
						next_st = `store_op;
				        end
				        else    next_st = `store_1stD0;
		        end
						`store_op   : begin
						if(pressed && (in[7:4]==4'b0000) ) begin
						next_st= `store_2ndD1;
						end
						else    next_st = `store_op;
				end
				
						`store_2ndD1: begin
						if(pressed && (in[7:4]==4'b0000)) begin
						next_st = `store_2ndD0;
						end
						else	next_st = `store_2ndD1;
				end

						`store_2ndD0: begin
						if(pressed) begin
						next_st = (in == `encout_Equ ) ? `EqualPressed: `store_2ndD0;
						end
						else  next_st = `store_2ndD0;
				end
						`EqualPressed: begin
						if( in == `encout_Clear ) begin
						next_st = `state_ini;
						end
						else  next_st = `EqualPressed;
				end
						default:  begin
						next_st = `error_state;

				end
				

				endcase
		end
end


// ------------------- Output Logic Combinational Circuit ----------------------

always@(*) begin

				case(state)
						`state_ini : begin
					    {digit4,digit3,digit2,digit1} = {4'd0,4'hf,4'hf,4'hf};
						end

						`store_1stD1: begin
					    {digit4,digit3,digit2,digit1} = {4'd1,4'hf,4'hf,ad1[3:0]};
						end
						
		                `store_1stD0: begin  //   there is no dummy avoidance !!!!!!
					    {digit4,digit3,digit2,digit1} = {4'd2,4'hf,ad1[3:0],ad0[3:0]};
						end

						`store_op   : begin
					    {digit4,digit3,digit2,digit1} = {4'd3,4'hf,ad1[3:0],ad0[3:0]};
						end
				
						`store_2ndD1: begin
					    {digit4,digit3,digit2,digit1} = {4'd4,4'hf,4'hf,bd1[3:0]};
						end

						`store_2ndD0: begin
					    {digit4,digit3,digit2,digit1} = {4'd5,4'hf,bd1[3:0],bd0[3:0]};
						end
						`EqualPressed: begin
				
					    {digit4,digit3,digit2,digit1} = ans_BCD;
						end

						default:  begin
						if(state == `error_state)
				    	 {digit4,digit3,digit2,digit1} = {4'd9,4'd9,4'd9,4'd9};

						end
				

				endcase
end

endmodule



`endif
