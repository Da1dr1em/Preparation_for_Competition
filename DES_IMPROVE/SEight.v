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
// Last modified Date:     2025/07/15 15:00:44
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/15 15:00:44
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Seight.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\Seight.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module SEight(
    input [1:6] Sin, //输入的S盒数据
    output [1:4] Sout //输出的S盒数据;                 
);
reg [1:4] S_out; //S盒输出数据
always @(Sin) begin
    case ({Sin[1], Sin[6], Sin[2:5]})
         0:  S_out = 13;
         1:  S_out =  2;
         2:  S_out =  8;
         3:  S_out =  4;
         4:  S_out =  6;
         5:  S_out = 15;
         6:  S_out = 11;
         7:  S_out =  1;
         8:  S_out = 10;
         9:  S_out =  9;
        10:  S_out =  3;
        11:  S_out = 14;
        12:  S_out =  5;
        13:  S_out =  0;
        14:  S_out = 12;
        15:  S_out =  7;

        16:  S_out =  1;
        17:  S_out = 15;
        18:  S_out = 13;
        19:  S_out =  8;
        20:  S_out = 10;
        21:  S_out =  3;
        22:  S_out =  7;
        23:  S_out =  4;
        24:  S_out = 12;
        25:  S_out =  5;
        26:  S_out =  6;
        27:  S_out = 11;
        28:  S_out =  0;
        29:  S_out = 14;
        30:  S_out =  9;
        31:  S_out =  2;

        32:  S_out =  7;
        33:  S_out = 11;
        34:  S_out =  4;
        35:  S_out =  1;
        36:  S_out =  9;
        37:  S_out = 12;
        38:  S_out = 14;
        39:  S_out =  2;
        40:  S_out =  0;
        41:  S_out =  6;
        42:  S_out = 10;
        43:  S_out = 13;
        44:  S_out = 15;
        45:  S_out =  3;
        46:  S_out =  5;
        47:  S_out =  8;

        48:  S_out =  2;
        49:  S_out =  1;
        50:  S_out = 14;
        51:  S_out =  7;
        52:  S_out =  4;
        53:  S_out = 10;
        54:  S_out =  8;
        55:  S_out = 13;
        56:  S_out = 15;
        57:  S_out = 12;
        58:  S_out =  9;
        59:  S_out =  0;
        60:  S_out =  3;
        61:  S_out =  5;
        62:  S_out =  6;
        63:  S_out = 11;

    endcase
    
end                                                                   
assign Sout = S_out;                                                                  
endmodule