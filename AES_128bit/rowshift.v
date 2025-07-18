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
// Last modified Date:     2025/07/18 16:36:00
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/18 16:36:00
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              rowshift.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\rowshift.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//本模块是对输入的128位数据进行行移位操作
//行移位的规则是：第一行不变，第二行左移1个字节，第三行左移2个字节，第四行左移3个字节
//输入为128位，输出为128位
module rowshift(
    input [1:128] aesIn,
    output [1:128] rowshiftOut                   
);
//要求用组合逻辑完成
//将128位输入重新组织为4x4矩阵，每个元素8位
wire [7:0] input_matrix [0:3][0:3];
wire [7:0] output_matrix [0:3][0:3];

//将输入的128位数据按列优先顺序组织为4x4矩阵
//AES标准中，字节按列存储：第一列是字节0,1,2,3，第二列是字节4,5,6,7...
genvar i, j;
generate
    for (i = 0; i < 4; i = i + 1) begin : row_gen
        for (j = 0; j < 4; j = j + 1) begin : col_gen
            assign input_matrix[i][j] = aesIn[8*(j*4+i)+1 : 8*(j*4+i+1)];
        end
    end
endgenerate

//执行行移位操作
//第0行：不移位
assign output_matrix[0][0] = input_matrix[0][0];
assign output_matrix[0][1] = input_matrix[0][1];
assign output_matrix[0][2] = input_matrix[0][2];
assign output_matrix[0][3] = input_matrix[0][3];

//第1行：左移1个字节
assign output_matrix[1][0] = input_matrix[1][1];
assign output_matrix[1][1] = input_matrix[1][2];
assign output_matrix[1][2] = input_matrix[1][3];
assign output_matrix[1][3] = input_matrix[1][0];

//第2行：左移2个字节
assign output_matrix[2][0] = input_matrix[2][2];
assign output_matrix[2][1] = input_matrix[2][3];
assign output_matrix[2][2] = input_matrix[2][0];
assign output_matrix[2][3] = input_matrix[2][1];

//第3行：左移3个字节
assign output_matrix[3][0] = input_matrix[3][3];
assign output_matrix[3][1] = input_matrix[3][0];
assign output_matrix[3][2] = input_matrix[3][1];
assign output_matrix[3][3] = input_matrix[3][2];

//将4x4矩阵重新组织为128位输出
generate
    for (i = 0; i < 4; i = i + 1) begin : out_row_gen
        for (j = 0; j < 4; j = j + 1) begin : out_col_gen
            assign rowshiftOut[8*(j*4+i)+1 : 8*(j*4+i+1)] = output_matrix[i][j];
        end
    end
endgenerate

endmodule