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
// Last modified Date:     2025/07/15 09:27:04
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/15 09:27:04
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Sone.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\Sone.v
// Descriptions:           
// 实现S1盒                        
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Sone(
    input [1:6] Sin, //输入的S盒数据
    output reg [1:4] S_out //输出的S盒数据;                 
);
wire [1:6] SAddress; //输入的S盒数据
//不用寄存器可能实现吗？
assign SAddress = {Sin[1],Sin[6],Sin[2:5]}; //S盒地址，第一位和最后一位是行号，中间四位是列号
always @(Sin) begin
    //相当于ROM了
    case (Sin)
        0:  S_out =  14;
         1:  S_out =   4;
         2:  S_out =  13;
         3:  S_out =   1;
         4:  S_out =   2;
         5:  S_out =  15;
         6:  S_out =  11;
         7:  S_out =   8;
         8:  S_out =   3;
         9:  S_out =  10;
        10:  S_out =   6;
        11:  S_out =  12;
        12:  S_out =   5;
        13:  S_out =   9;
        14:  S_out =   0;
        15:  S_out =   7;
        16:  S_out =   0;
        17:  S_out =  15;
        18:  S_out =   7;
        19:  S_out =   4;
        20:  S_out =  14;
        21:  S_out =   2;
        22:  S_out =  13;
        23:  S_out =   1;
        24:  S_out =  10;
        25:  S_out =   6;
        26:  S_out =  12;
        27:  S_out =  11;
        28:  S_out =   9;
        29:  S_out =   5;
        30:  S_out =   3;
        31:  S_out =   8;
        32:  S_out =   4;
        33:  S_out =   1;
        34:  S_out =  14;
        35:  S_out =   8;
        36:  S_out =  13;
        37:  S_out =   6;
        38:  S_out =   2;
        39:  S_out =  11;
        40:  S_out =  15;
        41:  S_out =  12;
        42:  S_out =   9;
        43:  S_out =   7;
        44:  S_out =   3;
        45:  S_out =  10;
        46:  S_out =   5;
        47:  S_out =   0;
        48:  S_out =  15;
        49:  S_out =  12;
        50:  S_out =   8;
        51:  S_out =   2;
        52:  S_out =   4;
        53:  S_out =   9;
        54:  S_out =   1;
        55:  S_out =   7;
        56:  S_out =   5;
        57:  S_out =  11;
        58:  S_out =   3;
        59:  S_out =  14;
        60:  S_out =  10;
        61:  S_out =   0;
        62:  S_out =   6;
        63:  S_out =  13;       
        default: ; 
    endcase
end                                                                   
endmodule