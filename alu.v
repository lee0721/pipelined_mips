/*
	Title:	ALU
	Author: Garfield (Computer System and Architecture Lab, ICE, CYCU)
	Input Port
		1. ctl: 由alu_ctl解碼完的控制訊號
		2. a:   inputA,第一筆要處理的資料
		3. b:   inputB,第二筆要處理的資料
	Output Port
		1. result: 最後處理完的結果
		2. zero:   branch指令所需要之輸出
*/


module alu(ctl, a, b, result, shamt, zero);
  input [2:0] ctl;
  input [31:0] a, b; // 32 bit
  input  [4:0]  shamt;
  output wire [31:0] result;
  output wire zero;
  //output zero;

  wire [31:0] sll_ans, temp ;
  wire [30:0] c ;//放每個bit slices跑出來的cout，然後這個cout再丟給下一個
  wire [1:0] sel ;  
  wire set, cout, invertB ;// 0 to add / 1 to subtract
  assign sel = ctl[1:0];
  assign invertB = ctl[2];
  assign zero = (temp == 32'd0)? 1: 0 ;
  assign result = (ctl == 3'b011)? sll_ans : temp ;

  Bitslices alu1( .dataA(a[0]), .dataB(b[0]), .cin(invertB), .Signal(sel), .invertB(invertB), .less(set), .dataOut(temp[0]), .cout(c[0]) ) ;
  Bitslices alu2( .dataA(a[1]), .dataB(b[1]), .cin(c[0]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[1]), .cout(c[1]) ) ;
  Bitslices alu3( .dataA(a[2]), .dataB(b[2]), .cin(c[1]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[2]), .cout(c[2]) ) ;
  Bitslices alu4( .dataA(a[3]), .dataB(b[3]), .cin(c[2]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[3]), .cout(c[3]) ) ;
  Bitslices alu5( .dataA(a[4]), .dataB(b[4]), .cin(c[3]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[4]), .cout(c[4]) ) ;
  Bitslices alu6( .dataA(a[5]), .dataB(b[5]), .cin(c[4]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[5]), .cout(c[5]) ) ;
  Bitslices alu7( .dataA(a[6]), .dataB(b[6]), .cin(c[5]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[6]), .cout(c[6]) ) ;
  Bitslices alu8( .dataA(a[7]), .dataB(b[7]), .cin(c[6]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[7]), .cout(c[7]) ) ;
  Bitslices alu9( .dataA(a[8]), .dataB(b[8]), .cin(c[7]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[8]), .cout(c[8]) ) ;
  Bitslices alu10( .dataA(a[9]), .dataB(b[9]), .cin(c[8]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[9]), .cout(c[9]) ) ;
  Bitslices alu11( .dataA(a[10]), .dataB(b[10]), .cin(c[9]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[10]), .cout(c[10]) ) ;
  Bitslices alu12( .dataA(a[11]), .dataB(b[11]), .cin(c[10]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[11]), .cout(c[11]) ) ;
  Bitslices alu13( .dataA(a[12]), .dataB(b[12]), .cin(c[11]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[12]), .cout(c[12]) ) ;
  Bitslices alu14( .dataA(a[13]), .dataB(b[13]), .cin(c[12]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[13]), .cout(c[13]) ) ;
  Bitslices alu15( .dataA(a[14]), .dataB(b[14]), .cin(c[13]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[14]), .cout(c[14]) ) ;
  Bitslices alu16( .dataA(a[15]), .dataB(b[15]), .cin(c[14]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[15]), .cout(c[15]) ) ;
  Bitslices alu17( .dataA(a[16]), .dataB(b[16]), .cin(c[15]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[16]), .cout(c[16]) ) ;
  Bitslices alu18( .dataA(a[17]), .dataB(b[17]), .cin(c[16]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[17]), .cout(c[17]) ) ;
  Bitslices alu19( .dataA(a[18]), .dataB(b[18]), .cin(c[17]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[18]), .cout(c[18]) ) ;
  Bitslices alu20( .dataA(a[19]), .dataB(b[19]), .cin(c[18]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[19]), .cout(c[19]) ) ;
  Bitslices alu21( .dataA(a[20]), .dataB(b[20]), .cin(c[19]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[20]), .cout(c[20]) ) ;
  Bitslices alu22( .dataA(a[21]), .dataB(b[21]), .cin(c[20]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[21]), .cout(c[21]) ) ;
  Bitslices alu23( .dataA(a[22]), .dataB(b[22]), .cin(c[21]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[22]), .cout(c[22]) ) ;
  Bitslices alu24( .dataA(a[23]), .dataB(b[23]), .cin(c[22]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[23]), .cout(c[23]) ) ;
  Bitslices alu25( .dataA(a[24]), .dataB(b[24]), .cin(c[23]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[24]), .cout(c[24]) ) ;
  Bitslices alu26( .dataA(a[25]), .dataB(b[25]), .cin(c[24]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[25]), .cout(c[25]) ) ;
  Bitslices alu27( .dataA(a[26]), .dataB(b[26]), .cin(c[25]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[26]), .cout(c[26]) ) ;
  Bitslices alu28( .dataA(a[27]), .dataB(b[27]), .cin(c[26]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[27]), .cout(c[27]) ) ;
  Bitslices alu29( .dataA(a[28]), .dataB(b[28]), .cin(c[27]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[28]), .cout(c[28]) ) ;
  Bitslices alu30( .dataA(a[29]), .dataB(b[29]), .cin(c[28]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[29]), .cout(c[29]) ) ;
  Bitslices alu31( .dataA(a[30]), .dataB(b[30]), .cin(c[29]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[30]), .cout(c[30]) ) ;
  Bitslices2 alu32( .dataA(a[31]), .dataB(b[31]), .cin(c[30]), .Signal(sel), .invertB(invertB), .less(1'b0), .dataOut(temp[31]), .set(set), .cout(cout)) ;
  
  ALU_Shifter shifter( .dataA(b), .dataB(shamt), .dataOut(sll_ans) );
  
  


endmodule