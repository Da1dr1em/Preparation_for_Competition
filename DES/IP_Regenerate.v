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
// Last modified Date:     2025/07/05 11:23:57
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/05 11:23:57
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              IP_Regenerate.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\IP_Regenerate.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//本模块是转换最后的IP反变换模块
module IP_Regenerate(
    input clk,rst_n,start,
    input [1:64] LRCombine,
    output reg ready, //转换完成标志位;
    output reg [1:64] desOut //输出的转换结果           
);
// IP反置换表声明 - 64个7位元素的数组
reg [6:0] IPRegenerateTable [1:64];
initial begin
    // 正确的IP反置换表初始化
    IPRegenerateTable[1] = 40; IPRegenerateTable[2] = 8; IPRegenerateTable[3] = 48; IPRegenerateTable[4] = 16;
    IPRegenerateTable[5] = 56; IPRegenerateTable[6] = 24; IPRegenerateTable[7] = 64; IPRegenerateTable[8] = 32;
    IPRegenerateTable[9] = 39; IPRegenerateTable[10] = 7; IPRegenerateTable[11] = 47; IPRegenerateTable[12] = 15;
    IPRegenerateTable[13] = 55; IPRegenerateTable[14] = 23; IPRegenerateTable[15] = 63; IPRegenerateTable[16] = 31;
    IPRegenerateTable[17] = 38; IPRegenerateTable[18] = 6; IPRegenerateTable[19] = 46; IPRegenerateTable[20] = 14;
    IPRegenerateTable[21] = 54; IPRegenerateTable[22] = 22; IPRegenerateTable[23] = 62; IPRegenerateTable[24] = 30;
    IPRegenerateTable[25] = 37; IPRegenerateTable[26] = 5; IPRegenerateTable[27] = 45; IPRegenerateTable[28] = 13;
    IPRegenerateTable[29] = 53; IPRegenerateTable[30] = 21; IPRegenerateTable[31] = 61; IPRegenerateTable[32] = 29;
    IPRegenerateTable[33] = 36; IPRegenerateTable[34] = 4; IPRegenerateTable[35] = 44; IPRegenerateTable[36] = 12;
    IPRegenerateTable[37] = 52; IPRegenerateTable[38] = 20; IPRegenerateTable[39] = 60; IPRegenerateTable[40] = 28;
    IPRegenerateTable[41] = 35; IPRegenerateTable[42] = 3; IPRegenerateTable[43] = 43; IPRegenerateTable[44] = 11;
    IPRegenerateTable[45] = 51; IPRegenerateTable[46] = 19; IPRegenerateTable[47] = 59; IPRegenerateTable[48] = 27;
    IPRegenerateTable[49] = 34; IPRegenerateTable[50] = 2; IPRegenerateTable[51] = 42; IPRegenerateTable[52] = 10;
    IPRegenerateTable[53] = 50; IPRegenerateTable[54] = 18; IPRegenerateTable[55] = 58; IPRegenerateTable[56] = 26;
    IPRegenerateTable[57] = 33; IPRegenerateTable[58] = 1; IPRegenerateTable[59] = 41; IPRegenerateTable[60] = 9;
    IPRegenerateTable[61] = 49; IPRegenerateTable[62] = 17; IPRegenerateTable[63] = 57; IPRegenerateTable[64] = 25;
end
// gennerate方法生成IP反置换的always块                                                   
genvar i;
generate
    for (i = 1; i <= 64; i = i + 1) begin : IP_Regenerate_Loop
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                desOut[i] <= 0;
            end else if (start) begin
                desOut[i] <= LRCombine[IPRegenerateTable[i]];
            end
        end
    end
endgenerate
// 生成ready信号
//逻辑是在转换完成后将ready信号置为1，能否通过标志位来控制ready信号的生成
// 这里假设start信号为1时表示开始转换，转换完成后ready信号为1
reg [1:64] ref;

always @(posedge clk or negedge rst_n) begin
    ref = LRCombine;
    if (!rst_n) begin
        ready <= 0;
    end else if (start) begin
        if (LRCombine == desOut)
            ready <= 0;
        else    ready <= 1; // 假设转换完成后ready信号为1
    end else begin
        ready <= 0; // 如果不是start状态，则ready信号为0
    end
end

endmodule