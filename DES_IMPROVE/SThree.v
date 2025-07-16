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
// Last modified Date:     2025/07/15 14:34:48
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/15 14:34:48
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              SThree.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\SThree.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module SThree(
    input [1:6] Sin, //输入的S盒数据
    output [1:4] Sout //输出的S盒数据;                 
);
reg [1:4] S_out; //S盒输出数据
always @(Sin) begin
    case ({Sin[1], Sin[6], Sin[2:5]}) //S盒地址，第一位和最后一位是行号，中间四位是列号
         0:  S_out = 10;
         1:  S_out =  0;
         2:  S_out =  9;
         3:  S_out = 14;
         4:  S_out =  6;
         5:  S_out =  3;
         6:  S_out = 15;
         7:  S_out =  5;
         8:  S_out =  1;
         9:  S_out = 13;
        10:  S_out = 12;
        11:  S_out =  7;
        12:  S_out = 11;
        13:  S_out =  4;
        14:  S_out =  2;
        15:  S_out =  8;

        16:  S_out = 13;
        17:  S_out =  7;
        18:  S_out =  0;
        19:  S_out =  9;
        20:  S_out =  3;
        21:  S_out =  4;
        22:  S_out =  6;
        23:  S_out = 10;
        24:  S_out =  2;
        25:  S_out =  8;
        26:  S_out =  5;
        27:  S_out = 14;
        28:  S_out = 12;
        29:  S_out = 11;
        30:  S_out = 15;
        31:  S_out =  1;

        32:  S_out = 13;
        33:  S_out =  6;
        34:  S_out =  4;
        35:  S_out =  9;
        36:  S_out =  8;
        37:  S_out = 15;
        38:  S_out =  3;
        39:  S_out =  0;
        40:  S_out = 11;
        41:  S_out =  1;
        42:  S_out =  2;
        43:  S_out = 12;
        44:  S_out =  5;
        45:  S_out = 10;
        46:  S_out = 14;
        47:  S_out =  7;

        48:  S_out =  1;
        49:  S_out = 10;
        50:  S_out = 13;
        51:  S_out =  0;
        52:  S_out =  6;
        53:  S_out =  9;
        54:  S_out =  8;
        55:  S_out =  7;
        56:  S_out =  4;
        57:  S_out = 15;
        58:  S_out = 14;
        59:  S_out =  3;
        60:  S_out = 11;
        61:  S_out =  5;
        62:  S_out =  2;
        63:  S_out = 12;
        default: ;
    endcase
end                                                                   
assign Sout = S_out;                                                                    
endmodule