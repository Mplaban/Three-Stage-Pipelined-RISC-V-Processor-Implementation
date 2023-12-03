`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2023 12:00:38
// Design Name: 
// Module Name: CLB
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


module CLB(
clk,
stall,
ex_stall,
EX_IR,
IFD_IR,
ALU_Out,
EX_dest_reg,
IFD_RS1_Addr_In,
IFD_RS2_Addr_In,
Bypass_Flag,
RS1_Out,
RS2_Out
    );
    
    input [31:0] EX_IR;
    input clk;
    input [31:0] IFD_IR;
    input [31:0] ALU_Out;
    input [4:0] EX_dest_reg; 
    input [4:0] IFD_RS1_Addr_In;
    input [4:0] IFD_RS2_Addr_In; 
    
    output reg stall;
    output reg ex_stall;
    output reg [1:0] Bypass_Flag;
    output reg [31:0] RS1_Out;
    output reg [31:0] RS2_Out;
    
//    output  reg condn_flag;
//    output reg ex_condn_flag;
    
    initial begin
    stall =0;
    ex_stall =0;
//    condn_flag =0;
//    ex_condn_flag=0;
    end
    
    always@(posedge clk)
    begin
            stall = 0;
	        RS1_Out = 0;
	        Bypass_Flag = 0;
	        RS2_Out = 0;
	        
	if(EX_IR[6:2] == 5'b00000)  begin
	end
	else begin        
    if(EX_dest_reg == IFD_RS1_Addr_In)
        begin
            RS1_Out = ALU_Out;
            Bypass_Flag[0] = 1'b1;
        end
         if(EX_dest_reg == IFD_RS2_Addr_In)
        begin
            RS2_Out = ALU_Out;
            Bypass_Flag[1] = 1'b1;
        end
	        end
    
    end
endmodule
