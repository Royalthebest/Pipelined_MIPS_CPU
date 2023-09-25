`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      109550104
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
wire            PC_Stall;

/**** IF stage ****/
wire    [31:0]  IF_MUX0;
wire    [31:0]  IF_PC;
wire    [31:0]  IF_ins_t;
wire    [31:0]  IF_PC4_t;
wire    [31:0]  IF_ins;
wire    [31:0]  IF_PC4;
wire            reg_stall;
/**** ID stage ****/
wire    [31:0]  ID_PC4;
wire    [31:0]  ID_ins;
wire    [31:0]  ID_RF1;
wire    [31:0]  ID_RF2;
wire    [31:0]  ID_SE;
//control signal
wire            ID_RegWrite;
wire    [3:0]   ID_ALU_op;
wire            ID_ALUSrc;
wire            ID_RegDst;
wire            ID_Branch;
wire            ID_memread;
wire            ID_memtoreg;
wire            ID_memwrt;

wire            ID_RegWrite_t;
wire    [3:0]   ID_ALU_op_t;
wire            ID_ALUSrc_t;
wire            ID_RegDst_t;
wire            ID_Branch_t;
wire            ID_memread_t;
wire            ID_memtoreg_t;
wire            ID_memwrt_t;

wire    [1:0]   FA;
wire    [1:0]   FB;
wire            ID_Flush;
wire            IF_Flush;
wire            EX_Flush;

/**** EX stage ****/
wire    [31:0]  EX_PC4;
wire    [31:0]  EX_SL2;
wire    [31:0]  EX_RF1;
wire    [31:0]  EX_RF2;
wire    [31:0]  EX_SE;
wire    [4:0]   EX_ins1;
wire    [4:0]   EX_ins2;
wire    [31:0]  EX_MUX1;
wire    [4:0]   EX_MUX2;
wire    [3:0]   EX_ALU_ctrl;
wire    [31:0]  EX_Adder;
wire    [31:0]  EX_ALU_result;
wire            EX_Zero;
wire    [4:0]   EX_forward;
wire    [31:0]  ALU_src1;
wire    [31:0]  ALU_src2;

//control signal
wire            EX_RegWrite;
wire    [3:0]   EX_ALU_op;
wire            EX_ALUSrc;
wire            EX_RegDst;
wire            EX_Branch;
wire            EX_memread;
wire            EX_memtoreg;
wire            EX_memwrt;

wire            EX_RegWrite_t;
wire            EX_Branch_t;
wire            EX_memread_t;
wire            EX_memtoreg_t;
wire            EX_memwrt_t;

/**** MEM stage ****/
wire    [31:0]  MEM_PC4;
wire            MEM_Zero;
wire    [31:0]  MEM_ALU_result;
wire            MEM_PCSrc;
wire    [31:0]  MEM_RF2;
wire    [31:0]  MEM_Read_data;
wire    [4:0]   MEM_wrtreg;
//control signal
wire            MEM_Branch;
wire            MEM_memread;
wire            MEM_memwrt;
wire            MEM_RegWrite;
wire            MEM_memtoreg;

/**** WB stage ****/
wire    [31:0]  WB_Read_data;
wire    [31:0]  WB_ALU_result;
wire    [31:0]  WB_MUX3;
wire    [4:0]   WB_wrtreg;
//control signal
wire            WB_RegWrite;
wire            WB_memtoreg;

/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
        .data0_i(IF_PC4),
        .data1_i(MEM_PC4),
        .select_i(MEM_PCSrc),
        .data_o(IF_MUX0)
);

ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
            .stall(PC_Stall),
	    .pc_in_i(IF_MUX0),   
	    .pc_out_o(IF_PC) 
);

Instruction_Memory IM(
        .addr_i(IF_PC),  
	    .instr_o(IF_ins_t)  
);
			
Adder Add_pc(
        .src1_i(IF_PC),     
	    .src2_i(32'h0004),     
	    .sum_o(IF_PC4_t)   
);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
        .clk_i(clk_i),      
	    .rst_i (rst_i), 
            .stall(reg_stall),    
	    .data_i({IF_PC4,IF_ins}),   
	    .data_o({ID_PC4,ID_ins}) 
);

forwarding FWD(
        .ID_EX_rs(EX_forward),
        .ID_EX_rt(EX_ins1),
        .EX_MEM_rd(MEM_wrtreg),
        .MEM_WB_rd(WB_wrtreg),
        .EX_MEM_regwrt(MEM_RegWrite),
        .MEM_WB_regwrt(WB_RegWrite),
        .forward_a(FA),
        .forward_b(FB)
);

hazard HZ(
        .ID_EX_rt(EX_ins1),
        .IF_ID_rs(ID_ins[25:21]),
        .IF_ID_rt(ID_ins[20:16]),
        .Branch(MEM_PCSrc),
        .ID_EX_memread(EX_memread),
        .IF_ID_stall(reg_stall),
        .PC_stall(PC_Stall),
        .ID_flush(ID_Flush),
        .IF_flush(IF_Flush),
        .EX_flush(EX_Flush)
);
MUX_3to1 MA(
        .data0_i(EX_RF1),
        .data1_i(MEM_ALU_result),
        .data2_i(WB_MUX3),
        .select_i(FA),
        .data_o(ALU_src1)
);

MUX_3to1 MB(
        .data0_i(EX_RF2),
        .data1_i(MEM_ALU_result),
        .data2_i(WB_MUX3),
        .select_i(FB),
        .data_o(ALU_src2)
);
//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(ID_ins[25:21]) ,  
        .RTaddr_i(ID_ins[20:16]) ,  
        .RDaddr_i(WB_wrtreg) ,  
        .RDdata_i(WB_MUX3)  , 
        .RegWrite_i (WB_RegWrite),
        .RSdata_o(ID_RF1) ,  
        .RTdata_o(ID_RF2)   
);

Decoder Control(
        .instr_op_i(ID_ins[31:26]), 
	    .RegWrite_o(ID_RegWrite_t), 
	    .ALU_op_o(ID_ALU_op_t),   
	    .ALUSrc_o(ID_ALUSrc_t),   
	    .RegDst_o(ID_RegDst_t),   
	    .Branch_o(ID_Branch_t),
        .memread_o(ID_memread_t),
        .memtoreg_o(ID_memtoreg_t),
        .memwrt_o(ID_memwrt_t)
);

MUX_2to1 #(.size(11)) IDflush(
        .data0_i({ID_RegWrite_t,ID_ALU_op_t,ID_ALUSrc_t,ID_RegDst_t,ID_Branch_t,ID_memread_t,ID_memtoreg_t,ID_memwrt_t}),
        .data1_i(0),
        .select_i(ID_Flush),
        .data_o({ID_RegWrite,ID_ALU_op,ID_ALUSrc,ID_RegDst,ID_Branch,ID_memread,ID_memtoreg,ID_memwrt})
);

MUX_2to1 #(.size(64)) IFflush(
        .data0_i({IF_PC4_t,IF_ins_t}),
        .data1_i(0),
        .select_i(IF_Flush),
        .data_o({IF_PC4,IF_ins})
);

MUX_2to1 #(.size(5)) EXflush(
        .data0_i({EX_RegWrite_t,EX_memtoreg_t,EX_Branch_t,EX_memread_t,EX_memwrt_t}),
        .data1_i(0),
        .select_i(EX_Flush),
        .data_o({EX_RegWrite,EX_memtoreg,EX_Branch,EX_memread,EX_memwrt})
);

Sign_Extend Sign_Extend(
        .data_i(ID_ins[15:0]),
        .data_o(ID_SE)
);	

Pipe_Reg #(.size(154)) ID_EX(
        .clk_i(clk_i),      
	    .rst_i (rst_i),   
            .stall(0),  
	    .data_i({ID_ins[25:21],ID_RegWrite,ID_memtoreg,ID_Branch,ID_memread,ID_memwrt,ID_RegDst,ID_ALU_op,ID_ALUSrc,ID_PC4,ID_RF1,ID_RF2,ID_SE,ID_ins[20:16],ID_ins[15:11]}),   
	    .data_o({EX_forward,EX_RegWrite_t,EX_memtoreg_t,EX_Branch_t,EX_memread_t,EX_memwrt_t,EX_RegDst,EX_ALU_op,EX_ALUSrc,EX_PC4,EX_RF1,EX_RF2,EX_SE,EX_ins1,EX_ins2}) 
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
        .data_i(EX_SE),
        .data_o(EX_SL2)
);

ALU ALU(
        .src1_i(ALU_src1),
	    .src2_i(EX_MUX1),
	    .ctrl_i(EX_ALU_ctrl),
	    .result_o(EX_ALU_result),
		.zero_o(EX_Zero)
);
		
ALU_Control ALU_Control(
        .funct_i(EX_SE[5:0]),   
        .ALUOp_i(EX_ALU_op),   
        .ALUCtrl_o(EX_ALU_ctrl) 
);

MUX_2to1 #(.size(32)) Mux1(
        .data0_i(ALU_src2),
        .data1_i(EX_SE),
        .select_i(EX_ALUSrc),
        .data_o(EX_MUX1)
);
		
MUX_2to1 #(.size(5)) Mux2(
        .data0_i(EX_ins1),
        .data1_i(EX_ins2),
        .select_i(EX_RegDst),
        .data_o(EX_MUX2)
);

Adder Add_pc_branch(
        .src1_i(EX_PC4),     
	    .src2_i(EX_SL2),     
	    .sum_o(EX_Adder)   
);

Pipe_Reg #(.size(107)) EX_MEM(
        .clk_i(clk_i),      
	    .rst_i (rst_i),   
            .stall(0),  
	    .data_i({EX_RegWrite,EX_memtoreg,EX_Branch,EX_memread,EX_memwrt,EX_Adder,EX_Zero,EX_ALU_result,ALU_src2,EX_MUX2}),   
	    .data_o({MEM_RegWrite,MEM_memtoreg,MEM_Branch,MEM_memread,MEM_memwrt,MEM_PC4,MEM_Zero,MEM_ALU_result,MEM_RF2,MEM_wrtreg}) 
);


//Instantiate the components in MEM stage
Data_Memory DM(
        .clk_i(clk_i),
	    .addr_i(MEM_ALU_result),
	    .data_i(MEM_RF2),
	    .MemRead_i(MEM_memread),
	    .MemWrite_i(MEM_memwrt),
	    .data_o(MEM_Read_data)
);

and(MEM_PCSrc, MEM_Branch, MEM_Zero);

Pipe_Reg #(.size(71)) MEM_WB(
        .clk_i(clk_i),      
	    .rst_i (rst_i),  
            .stall(0),   
	    .data_i({MEM_RegWrite,MEM_memtoreg,MEM_Read_data,MEM_ALU_result,MEM_wrtreg}),   
	    .data_o({WB_RegWrite,WB_memtoreg,WB_Read_data,WB_ALU_result,WB_wrtreg}) 
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
        .data0_i(WB_ALU_result),
        .data1_i(WB_Read_data),
        .select_i(WB_memtoreg),
        .data_o(WB_MUX3)
);

/****************************************
signal assignment
****************************************/

endmodule

