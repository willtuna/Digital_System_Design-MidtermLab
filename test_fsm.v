`include "fsm.v"


module test_fsm;
		reg clk,rst;
		reg [7:0] in;
		reg pressed;
		wire [3:0] d4,d3,d2,d1;
		Calculator_fsm  fsm(clk,rst,in,pressed,d4,d3,d2,d1);



		initial begin
		rst = 0; clk =0;
		pressed = 0;

		forever
		#1 clk = ~clk;
		
		end
		



		initial begin
		#5 rst =1'b1;
		#5 rst =1'b0;

		#10
		   in = 8'd3; pressed = 1'b1;
		#50 pressed = 1'b0;
		#1000
		   in = 8'd5; pressed = 1'b1;
		#50 pressed = 1'b0;
		#1000
		   in = 8'b1000_0010; pressed = 1'b1;
		#50 pressed = 1'b0;
		#1000
		   in = 8'd4; pressed = 1'b1;
		#50 pressed = 1'b0;
		#1000
		   in = 8'd5; pressed = 1'b1;
		#50 pressed = 1'b0;
		#1000
		   in = 8'b0100_1000; pressed = 1'b1;
		#50 pressed = 1'b0;
		#1000
		#100 rst = 1'b1;
		   $stop;



		end




endmodule
