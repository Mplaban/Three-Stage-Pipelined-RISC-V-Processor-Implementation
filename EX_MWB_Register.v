`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2023 16:01:56
// Design Name: 
// Module Name: EX_MWB_Register
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


module EX_MWB_Register(clk,ex_stall,ALU_Out,EX_IR,EX_MWB_ALU_Out,EX_MWB_IR,EX_MWB_stall,LMD_addr

    );
    input clk;
    input ex_stall;
    input [31:0] ALU_Out;
    input [31:0] EX_IR;
    output reg [31:0] EX_MWB_ALU_Out;
    output reg [31:0] EX_MWB_IR;
    output reg [31:0] LMD_addr;
    output reg        EX_MWB_stall;
    
    always@(posedge clk)
    begin
    EX_MWB_ALU_Out<= ALU_Out;
    EX_MWB_IR <= EX_IR;
    EX_MWB_stall = ex_stall;
    end
    
    always@(*)begin
    LMD_addr = ALU_Out;
    end
    
endmodule
