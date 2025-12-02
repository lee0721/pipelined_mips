module Bitslices( dataA, dataB, cin, Signal, invertB, less, dataOut, cout );

	input dataA, dataB, cin, invertB, less ;
	input [1:0] Signal ;
	output dataOut, cout;
	
	wire ans_and, ans_or, ans_add, ans_sub, b_temp ;
	
	and ( ans_and, dataA, dataB ) ;
	or ( ans_or, dataA, dataB ) ;
	xor ( b_temp, dataB, invertB ) ;
	FA fa (.a(dataA), .b(b_temp), .cin(cin), .cout(cout), .sum(ans_add)) ;
	assign ans_sub = less ;
	
	assign dataOut = ( Signal == 2'b00 ) ? ans_and :
		             ( Signal == 2'b01 ) ? ans_or :
		             ( Signal == 2'b10 ) ? ans_add :
		             ( Signal == 2'b11 ) ? ans_sub :
				                               1'b0 ;
	
endmodule