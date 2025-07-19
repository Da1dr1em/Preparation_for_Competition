//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-3.6.20250620
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2025/07/19 15:25:56
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/19 15:25:56
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              RoundKeyGen.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\RoundKeyGen.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//本模块是按轮对寄存器中储存的密钥进行一次迭代的模块，输入为128位的密钥和本轮的轮数，输出位128位的下轮密钥
module RoundKeyGen(
    input [1:128] keyin,
    input [3:0] round, //轮数为1到10，输入1则生成W[4]~W[7]
    output [1:128] nextkey               
);
//首先要把输入的密钥拆分为W0,W1,W2,W3
wire [1:32] W[0:3];
wire [1:32] Wnext[0:3];
//定义一个轮常量Rcon
reg [1:32] Rcon;
assign W[0] = keyin[1:32];
assign W[1] = keyin[33:64];
assign W[2] = keyin[65:96];
assign W[3] = keyin[97:128];

//轮常量的值
always @(round) begin
    case(round) 
            4'b0001:Rcon = 32'h01000000;
            4'b0010:Rcon = 32'h02000000;
            4'b0011:Rcon = 32'h04000000;
            4'b0100:Rcon = 32'h08000000;
            4'b0101:Rcon = 32'h10000000;
            4'b0110:Rcon = 32'h20000000;
            4'b0111:Rcon = 32'h40000000;
            4'b1000:Rcon = 32'h80000000;
            4'b1001:Rcon = 32'h1b000000;
            4'b1010:Rcon = 32'h36000000;
        default: ; 
    endcase
end

wire [1:32] keyshift,keySout;
assign keyshift = {W[3][9:32],W[3][1:8]};                                                                   
Sbox Sb1(keyshift[1:8],keySout[1:8]);
Sbox Sb2(keyshift[9:16],keySout[9:16]);
Sbox Sb3(keyshift[17:24],keySout[17:24]);
Sbox Sb4(keyshift[25:32],keySout[25:32]);
assign Wnext[0] = W[0]^(keySout^Rcon);
assign Wnext[1] = W[1]^Wnext[0];
assign Wnext[2] = W[2]^Wnext[1];
assign Wnext[3] = W[3]^Wnext[2];
assign nextkey = {Wnext[0],Wnext[1],Wnext[2],Wnext[3]};                                                                   
endmodule