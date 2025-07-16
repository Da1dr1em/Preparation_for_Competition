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
// Last modified Date:     2025/07/15 14:50:45
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/15 14:50:45
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              SSeven.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\SSeven.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module SSeven(
    input [1:6] Sin, //输入的S盒数据
    output [1:4] Sout //输出的S盒数据;                 
);
reg [1:4] S_out; //S盒输出数据
always @(Sin) begin
    case({Sin[1], Sin[6], Sin[2:5]}) //S盒地址，第一位和最后一位是行号，中间四位是列号
        0:  S_out =  4;
         1:  S_out = 11;
         2:  S_out =  2;
         3:  S_out = 14;
         4:  S_out = 15;
         5:  S_out =  0;
         6:  S_out =  8;
         7:  S_out = 13;
         8:  S_out =  3;
         9:  S_out = 12;
        10:  S_out =  9;
        11:  S_out =  7;
        12:  S_out =  5;
        13:  S_out = 10;
        14:  S_out =  6;
        15:  S_out =  1;

        16:  S_out = 13;
        17:  S_out =  0;
        18:  S_out = 11;
        19:  S_out =  7;
        20:  S_out =  4;
        21:  S_out =  9;
        22:  S_out =  1;
        23:  S_out = 10;
        24:  S_out = 14;
        25:  S_out =  3;
        26:  S_out =  5;
        27:  S_out = 12;
        28:  S_out =  2;
        29:  S_out = 15;
        30:  S_out =  8;
        31:  S_out =  6;

        32:  S_out =  1;
        33:  S_out =  4;
        34:  S_out = 11;
        35:  S_out = 13;
        36:  S_out = 12;
        37:  S_out =  3;
        38:  S_out =  7;
        39:  S_out = 14;
        40:  S_out = 10;
        41:  S_out = 15;
        42:  S_out =  6;
        43:  S_out =  8;
        44:  S_out =  0;
        45:  S_out =  5;
        46:  S_out =  9;
        47:  S_out =  2;

        48:  S_out =  6;
        49:  S_out = 11;
        50:  S_out = 13;
        51:  S_out =  8;
        52:  S_out =  1;
        53:  S_out =  4;
        54:  S_out = 10;
        55:  S_out =  7;
        56:  S_out =  9;
        57:  S_out =  5;
        58:  S_out =  0;
        59:  S_out = 15;
        60:  S_out = 14;
        61:  S_out =  2;
        62:  S_out =  3;
        63:  S_out = 12;
        default: ;
            
    endcase
end                                                                   
assign Sout = S_out;                                                                    
endmodule