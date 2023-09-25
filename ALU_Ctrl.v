`timescale 1ns / 1ps
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      109550104
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Control(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [4-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*) begin
    case (ALUOp_i)
        1: ALUCtrl_o <= 2;
        2: ALUCtrl_o <= 7;
        3: ALUCtrl_o <= 13;
        4: ALUCtrl_o <= 2;
        5: ALUCtrl_o <= 2;
        6: ALUCtrl_o <= 9;
        7: ALUCtrl_o <= 10;
        8: ALUCtrl_o <= 11;
        0: begin
            case (funct_i)
                32: ALUCtrl_o <= 2;
                34: ALUCtrl_o <= 6;
                36: ALUCtrl_o <= 0;
                37: ALUCtrl_o <= 1;
                42: ALUCtrl_o <= 7;
                24: ALUCtrl_o <= 8;
            endcase
        end
        default: ALUCtrl_o <= 0;
    endcase
end
endmodule     





                    
                    