`include "Display.v"//  tested !!!

module TestDisplay;
		reg[3:0] digit1,digit2,digit3,digit4;
		reg clk,rst;

		wire [6:0] sevenout;
		wire [3:0] seven_select;
Display dis(clk, rst, digit4, digit3,digit2,digit1,sevenout, seven_select);



initial begin
clk = 1'b0;
rst = 1'b0;
digit1 = 4'd0;
digit2 = 4'd0;
digit3 = 4'd0;
digit4 = 4'd0;

forever
#1 clk = ~clk;

end


initial begin


#1
rst = 1'b1;
#10
rst = 1'b0;

#10_000_000

digit1 = 4'd9;
digit2 = 4'd0;
digit3 = 4'dz;
digit4 = 4'dz;

#10_000_000

digit1 = 4'd5;
digit2 = 4'd0;
digit3 = 4'dz;
digit4 = 4'dz;

#10_000_000

digit1 = 4'd9;
digit2 = 4'd5;
digit3 = 4'dz;
digit4 = 4'dz;

#10_000_000

digit1 = 4'd9;
digit2 = 4'd6;
digit3 = 4'dz;
digit4 = 4'dz;


end

endmodule
