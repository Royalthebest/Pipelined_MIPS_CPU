`timescale 1ns / 1ps
//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      109550104
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg              zero_o;

//Parameter

//Main function
always @(src1_i, src2_i, ctrl_i) begin
	zero_o <= 0;
	case (ctrl_i)
		0: result_o <= src1_i & src2_i;
		1: result_o <= src1_i | src2_i;
		2: result_o <= src1_i + src2_i;
		6: result_o <= src1_i - src2_i;
		7: result_o <= src1_i < src2_i ? 1 : 0;
		8: result_o <= src1_i * src2_i;
		9: begin
			result_o <= src1_i - src2_i;
			zero_o <= src1_i != src2_i;
		end
		10: begin
			result_o <= src1_i - src2_i;
			zero_o <= src1_i >= src2_i;
		end
		11: begin
			result_o <= src1_i - src2_i;
			zero_o <= src1_i > src2_i;
		end
		12: result_o <= ~ (src1_i | src2_i);
		13: begin
			result_o <= src1_i - src2_i;
			zero_o <= src1_i == src2_i;
		end
		default:  begin
				result_o <= 0;
				zero_o <= 0;
			end
	endcase
end

endmodule





                    
                    