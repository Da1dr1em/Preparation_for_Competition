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
// Last modified Date:     2025/07/15 14:43:47
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/15 14:43:47
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              SFive.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\SFive.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module SFive(
    input [1:6] Sin, //输入的S盒数据
    output [1:4] Sout //输出的S盒数据;                 
);
reg [1:4] S_out; //S盒输出数据
always @(Sin) begin
    case({Sin[1],Sin[6],Sin[2:5]}) //S盒地址，第一位和最后一位是行号，中间四位是列号
        0:  S_out =  2;
         1:  S_out = 12;
         2:  S_out =  4;
         3:  S_out =  1;
         4:  S_out =  7;
         5:  S_out = 10;
         6:  S_out = 11;
         7:  S_out =  6;
         8:  S_out =  8;
         9:  S_out =  5;
        10:  S_out =  3;
        11:  S_out = 15;
        12:  S_out = 13;
        13:  S_out =  0;
        14:  S_out = 14;
        15:  S_out =  9;

        16:  S_out = 14;
        17:  S_out = 11;
        18:  S_out =  2;
        19:  S_out = 12;
        20:  S_out =  4;
        21:  S_out =  7;
        22:  S_out = 13;
        23:  S_out =  1;
        24:  S_out =  5;
        25:  S_out =  0;
        26:  S_out = 15;
        27:  S_out = 10;
        28:  S_out =  3;
        29:  S_out =  9;
        30:  S_out =  8;
        31:  S_out =  6;

        32:  S_out =  4;
        33:  S_out =  2;
        34:  S_out =  1;
        35:  S_out = 11;
        36:  S_out = 10;
        37:  S_out = 13;
        38:  S_out =  7;
        39:  S_out =  8;
        40:  S_out = 15;
        41:  S_out =  9;
        42:  S_out = 12;
        43:  S_out =  5;
        44:  S_out =  6;
        45:  S_out =  3;
        46:  S_out =  0;
        47:  S_out = 14;

        48:  S_out = 11;
        49:  S_out =  8;
        50:  S_out = 12;
        51:  S_out =  7;
        52:  S_out =  1;
        53:  S_out = 14;
        54:  S_out =  2;
        55:  S_out = 13;
        56:  S_out =  6;
        57:  S_out = 15;
        58:  S_out =  0;
        59:  S_out =  9;
        60:  S_out = 10;
        61:  S_out =  4;
        62:  S_out =  5;
        63:  S_out =  3;
        
        default:   ;
        
    endcase
end
assign Sout = S_out; 
                                                                                                                                    
endmodule