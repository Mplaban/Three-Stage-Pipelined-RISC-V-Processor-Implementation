`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 11:21:50
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(clk,stall,adder,condn_flag,IFD_RS1_Addr_In,IFD_RS2_Addr_In,IFD_NPC,IFD_IR
   );
   
   input clk;
   input stall;
   input [31:0] adder;
   input condn_flag;
   output reg [4:0] IFD_RS1_Addr_In;
   output reg [4:0] IFD_RS2_Addr_In;
   parameter Instr_Mem_Size=16;
   reg [31:0] IFD_PC;
   output reg [31:0] IFD_NPC,IFD_IR;
   reg [31:0] instr_Mem[0:Instr_Mem_Size-1];    // Instruction Memory
   
   initial begin 
   IFD_PC=0;
   IFD_NPC=0;
   instr_Mem[0] = 32 'b0000000_00111_00010_000_00001_0110011; //add x1,x2,x7
   instr_Mem[1] = 32 'b0000000_00001_00010_000_00011_0110011; //add x3,x2,x1
   instr_Mem[2] = 32 'b1111110_01110_00100_000_01111_0010011; //addi x15,x4,#-50
   instr_Mem[3] = 32 'b0000000_01000_01001_010_01110_0000011; //lw x14,8(x9)
   instr_Mem[4] = 32 'b0000000_01110_01000_010_01000_0100011; //sw x14,8(x8)
   instr_Mem[5] = 32 'b0000000_10010_10001_000_01100_1100011; //beq x17,x18,#2
   instr_Mem[6] = 32 'b0000000_00010_01101_010_01101_0010011; //slti x13,x13,#2
   instr_Mem[9] = 32 'b0000000_00010_00001_010_10100_0110011; //slt x20,x1,x2
   
   end
   
always@(posedge clk) begin
    if(stall!=1'b1) begin
    
        if(condn_flag==1) begin     // if zero_flag is detected, branch will be taken
            IFD_PC = adder;
            IFD_IR = instr_Mem[IFD_PC>>2]; 
    
        end
        else begin
            IFD_PC = IFD_NPC;      // else next instruction should be fetched
            IFD_IR = instr_Mem[IFD_PC>>2]; 
            end
        case(IFD_IR[6:2])
    5'b01100,5'b01000,5'b11000: begin //Register Type, Store, Branch
                IFD_RS1_Addr_In<=IFD_IR[19:15];
                IFD_RS2_Addr_In<=IFD_IR[24:20];
              end
    5'b00000,5'b00100: begin //Load, Immediate
                IFD_RS1_Addr_In<=IFD_IR[19:15];
                IFD_RS2_Addr_In<=5'b0;
                
              end
            endcase
    
    IFD_NPC=IFD_PC+4;
    end       
else begin
    IFD_PC <= IFD_PC;
    IFD_NPC <= IFD_NPC; 
end

end

   
endmodule
