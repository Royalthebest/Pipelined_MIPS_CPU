`timescale 1ns / 1ps
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      109550104
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	memread_o,
	memtoreg_o,
	memwrt_o,
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         	RegWrite_o;
output [4-1:0] 	ALU_op_o;
output         	ALUSrc_o;
output          RegDst_o;
output          Branch_o;
output			memread_o;
output			memtoreg_o;
output			memwrt_o;

//Internal Signals
reg    [4-1:0]  ALU_op_o;
reg             ALUSrc_o;
reg             RegWrite_o;
reg             RegDst_o;
reg             Branch_o;
reg 			memread_o;
reg 			memtoreg_o;
reg 			memwrt_o;
	
//Parameter
wire rtype;
wire addi;
wire slti; 
wire beq;
wire sw;
wire lw;
wire bne;
wire bge;
wire bgt;

//Main function
assign rtype = (instr_op_i==0) ? 1 : 0;
assign addi = (instr_op_i==8) ? 1 : 0;
assign slti = (instr_op_i==10) ? 1 : 0;
assign beq = (instr_op_i==4) ? 1 : 0;
assign sw = (instr_op_i==43) ? 1 : 0;
assign lw = (instr_op_i==35) ? 1 : 0;
assign bne = (instr_op_i==5) ? 1 : 0;
assign bge = (instr_op_i==1) ? 1 : 0;
assign bgt = (instr_op_i==7) ? 1 : 0;
// R (op=0)
// addi (op=1)
// slti (op=2)
// beq (op=3)
// sw (op=4)
// lw (op=5)
// bne (op=6)
// bge(op=7)
// bgt(op=8)
always @(*) begin
	RegDst_o <= rtype;
	Branch_o <= beq | bne | bge | bgt;
	memread_o <= lw;
	memtoreg_o <= lw;
	memwrt_o <= sw;
	ALUSrc_o <= addi | slti | sw | lw;
	RegWrite_o <= rtype | addi | slti | lw;
	ALU_op_o[3] <= bgt;
	ALU_op_o[2] <= sw | lw | bne | bge;
	ALU_op_o[1] <= slti | beq | bne | bge;
	ALU_op_o[0] <= addi | beq | lw | bge;
end
endmodule





                    
                    