module ID_EX(clk,WB_in,M_in,EX_in,RdAddr_in,RtAddr_in,shamt_in,funct_in,jumpoffset_in,RsData_in,RtData_in,se_in,pc_incr_in,
	     WB_out,M_out,EX_out,RdAddr_out,RtAddr_out,shamt_out,funct_out,jumpoffset_out,RsData_out,RtData_out,se_out,pc_incr_out);
input clk;
input [1:0]WB_in;
input [4:0]M_in;
input [4:0]EX_in;
input [4:0]RdAddr_in,RtAddr_in,shamt_in;
input [5:0]funct_in;
input [25:0]jumpoffset_in;
input [31:0]RsData_in,RtData_in,se_in,pc_incr_in;
output reg [1:0]WB_out = 0;
output reg [4:0]M_out = 0;
output reg [4:0]EX_out = 0;
output reg [4:0]RdAddr_out,RtAddr_out,shamt_out = 0;
output reg [5:0]funct_out = 0;
output reg [25:0]jumpoffset_out = 0;
output reg [31:0]RsData_out,RtData_out,se_out,pc_incr_out = 0;

always @(posedge clk)
begin
	WB_out <= WB_in;
	M_out <= M_in;
	EX_out <= EX_in;
	RdAddr_out <= RdAddr_in;
	RtAddr_out <= RtAddr_in;
	RsData_out <= RsData_in;
	RtData_out <= RtData_in;
	funct_out <= funct_in;
	jumpoffset_out <= jumpoffset_in;
	shamt_out <= shamt_in;
	se_out <= se_in;
	pc_incr_out <= pc_incr_in;
end
endmodule
