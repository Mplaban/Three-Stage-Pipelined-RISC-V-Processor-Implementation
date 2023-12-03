`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2023 16:00:51
// Design Name: 
// Module Name: MWB
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


module MWB(clk,EX_IR,B_reg,LMD_addr,EX_MWB_stall,EX_MWB_ALU_Out,EX_MWB_IR,writeflag,MWB_Out,dest_addr

    );
    
parameter Mem_size=128;                 
reg [31:0] Memory[0:Mem_size-1];

input clk;
input EX_MWB_stall;
input [31:0] EX_MWB_ALU_Out;
input [31:0] LMD_addr;
input [31:0] EX_MWB_IR;
input [31:0] EX_IR;

output reg writeflag;
output reg [31:0] MWB_Out;
output reg [31:0] dest_addr;
input [31:0] B_reg;
reg [31:0] LMD;

initial begin
Memory[0] = 12;
Memory[8]=22;
end

always@(posedge clk)
begin
case(EX_IR[6:2])              
        5'b01000:  Memory[LMD_addr>>2]<=B_reg;      // store
endcase
LMD<=(EX_IR[6:2]==5'b00000)?Memory[LMD_addr>>2]:LMD_addr;  


end

always@(EX_MWB_IR,EX_MWB_ALU_Out,LMD) begin
    writeflag<=1'b0;
    if(EX_MWB_stall!=1'b1) begin
    case(EX_MWB_IR[6:2])
            5'b01100,5'b00100: begin                    // Reg & Imm type
                               MWB_Out<=EX_MWB_ALU_Out;
                               dest_addr<=EX_MWB_IR[11:7];
                               writeflag<=1'b1;
                               end
            5'b00000         : begin                    // Load type
                               MWB_Out<=LMD;
                               dest_addr<=EX_MWB_IR[11:7];
                               writeflag<=1'b1;
                               end
            default         :  begin
                               writeflag<=1'b0;
                               dest_addr<=5'b0;
                               MWB_Out<=32'd0;
                               end
                               
    endcase
    end
    else begin
        writeflag<=1'b0;
        dest_addr<=5'b0;
        MWB_Out<=32'd0;
    end
    end


endmodule
