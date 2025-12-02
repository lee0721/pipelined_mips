module MEM_WB(clk,WB_in,RdAddr_in,Result_in,MemReadData_in,WB_out,RdAddr_out,Result_out,MemReadData_out);
input clk;
input [1:0]WB_in;
input [4:0]RdAddr_in;
input [31:0]Result_in,MemReadData_in;
output reg [1:0]WB_out = 0;
output reg [4:0]RdAddr_out = 0;
output reg [31:0]Result_out,MemReadData_out = 0;

always @(posedge clk)
begin
	WB_out <= WB_in;
	RdAddr_out <= RdAddr_in;
	Result_out <= Result_in;
	MemReadData_out <= MemReadData_in;
end
endmodule
