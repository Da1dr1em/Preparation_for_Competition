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
// Last modified Date:     2025/07/15 14:35:56
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/15 14:35:56
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              SFour.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\SFour.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module SFour(
    input [1:6] Sin, //输入的S盒数据
    output [1:4] Sout //输出的S盒数据;                 
);
reg [1:4] S_out; //S盒输出数据
always @(Sin) begin
    case({Sin[1], Sin[6], Sin[2:5]}) //S盒地址，第一位和最后一位是行号，中间四位是列号
                  0:  S_out =  7;
         1:  S_out = 13;
         2:  S_out = 14;
         3:  S_out =  3;
         4:  S_out =  0;
         5:  S_out =  6;
         6:  S_out =  9;
         7:  S_out = 10;
         8:  S_out =  1;
         9:  S_out =  2;
        10:  S_out =  8;
        11:  S_out =  5;
        12:  S_out = 11;
        13:  S_out = 12;
        14:  S_out =  4;
        15:  S_out = 15;

        16:  S_out = 13;
        17:  S_out =  8;
        18:  S_out = 11;
        19:  S_out =  5;
        20:  S_out =  6;
        21:  S_out = 15;
        22:  S_out =  0;
        23:  S_out =  3;
        24:  S_out =  4;
        25:  S_out =  7;
        26:  S_out =  2;
        27:  S_out = 12;
        28:  S_out =  1;
        29:  S_out = 10;
        30:  S_out = 14;
        31:  S_out =  9;

        32:  S_out = 10;
        33:  S_out =  6;
        34:  S_out =  9;
        35:  S_out =  0;
        36:  S_out = 12;
        37:  S_out = 11;
        38:  S_out =  7;
        39:  S_out = 13;
        40:  S_out = 15;
        41:  S_out =  1;
        42:  S_out =  3;
        43:  S_out = 14;
        44:  S_out =  5;
        45:  S_out =  2;
        46:  S_out =  8;
        47:  S_out =  4;

        48:  S_out =  3;
        49:  S_out = 15;
        50:  S_out =  0;
        51:  S_out =  6;
        52:  S_out = 10;
        53:  S_out =  1;
        54:  S_out = 13;
        55:  S_out =  8;
        56:  S_out =  9;
        57:  S_out =  4;
        58:  S_out =  5;
        59:  S_out = 11;
        60:  S_out = 12;
        61:  S_out =  7;
        62:  S_out =  2;
        63:  S_out = 14;
        default: ;
        
    endcase
end                                                                   
assign Sout = S_out;                                                                    
endmodule