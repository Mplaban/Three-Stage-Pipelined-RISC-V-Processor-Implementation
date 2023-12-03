`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 17:22:45
// Design Name: 
// Module Name: Riscv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Riscv;
reg sysclock;

wire stall;
wire ex_stall;
wire condn_flag;
wire ex_condn_flag;
wire [1:0] Bypass_Flag;
wire [31:0] ALU_Out;
wire [31:0] IFD_NPC;               
wire [31:0] IFD_IR;                
wire [4:0]  IFD_RS1_Addr_In;       
wire [4:0]  IFD_RS2_Addr_In;       
wire [31:0]  RS1_Out;       
wire [31:0]  RS2_Out;       
wire [4:0]  EX_dest_reg;       
wire [31:0] IFD_EX_NPC;       
wire [31:0] IFD_EX_IR;        
wire [31:0] EX_IR;        
wire [31:0] EX_NPC;        
wire [4:0] IFD_EX_RS1_Addr_In;
wire [4:0] IFD_EX_RS2_Addr_In;
wire [31:0] EX_MWB_ALU_Out;
wire [31:0] MWB_Out;
wire [31:0] EX_MWB_IR;
wire [31:0] B_reg;
wire EX_MWB_stall;
wire writeflag;
wire [31:0] dest_addr;
wire [31:0] LMD_addr;
wire [31:0] adder;



IF_ID if_id(.clk(sysclock),.stall(stall),.adder(adder),.condn_flag(condn_flag),.IFD_RS1_Addr_In(IFD_RS1_Addr_In),.IFD_RS2_Addr_In(IFD_RS2_Addr_In),.IFD_NPC(IFD_NPC),.IFD_IR(IFD_IR));
IFD_EX_Register ifd_ex(.clk(sysclock),.IFD_NPC(IFD_NPC),.IFD_IR(IFD_IR),.IFD_RS1_Addr_In(IFD_RS1_Addr_In),.IFD_RS2_Addr_In(IFD_RS2_Addr_In),.IFD_EX_NPC(IFD_EX_NPC),.IFD_EX_IR(IFD_EX_IR),.IFD_EX_RS1_Addr_In(IFD_EX_RS1_Addr_In),.IFD_EX_RS2_Addr_In(IFD_EX_RS2_Addr_In));
EX  ex(.clk(sysclock),.ex_stall(ex_stall),.Bypass_Flag(Bypass_Flag),.RS1_Out(RS1_Out),.RS2_Out(RS2_Out),.writeflag(writeflag),.dest_addr(dest_addr),.MWB_Out(MWB_Out),.IFD_EX_RS1_Addr_In(IFD_EX_RS1_Addr_In),.IFD_EX_RS2_Addr_In(IFD_EX_RS2_Addr_In),.IFD_EX_IR(IFD_EX_IR),.IFD_EX_NPC(IFD_EX_NPC),.EX_IR(EX_IR),.EX_NPC(EX_NPC),.ALU_Out(ALU_Out),.condn_flag(condn_flag),.B_reg(B_reg),.EX_dest_reg(EX_dest_reg),.adder(adder));
EX_MWB_Register ex_mwb(.clk(sysclock),.ex_stall(ex_stall),.ALU_Out(ALU_Out),.EX_IR(EX_IR),.EX_MWB_ALU_Out(EX_MWB_ALU_Out),.EX_MWB_IR(EX_MWB_IR),.EX_MWB_stall(EX_MWB_stall),.LMD_addr(LMD_addr));
MWB mwb(.clk(sysclock),.EX_IR(EX_IR),.B_reg(B_reg),.LMD_addr(LMD_addr),.EX_MWB_stall(EX_MWB_stall),.EX_MWB_ALU_Out(EX_MWB_ALU_Out),.EX_MWB_IR(EX_MWB_IR),.writeflag(writeflag),.MWB_Out(MWB_Out),.dest_addr(dest_addr));
CLB clb(.clk(sysclock),.stall(stall),.ex_stall(ex_stall),.EX_IR(EX_IR),.IFD_IR(IFD_IR),.ALU_Out(ALU_Out),.EX_dest_reg(EX_dest_reg),.IFD_RS1_Addr_In(IFD_RS1_Addr_In),.IFD_RS2_Addr_In(IFD_RS2_Addr_In),.Bypass_Flag(Bypass_Flag),.RS1_Out(RS1_Out),.RS2_Out(RS2_Out));


initial
sysclock = 0;
always
begin
# 20 sysclock = ~sysclock;
if ($time >= 800) $finish;
end




endmodule
