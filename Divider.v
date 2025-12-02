module Divider( div_clk, dataA, dataB, Funct, dataOut, rst, HiLo_signal, alu_out_sel);
input div_clk;
input rst;
input [31:0] dataA;
input [31:0] dataB;
input [5:0] Funct;
output reg HiLo_signal,alu_out_sel = 0; 
output reg [63:0] dataOut = 0;

parameter DIVU = 6'b011011;
parameter MFHI = 6'b010000;
parameter MFLO = 6'b010010;

reg [63:0] REM = 64'b0;  // dataA : 32'b0
reg [31:0] DIVR;  // dataB
reg [31:0] count = 1;

always@( posedge div_clk or rst )
begin
        if ( rst )
        begin
            REM = 64'b0;
	    count = 1;
        end
        else
        begin
	alu_out_sel = 0;
		case ( Funct )
  		DIVU:
		begin	
			if ( dataB != 0 )
			begin
			
				if ( count == 1 && count != 0 )
				begin
					REM[31:0] = dataA;
					DIVR = dataB;
					REM = REM << 1;
				
					
					REM[63:32] = REM[63:32] - DIVR;
			
					if ( REM[63] == 1'b0 ) // REM >= 0
					begin
						REM = REM << 1;
						REM[0] = 1;  // LSB = 1
					end
					else  // REM < 0
					begin
						REM[63:32] = REM[63:32] + DIVR;
						REM = REM << 1;
						REM[0] = 0;  // LSB = 0
					end			
					//$display( "count: %d: \n", count ) ;
					count = count + 1;
				
				end

				if(count < 33 && count != 0)
				begin
					REM[63:32] = REM[63:32] - DIVR;
			
					if ( REM[63] == 1'b0 ) // REM >= 0
					begin
						REM = REM << 1;
						REM[0] = 1;  // LSB = 1
					end
					else  // REM < 0
					begin
						REM[63:32] = REM[63:32] + DIVR;
						REM = REM << 1;
						REM[0] = 0;  // LSB = 0
					end
				
					//$display( "count: %d: \n", count ) ;
					count = count + 1;
			
				end
			
				if(count == 33)
				begin
					//$display( "count_reset: %d: \n", count ) ;
					count = 0 ;
				end
			
			end
			
			else
			begin
				REM = 0 ;
			end
		
		end
		
  		MFHI:
		begin
			REM[63:32] = REM[63:32] >> 1 ;
			dataOut = REM ;
			HiLo_signal = 0;
			alu_out_sel = 1;
		end
		MFLO:
		begin
			REM[63:32] = REM[63:32] >> 1 ;
			dataOut = REM ;
			HiLo_signal = 1;
			alu_out_sel = 1;
		end
		default: dataOut = dataOut;
		endcase
        end
end
endmodule