`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 16:57:04
// Design Name: 
// Module Name: IFD_EX_Register
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


module IFD_EX_Register(clk,stall,IFD_NPC,IFD_IR,IFD_RS1_Addr_In,IFD_RS2_Addr_In,IFD_EX_NPC,IFD_EX_IR,IFD_EX_RS1_Addr_In,IFD_EX_RS2_Addr_In,
ex_stall
    );
   
   input clk;
   input stall;
   input [31:0] IFD_NPC;
   input [31:0] IFD_IR;
   input [4:0]  IFD_RS1_Addr_In;
   input [4:0]  IFD_RS2_Addr_In;
   output reg [31:0] IFD_EX_NPC;
   output reg [31:0] IFD_EX_IR;
   output reg [4:0] IFD_EX_RS1_Addr_In;
   output reg [4:0] IFD_EX_RS2_Addr_In;
   output reg ex_stall;
   
   always@(*)
   begin
   IFD_EX_NPC <= IFD_NPC;
   IFD_EX_IR <=IFD_IR;
   IFD_EX_RS1_Addr_In <= IFD_RS1_Addr_In;
   IFD_EX_RS2_Addr_In <= IFD_RS2_Addr_In;
   ex_stall <= stall;
   end
   
   
endmodule
