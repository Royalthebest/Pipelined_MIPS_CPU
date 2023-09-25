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
     
module hazard(
               ID_EX_memread,
               ID_EX_rt,
               IF_ID_rs,
               IF_ID_rt,
               ID_flush,
               IF_flush,
               EX_flush,
               IF_ID_stall,
               PC_stall,
               Branch
               );
		   
			
//I/O ports               
input   [5-1:0]     ID_EX_rt;          
input   [5-1:0]     IF_ID_rs;
input   [5-1:0]     IF_ID_rt; 
input               Branch;
input               ID_EX_memread;
output  reg         ID_flush; 
output  reg         IF_flush; 
output  reg         EX_flush; 
output  reg         IF_ID_stall;
output  reg         PC_stall; 


//Internal Signals

//Main function
always @(*) begin
    IF_ID_stall <= 0;
    ID_flush <= 0;
    IF_flush <= 0;
    EX_flush <= 0;
    PC_stall <= 0;
    if(Branch)
    begin
        ID_flush <= 1;
        EX_flush <= 1;
        IF_flush <= 1;
    end
    else if(ID_EX_memread && ((ID_EX_rt==IF_ID_rs) || (ID_EX_rt==IF_ID_rt)))
    begin
        ID_flush <= 1;
        IF_ID_stall <= 1;
        PC_stall <= 1;
    end
end

endmodule      
          
          