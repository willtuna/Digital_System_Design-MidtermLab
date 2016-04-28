`include "UniversalBCD.v"
module test_BCD;
reg [13:0] in;

wire [15:0] out;

UniversalBCD bcd(in, out);

initial
begin
in = 14'b0;
end





initial
fork
#100   in = 14'd821;
#200  in = 14'd421;

#300 in = 14'd1023;
#400 in = 14'd1234;
#500 in = 14'd9999;
join



endmodule
