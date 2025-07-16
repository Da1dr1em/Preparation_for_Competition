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
// Last modified Date:     2025/07/15 14:23:44
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/15 14:23:44
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              STwo.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\STwo.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module STwo(
    input [1:6] Sin, //输入的S盒数据
     output [1:4] Sout //输出的S盒数据;                 
);
reg [1:4] S_out; //S盒输出数据
    always @(Sin) begin
        case ({Sin[1], Sin[6], Sin[2:5]}) //S盒地址，第一位和最后一位是行号，中间四位是列号
         0:  S_out = 15;
         1:  S_out =  1;
         2:  S_out =  8;
         3:  S_out = 14;
         4:  S_out =  6;
         5:  S_out = 11;
         6:  S_out =  3;
         7:  S_out =  4;
         8:  S_out =  9;
         9:  S_out =  7;
        10:  S_out =  2;
        11:  S_out = 13;
        12:  S_out = 12;
        13:  S_out =  0;
        14:  S_out =  5;
        15:  S_out = 10;

        16:  S_out =  3;
        17:  S_out = 13;
        18:  S_out =  4;
        19:  S_out =  7;
        20:  S_out = 15;
        21:  S_out =  2;
        22:  S_out =  8;
        23:  S_out = 14;
        24:  S_out = 12;
        25:  S_out =  0;
        26:  S_out =  1;
        27:  S_out = 10;
        28:  S_out =  6;
        29:  S_out =  9;
        30:  S_out = 11;
        31:  S_out =  5;

        32:  S_out =  0;
        33:  S_out = 14;
        34:  S_out =  7;
        35:  S_out = 11;
        36:  S_out = 10;
        37:  S_out =  4;
        38:  S_out = 13;
        39:  S_out =  1;
        40:  S_out =  5;
        41:  S_out =  8;
        42:  S_out = 12;
        43:  S_out =  6;
        44:  S_out =  9;
        45:  S_out =  3;
        46:  S_out =  2;
        47:  S_out = 15;

        48:  S_out = 13;
        49:  S_out =  8;
        50:  S_out = 10;
        51:  S_out =  1;
        52:  S_out =  3;
        53:  S_out = 15;
        54:  S_out =  4;
        55:  S_out =  2;
        56:  S_out = 11;
        57:  S_out =  6;
        58:  S_out =  7;
        59:  S_out = 12;
        60:  S_out =  0;
        61:  S_out =  5;
        62:  S_out = 14;
        63:  S_out =  9;
        default: ;
            
    endcase

    end                                                                                                            
assign Sout = S_out;                                                                    
endmodule