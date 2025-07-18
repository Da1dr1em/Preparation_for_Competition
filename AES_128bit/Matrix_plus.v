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
// Last modified Date:     2025/07/18 17:17:56
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/18 17:17:56
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Matrx_plus.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\Matrx_plus.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//本模块为了实现加密需要的矩阵乘法逻辑功能，实现乘2的逻辑功能
module Matrix_plus(
    input [1:0] figure,//看是乘2还是3,只能是这俩之一
    input [1:8] matrix,//被乘的矩阵
    output [1:8] final_matrix//输出的矩阵
);
wire [1:8] final_matrix2,final_matrix3;
assign final_matrix2 = (matrix[1] == 1)?
    ({matrix[2:8],1'b0} ^ 8'b00011011) : //如果最高位为1，则左移一位后与0x1B异或
    {matrix[2:8],1'b0}; //如果最高位为0，则只需左移一位

assign final_matrix3 = final_matrix2^matrix;
assign final_matrix = (figure==2'b10)? final_matrix2 : final_matrix3;
endmodule