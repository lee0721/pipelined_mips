//	Title: MIPS Single-Cycle Processor
//	Editor: Selene (Computer System and Architecture Lab, ICE, CYCU)




module mips_single(clk, rst, div_clk);
	input clk, rst, div_clk;
	
	// instruction bus
	wire [31:0]IF_Instr,ID_Instr;

	// break out important fields from instruction
	wire [31:0] ID_extend_immed,EX_extend_immed;
	wire [4:0] EX_rfile_wn,M_rfile_wn,WB_rfile_wn;
	// datapath signals
	wire [63:0]Div_out;
	wire [31:0]IF_pc_incr,ID_pc_incr,EX_pc_incr,M_pc_incr,ID_rfile_rd1,ID_rfile_rd2,EX_rfile_rd1,EX_rfile_rd2,M_rfile_rd2,alu_b,
		   b_offset,EX_b_tgt,M_b_tgt,EX_alu_out,M_alu_out,WB_alu_out,M_dmem_rdata,WB_dmem_rdata,rfile_wd,branch_addr,
		   pc_next,pc,HiLo_Out,alu_out;
	wire [25:0]EX_jumpoffset,M_jumpoffset;
	wire [4:0]EX_RdAddr,EX_RtAddr;
	wire [4:0]EX_shamt;
	wire [5:0]EX_funct;
		
	// control signals
	wire EX_zero,M_zero,M_zero_bar,PCSrc,RegWrite,MemtoReg,MemWrite,MemRead,RegDst,ALUSrc,Ori,Beq,Bne,Jump,Bne_AND,Beq_AND,HiLo_signal,alu_out_sel;
	wire [1:0]EX_WBcontrol,M_WBcontrol,WB_WBcontrol,ALUOp;//{RegWrite,MemtoReg}
	wire [4:0]EX_Mcontrol,M_Mcontrol;//{MemWrite,MemRead,Beq,Bne,Jump}
	wire [4:0]EX_EXcontrol;//{Ori,RegDst,ALUSrc,[1:0]ALUOp}
	wire [2:0]Operation;
	wire [31:0]jump_addr;
	// branch offset shifter
    	assign b_offset = EX_extend_immed << 2;
	// jump offset shifter & concatenation
	assign jump_addr = { M_pc_incr[31:28], M_jumpoffset << 2 };
	
	// module instantiations
	
	reg32 PC( 
		//input
		.clk(clk), 
		.rst(rst), 
		.en_reg(1'b1), 
		.d_in(pc_next), 
		//output
		.d_out(pc) 
	);

	// sign-extender
	sign_extend SignExt( 
		//input
		.immed_in(ID_Instr[15:0]), 
		//output
		.ext_immed_out(ID_extend_immed) 
	);
	
	add32 PCADD( 
		//input
		.a(pc), 
		.b(32'd4),
 		//output
		.result(IF_pc_incr) 
	);

    	add32 BRADD(
 		//input
		.a(EX_pc_incr), 
		.b(b_offset), 
		//output
		.result(EX_b_tgt) 
	);

    	alu ALU( 
		//input
		.ctl(Operation), 
		.a(EX_rfile_rd1), 
		.b(alu_b), 
		.shamt(EX_shamt),
		//output
		.result(alu_out), 
		.zero(EX_zero) 
	);
	
	Divider Divider(
		//input
 		.div_clk(div_clk), 
		.dataA(EX_rfile_rd1), 
		.dataB(EX_rfile_rd2), 
		.Funct(EX_funct),  
		.rst(rst), 
		//output
		.dataOut(Div_out),
		.HiLo_signal(HiLo_signal),
		.alu_out_sel(alu_out_sel)
	);
	HiLo HiLo( 
		//input
		.clk(clk), 
		.DivAns(Div_out),  
		.rst(rst), 
		.HiLo_signal(HiLo_signal), 
		//output
		.HiLo_Out(HiLo_Out)
	);

    	and BEQ_AND(Beq_AND,M_Mcontrol[2],M_zero);//{MemWrite,MemRead,Beq,Bne,Jump}
	not BNE_NOT(M_zero_bar,M_zero);
	and BNE_AND(Bne_AND,M_Mcontrol[1],M_zero_bar);//{MemWrite,MemRead,Beq,Bne,Jump}
	or BR_OR(PCSrc,Bne_AND,Beq_AND);

   	mux2 #(5) RFMUX(
 		//input
		.sel(EX_EXcontrol[3]),//{Ori,RegDst,ALUSrc,[1:0]ALUOp} 
		.a(EX_RtAddr), 
		.b(EX_RdAddr), 
		//output
		.y(EX_rfile_wn) 
	);

    	mux2 #(32) PCMUX( //???
		//input
		.sel(PCSrc), 
		.a(IF_pc_incr), 
		.b(M_b_tgt), 
		//output
		.y(branch_addr) 
	);
	
	mux2 #(32) JMUX( 
		//input
		.sel(M_Mcontrol[0]),//{MemWrite,MemRead,Beq,Bne,Jump}
		.a(branch_addr), 
		.b(jump_addr),
 		//output
		.y(pc_next) 
	);
	
    	mux2 #(32) ALUMUX( 
		//input
		.sel(EX_EXcontrol[2]),//{Ori,RegDst,ALUSrc,[1:0]ALUOp} 
		.a(EX_rfile_rd2), 
		.b(EX_extend_immed), 
		//output
		.y(alu_b) 
	);
	mux2 #(32) ALUOUTMUX( 
		//input
		.sel(alu_out_sel), 
		.a(alu_out), 
		.b(HiLo_Out), 
		//output
		.y(EX_alu_out)
	);

	mux2 #(32) WRMUX( 
		//input
		.sel(WB_WBcontrol[0]),//{RegWrite,MemtoReg} 
		.a(WB_alu_out), 
		.b(WB_dmem_rdata), 
		//output
		.y(rfile_wd) 
	);

    	control_single CTL(
		//input
		.opcode(ID_Instr[31:26]),
 		//output
		.RegDst(RegDst), 
		.ALUSrc(ALUSrc), 
		.MemtoReg(MemtoReg), 
                .RegWrite(RegWrite), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite),
 		.Ori(Ori), 
		.Beq(Beq), 
		.Bne(Bne),
		.Jump(Jump), 
		.ALUOp(ALUOp)
	);

    	alu_ctl ALUCTL(  
		//input
		.ALUOp(EX_EXcontrol[1:0]),//{Ori,RegDst,ALUSrc,ALUOp} 
		.Funct(EX_funct), 
		.Ori(EX_EXcontrol[4]),//{Ori,RegDst,ALUSrc,ALUOp}
		//output
		.ALUOperation(Operation)
	);
	

	reg_file RegFile( 
		//input
		.clk(clk), 
		.RegWrite(WB_WBcontrol[1]), //WB,{RegWrite,MemtoReg}
		.RN1(ID_Instr[25:21]), 
		.RN2(ID_Instr[20:16]), 
		.WN(WB_rfile_wn), //WB
		.WD(rfile_wd),
		//output
		.RD1(ID_rfile_rd1), 
		.RD2(ID_rfile_rd2) 
	);

	memory InstrMem( 
		//input
		.clk(clk), 
		.MemRead(1'b1), 
		.MemWrite(1'b0), 
		.wd(32'd0), 
		.addr(pc),
 		//output
		.rd(IF_Instr) 
	);

	memory DatMem( 
		//input
		.clk(clk), 
		.MemRead(M_Mcontrol[3]), //{MemWrite,MemRead,Beq,Bne,Jump}
		.MemWrite(M_Mcontrol[4]), //{MemWrite,MemRead,Beq,Bne,Jump}
		.wd(M_rfile_rd2), 
		.addr(M_alu_out),
 		//output
		.rd(M_dmem_rdata) 
	);	   
	
	IF_ID IF_ID(
		//input
		.clk(clk),
		.Instr_in(IF_Instr),
		.pc_incr_in(IF_pc_incr),
		//output
		.Instr_out(ID_Instr),
		.pc_incr_out(ID_pc_incr)
	);
	
	ID_EX ID_EX(
		//input
		.clk(clk),
		.WB_in({RegWrite,MemtoReg}),
		.M_in({MemWrite,MemRead,Beq,Bne,Jump}),
		.EX_in({Ori,RegDst,ALUSrc,ALUOp}),
		.RdAddr_in(ID_Instr[15:11]),
		.RtAddr_in(ID_Instr[20:16]),
		.shamt_in(ID_Instr[10:6]),
		.funct_in(ID_Instr[5:0]),
		.jumpoffset_in(ID_Instr[25:0]),
		.RsData_in(ID_rfile_rd1),
		.RtData_in(ID_rfile_rd2),
		.se_in(ID_extend_immed),
		.pc_incr_in(ID_pc_incr),
		//output
	     	.WB_out(EX_WBcontrol),//{RegWrite,MemtoReg}
		.M_out(EX_Mcontrol),//{MemWrite,MemRead,Beq,Bne,Jump}
		.EX_out(EX_EXcontrol),//{Ori,RegDst,ALUSrc,ALUOp}
		.RdAddr_out(EX_RdAddr),
		.RtAddr_out(EX_RtAddr),
		.shamt_out(EX_shamt),
		.funct_out(EX_funct),
		.jumpoffset_out(EX_jumpoffset),
		.RsData_out(EX_rfile_rd1),
		.RtData_out(EX_rfile_rd2),
		.se_out(EX_extend_immed),
		.pc_incr_out(EX_pc_incr)
	);

	EX_MEM EX_MEM(
		//input
		.clk(clk),
		.WB_in(EX_WBcontrol),
		.M_in(EX_Mcontrol),
		.RdAddr_in(EX_rfile_wn),
		.Result_in(EX_alu_out),
		.RtData_in(EX_rfile_rd2),
		.b_tgt_in(EX_b_tgt),
		.zero_in(EX_zero),
		.pc_incr_in(EX_pc_incr),
		.jumpoffset_in(EX_jumpoffset),
		//output
		.WB_out(M_WBcontrol),
		.M_out(M_Mcontrol),
		.RdAddr_out(M_rfile_wn),
		.Result_out(M_alu_out),
		.RtData_out(M_rfile_rd2),
		.b_tgt_out(M_b_tgt),
		.zero_out(M_zero),
		.pc_incr_out(M_pc_incr),
		.jumpoffset_out(M_jumpoffset)
	);

	MEM_WB MEM_WB(
		//input
		.clk(clk),
		.WB_in(M_WBcontrol),
		.RdAddr_in(M_rfile_wn),
		.Result_in(M_alu_out),
		.MemReadData_in(M_dmem_rdata),
		//output
		.WB_out(WB_WBcontrol),
		.RdAddr_out(WB_rfile_wn),
		.Result_out(WB_alu_out),
		.MemReadData_out(WB_dmem_rdata)
	);
				   
endmodule

