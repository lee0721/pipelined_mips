module IF_ID(clk,Instr_in,pc_incr_in,Instr_out,pc_incr_out);
input clk;
input [31:0]Instr_in,pc_incr_in;
output reg [31:0]Instr_out,pc_incr_out = 0;

always @(posedge clk)
begin
	Instr_out <= Instr_in;
	pc_incr_out <= pc_incr_in;
end
endmodule
