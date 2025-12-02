module HiLo( clk, DivAns, HiLo_Out, rst, HiLo_signal);
input clk ;
input rst ;
input HiLo_signal;
input [63:0] DivAns ;
output reg [31:0] HiLo_Out;

always@(HiLo_signal or rst )
begin
	if (rst)
	begin 
		HiLo_Out <= 64'b0 ;
	end
	else if(HiLo_signal == 0) 
	begin
		HiLo_Out <= DivAns[63:32] ; // remainder
	end
	else if(HiLo_signal == 1) 
	begin
	HiLo_Out <= DivAns[31:0] ; // quotient
	end
end
endmodule