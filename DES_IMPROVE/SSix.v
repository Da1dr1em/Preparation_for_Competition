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
// Last modified Date:     2025/07/15 14:49:40
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/15 14:49:40
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              SSix.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\SSix.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module SSix(
    input [1:6] Sin, //输入的S盒数据
    output [1:4] Sout //输出的S盒数据;                 
);
reg [1:4] S_out; //S盒输出数据
always @(Sin) begin
    case({Sin[1], Sin[6], Sin[2:5]}) //S盒地址，第一位和最后一位是行号，中间四位是列号
        0:  S_out = 12;
         1:  S_out =  1;
         2:  S_out = 10;
         3:  S_out = 15;
         4:  S_out =  9;
         5:  S_out =  2;
         6:  S_out =  6;
         7:  S_out =  8;
         8:  S_out =  0;
         9:  S_out = 13;
        10:  S_out =  3;
        11:  S_out =  4;
        12:  S_out = 14;
        13:  S_out =  7;
        14:  S_out =  5;
        15:  S_out = 11;

        16:  S_out = 10;
        17:  S_out = 15;
        18:  S_out =  4;
        19:  S_out =  2;
        20:  S_out =  7;
        21:  S_out = 12;
        22:  S_out =  9;
        23:  S_out =  5;
        24:  S_out =  6;
        25:  S_out =  1;
        26:  S_out = 13;
        27:  S_out = 14;
        28:  S_out =  0;
        29:  S_out = 11;
        30:  S_out =  3;
        31:  S_out =  8;

        32:  S_out =  9;
        33:  S_out = 14;
        34:  S_out = 15;
        35:  S_out =  5;
        36:  S_out =  2;
        37:  S_out =  8;
        38:  S_out = 12;
        39:  S_out =  3;
        40:  S_out =  7;
        41:  S_out =  0;
        42:  S_out =  4;
        43:  S_out = 10;
        44:  S_out =  1;
        45:  S_out = 13;
        46:  S_out = 11;
        47:  S_out =  6;

        48:  S_out =  4;
        49:  S_out =  3;
        50:  S_out =  2;
        51:  S_out = 12;
        52:  S_out =  9;
        53:  S_out =  5;
        54:  S_out = 15;
        55:  S_out = 10;
        56:  S_out = 11;
        57:  S_out = 14;
        58:  S_out =  1;
        59:  S_out =  7;
        60:  S_out =  6;
        61:  S_out =  0;
        62:  S_out =  8;
        63:  S_out = 13;
        default: ;
            
    endcase
end                                                                   
assign Sout = S_out;                                                                    
endmodule