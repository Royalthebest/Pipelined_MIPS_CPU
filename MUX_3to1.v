`timescale 1ns / 1ps
//Subject:     CO project 2 - MUX 321
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      109550104
//----------------------------------------------
//Date:        2010/8/17
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module MUX_3to1(
    input       [32-1:0] data0_i,
    input       [32-1:0] data1_i,
    input       [32-1:0] data2_i,
    input       [ 2-1:0] select_i,
    output  reg [32-1:0] data_o
);
/* Write your code HERE */

always@(*)
begin
    if(select_i == 2'b00)
        data_o <= data0_i;
    else if(select_i == 2'b01)
        data_o <= data1_i;
    else if(select_i == 2'b10)
        data_o <= data2_i;
end

endmodule

