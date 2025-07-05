`timescale 1ns / 1ps
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
// Last modified Date:     2025/07/05 09:14:43
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             NGL
// Created date:           2025/07/05 09:14:43
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              des.v
// PATH:                   D:\Working\竞赛练习\des.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module des(
    input clk,rst_n,start,
    input [1:64] desIn,keyIn, //输入的明文和密钥 
    output ready,
    output [1:64] desOut 
);                                            
wire [1:64] SwappedIpData;   
IP_Swap IP_Swap_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .desIn(desIn),
    .IPOut(SwappedIpData)
);
//拆分打散后的数组
reg [1:32] LData,RData;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        LData <= 32'b0;
        RData <= 32'b0;
    end else if (start) begin
        LData <= SwappedIpData[1:32];
        RData <= SwappedIpData[33:64];
    end
end

reg [1:48] subkey[1:16];
genvar i;
//生成16个私钥
generate
    for (i = 1; i <= 16; i = i + 1) begin : key_gen_loop
        Branch_Key_Generate Branch_Key_Generate_inst (
            .clk(clk),
            .rst_n(rst_n),
            .start(start),
            .keyid(i),
            .keyIn(keyIn),
            .branchkey(subkey[i])
        );
    end
endgenerate
//下一步是编写并使用f函数


                                                                 
endmodule