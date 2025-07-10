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

// 使用修复版本的F函数控制器来处理整个DES加密过程
// 包含时序修复、握手信号、子密钥保存状态和组合逻辑F函数
f_function_controller_v2 f_controller_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .desIn(desIn),
    .keyIn(keyIn),
    .ready(ready),
    .desOut(desOut)
);

endmodule