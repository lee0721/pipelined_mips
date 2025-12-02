module EX_MEM(clk,WB_in,M_in,RdAddr_in,Result_in,RtData_in,b_tgt_in,zero_in,pc_incr_in,jumpoffset_in,
	      WB_out,M_out,RdAddr_out,Result_out,RtData_out,b_tgt_out,zero_out,pc_incr_out,jumpoffset_out);
input clk,zero_in;
input [1:0]WB_in;
input [4:0]M_in;
input [4:0]RdAddr_in;
input [31:0]Result_in,RtData_in,b_tgt_in,pc_incr_in;
input [25:0]jumpoffset_in;
output reg zero_out = 0;
output reg [1:0]WB_out = 0;
output reg [4:0]M_out = 0;
output reg [4:0]RdAddr_out = 0;
output reg [31:0]Result_out,RtData_out,b_tgt_out,pc_incr_out = 0;
output reg [25:0]jumpoffset_out = 0;

always @(posedge clk)
begin
	WB_out <= WB_in;
	RdAddr_out <= RdAddr_in;
	Result_out <= Result_in;
	RtData_out <= RtData_in;
	b_tgt_out <= b_tgt_in;
	pc_incr_out <= pc_incr_in;
	jumpoffset_out <= jumpoffset_in;
	if(zero_in == 1'b1)zero_out <= 1'b1;
	else zero_out <= 1'b0;
	if(M_in != 5'd0)M_out <= M_in;
	else M_out <= 5'd0 ;
	
end
endmodule
