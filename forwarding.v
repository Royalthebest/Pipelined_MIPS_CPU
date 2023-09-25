`timescale 1ns / 1ps
//Subject:     CO project 2 - MUX 221
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      109550104
//----------------------------------------------
//Date:        2010/8/17
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module forwarding(
               ID_EX_rs,
               ID_EX_rt,
               EX_MEM_rd,
               MEM_WB_rd,
               EX_MEM_regwrt,
               MEM_WB_regwrt,
               forward_a,
               forward_b
               );
		   
			
//I/O ports               
input   [5-1:0]     ID_EX_rs;          
input   [5-1:0]     EX_MEM_rd;
input   [5-1:0]     MEM_WB_rd; 
input   [5-1:0]     ID_EX_rt; 
input               EX_MEM_regwrt;
input               MEM_WB_regwrt;
output  reg [1:0]   forward_a; 
output  reg [1:0]   forward_b; 

//Internal Signals

//Main function
always @(*) begin
    forward_a <= 2'b00;
    forward_b <= 2'b00;
    if(EX_MEM_regwrt && (EX_MEM_rd!=0) && (EX_MEM_rd == ID_EX_rs))
        forward_a <= 2'b01;
    else if(MEM_WB_regwrt && (MEM_WB_rd!=0) && (MEM_WB_rd == ID_EX_rs))
        forward_a <= 2'b10;
    if(EX_MEM_regwrt && (EX_MEM_rd!=0) && (EX_MEM_rd == ID_EX_rt))
        forward_b <= 2'b01;
    else if(MEM_WB_regwrt && (MEM_WB_rd!=0) && (MEM_WB_rd == ID_EX_rt))
        forward_b <= 2'b10;
    
end

endmodule      
          
          