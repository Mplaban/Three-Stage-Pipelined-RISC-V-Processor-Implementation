`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 21:14:07
// Design Name: 
// Module Name: EX
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


module EX(clk,ex_stall,Bypass_Flag,RS1_Out,RS2_Out,writeflag,dest_addr,MWB_Out,IFD_EX_RS1_Addr_In,IFD_EX_RS2_Addr_In,IFD_EX_IR,IFD_EX_NPC,EX_IR,EX_NPC,ALU_Out,condn_flag,B_reg,EX_dest_reg,adder

    );
    
    input ex_stall;
    input clk;
//    input condn_flag;
    input writeflag;
    input [1:0] Bypass_Flag;
    input [31:0] IFD_EX_NPC;
    input [31:0] IFD_EX_IR;
    input [31:0] dest_addr;
    input [31:0] MWB_Out;
    input [31:0] RS1_Out;
    input [31:0] RS2_Out;
    input [4:0] IFD_EX_RS1_Addr_In;
    input [4:0] IFD_EX_RS2_Addr_In;
    
    output reg condn_flag;
    output reg [31:0] EX_IR;
    output reg [31:0] EX_NPC;
    output reg [31:0] ALU_Out;
    output reg [31:0] adder;
    output reg [4:0] EX_dest_reg;
    
    reg signed [31:0] A_reg; 
    output reg signed [31:0] B_reg;
    reg signed [31:0] Register[0 : 31];
    reg signed [31:0] Imm; 
    wire [31:0] A,B;
    
    initial begin
    Register[0] = 0;
    Register[1] = 0;
    Register[2] = 6;
    Register[7] = 5;
    Register[4] = 100;
    Register[8] = 56;
    Register[9] = 24;
    Register[14] = 77;
    Register[18] = 18;
    Register[17] = 18;
    end
    
    
    always@(posedge clk) begin
    if(ex_stall!=1'b1) begin
    case(IFD_EX_IR[6:2])
    5'b01100,5'b01000,5'b11000: begin //Register Type, Store, Branch
                A_reg<=Register[IFD_EX_RS1_Addr_In];
//                A_reg<=0;
                B_reg<=Register[IFD_EX_RS2_Addr_In];
              end
    5'b00000,5'b00100: begin //Load, Immediate
                A_reg<=Register[IFD_EX_RS1_Addr_In]; 
                              
              end
    endcase
    end
    end
    
    // loading Imm value from instruction register
    always@(posedge clk) begin
        if(ex_stall !=1'b1) begin
        if(condn_flag==1'b1) begin
        EX_IR<=32'b11111111111111111111111111111111;
        end
        else begin
        case(IFD_EX_IR[6:2])
        5'b00100,5'b00000,5'b00010:              // Imm-type & load & loadNoc
                  Imm<={{20{IFD_EX_IR[31]}},IFD_EX_IR[31:20]};
                 
        5'b01000:                         // store
                  Imm<={{20{IFD_EX_IR[31]}},{IFD_EX_IR[31:25],IFD_EX_IR[11:7]}};
        5'b11000:
                  Imm<={{20{IFD_EX_IR[31]}},{IFD_EX_IR[31]},{IFD_EX_IR[7]},{IFD_EX_IR[30:25]},{IFD_EX_IR[11:8]},1'b0};  
        default:  Imm<=32'b0;
        endcase
        EX_IR<=IFD_EX_IR;
        EX_NPC<=IFD_EX_NPC;
        end
        end
    //    else begin
    //    IF_ID_IR<=IF_ID_IR;
    //    IF_ID_NPC<=IF_ID_NPC;
    //    end
        
    end 
    
    
    assign A = (Bypass_Flag[0]==1'b1)?RS1_Out:A_reg;
    assign B = (Bypass_Flag[1]==1'b1)?RS2_Out:B_reg;
    
    always@(*) begin
    
    case(EX_IR[6:2])
            5'b01100: begin                 // register type
                      condn_flag=1'b0;
                      case(EX_IR[14:12])
                                    3'b111: ALU_Out = A & B;
                                    3'b110: ALU_Out = A | B;
                                    3'b001: ALU_Out = A<< B;
                                    3'b101: ALU_Out = A >>> B;
                                    3'b010: ALU_Out = (A< B)? 1'b1 : 1'b0;
                                    3'b000: begin
                                            if(EX_IR[30])
                                                ALU_Out= A - B;
                                            else
                                                ALU_Out= A + B;
                                            end
                                    default: ALU_Out = 32'd0;
                      endcase
                      
                      end
            5'b00000: begin               // load type 
                      condn_flag=1'b0;
                      case(EX_IR[14:12])
                                    3'b000: ALU_Out = A_reg + Imm;
                                    3'b010: ALU_Out = A_reg + Imm;
                                    default: ALU_Out = 32'd0;
                      endcase
                      end
                      
             5'b00100:begin //Imm_type
                      condn_flag=1'b0;
                      case(EX_IR[14:12])
                                    3'b000: ALU_Out = A_reg + Imm;
                                    3'b010: ALU_Out = (A_reg < Imm) ? 1'b1 : 1'b0;
                                    default: ALU_Out = 32'd0;
                      endcase
                      end
                      
            5'b01000: begin             // store_type
                      condn_flag=1'b0;
                      case(EX_IR[14:12])
                                    3'b010:ALU_Out = A_reg + Imm;
                                    default: ALU_Out = 32'd0;
                      endcase
                      end
                      
            5'b11000: begin             //Branch
                      case(EX_IR[14:12])
                                    3'b000:adder = IFD_EX_NPC-4 + Imm;
                                    default: adder = 32'd0;
                      endcase
                      condn_flag=(A_reg==B_reg)?1'b1:1'b0;
//                      x_condn_flag=1;
                      end
          default: begin 
                     condn_flag=1'b0;
                     ALU_Out=32'd0;
                     end
    endcase
    EX_dest_reg <= EX_IR[11:7];  
    end
 
    // writing in to the register
always@(posedge clk) begin
    if( writeflag==1'b1) begin
        if(dest_addr==5'b00000) begin
            Register[dest_addr]<=32'd0;   
        end
        else begin
            Register[dest_addr]<=MWB_Out; 
            end 
    end
    
end
endmodule
