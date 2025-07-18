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
// Last modified Date:     2025/07/18 18:31:13
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/18 18:31:13
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              column_mix.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\column_mix.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//完成列混合的功能
module column_mix(
    input [1:128] messagein,
    output [1:128] messageout                   
);
wire [1:8] message_matrix [0:3][0:3]; //输入的128位数据按列优先顺序组织为4x4矩阵
//将输入的128位数据按列优先顺序组织为4x4矩阵
//AES标准中，字节按列存储：第一列是字节0,1,2,3，第二列是字节4,5,6,7...
genvar i, j;
generate
    for (i = 0; i < 4; i = i + 1) begin : row_gen
        for (j = 0; j < 4; j = j + 1) begin : col_gen
            assign message_matrix[i][j] = messagein[8*(j*4+i)+1 : 8*(j*4+i+1)];
        end
    end
endgenerate
//进行列混合操作
wire [1:8] final_matrix [0:3][0:3];
wire [1:8] plus2_matrix [0:3][0:3];
wire [1:8] plus3_matrix [0:3][0:3];
//例化乘法模块
generate
    for (i = 0; i < 4; i = i + 1) begin : row_plus2_gen
        for (j = 0; j < 4; j = j + 1) begin : col_plus2_gen
            Matrix_plus plus2_inst (
                .figure(2'b10), //乘2
                .matrix(message_matrix[i][j]),
                .final_matrix(plus2_matrix[i][j])
            );
            Matrix_plus plus3_inst (
                .figure(2'b11), //乘3
                .matrix(message_matrix[i][j]),
                .final_matrix(plus3_matrix[i][j])
            );
        end
    end
endgenerate
//现在得到乘法结果后进行列混合操作
generate
    for (j = 0; j<4; j=j+1) begin
        assign final_matrix[0][j] = plus2_matrix[0][j] ^ plus3_matrix[1][j] ^ message_matrix[2][j] ^ message_matrix[3][j];
        assign final_matrix[1][j] = message_matrix[0][j] ^ plus2_matrix[1][j] ^ plus3_matrix[2][j] ^ message_matrix[3][j];
        assign final_matrix[2][j] = message_matrix[0][j] ^ message_matrix[1][j] ^ plus2_matrix[2][j] ^ plus3_matrix[3][j];
        assign final_matrix[3][j] = plus3_matrix[0][j] ^ message_matrix[1][j] ^ message_matrix[2][j] ^ plus2_matrix[3][j];
    end   
endgenerate

generate
    for (i = 0; i < 4; i = i + 1) begin : out_row_gen
        for (j = 0; j < 4; j = j + 1) begin : out_col_gen
            assign messageout[8*(j*4+i)+1 : 8*(j*4+i+1)] = final_matrix[i][j];
        end
    end
endgenerate


endmodule