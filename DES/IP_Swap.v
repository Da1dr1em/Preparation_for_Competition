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
 // Last modified Date:     2025/07/05 09:24:04
 // Last Version:           V1.0
 // Descriptions:           
 //----------------------------------------------------------------------------------------
 // Created by:             Please Write You Name 
 // Created date:           2025/07/05 09:24:04
 // mail      :             Please Write mail 
 // Version:                V1.0
 // TEXT NAME:              IP_Swap.v
 // PATH:                   D:\Working\竞赛练习\DES\IP_Swap.v
 // Descriptions:           
 //本模块功能是对输入的明文进行第一步：IP置换
 //                         该模块的输入为64位明文，输出为64位置换                  
 //----------------------------------------------------------------------------------------
 //****************************************************************************************//
module IP_Swap(
    input clk,rst_n,start,
    input [1:64] desIn,//输入的明文
    output reg [1:64] IPOut, //输出的明文  
    output reg ready //置换完成信号
);

// IP置换表声明 - 64个7位元素的数组
reg [6:0] IPTable [1:64];

initial begin
    // 正确的IP置换表初始化
    IPTable[1] = 58; IPTable[2] = 50; IPTable[3] = 42; IPTable[4] = 34;
    IPTable[5] = 26; IPTable[6] = 18; IPTable[7] = 10; IPTable[8] = 2;
    IPTable[9] = 60; IPTable[10] = 52; IPTable[11] = 44; IPTable[12] = 36;
    IPTable[13] = 28; IPTable[14] = 20; IPTable[15] = 12; IPTable[16] = 4;
    IPTable[17] = 62; IPTable[18] = 54; IPTable[19] = 46; IPTable[20] = 38;
    IPTable[21] = 30; IPTable[22] = 22; IPTable[23] = 14; IPTable[24] = 6;
    IPTable[25] = 64; IPTable[26] = 56; IPTable[27] = 48; IPTable[28] = 40;
    IPTable[29] = 32; IPTable[30] = 24; IPTable[31] = 16; IPTable[32] = 8;
    IPTable[33] = 57; IPTable[34] = 49; IPTable[35] = 41; IPTable[36] = 33;
    IPTable[37] = 25; IPTable[38] = 17; IPTable[39] = 9; IPTable[40] = 1;
    IPTable[41] = 59; IPTable[42] = 51; IPTable[43] = 43; IPTable[44] = 35;
    IPTable[45] = 27; IPTable[46] = 19; IPTable[47] = 11; IPTable[48] = 3;
    IPTable[49] = 61; IPTable[50] = 53; IPTable[51] = 45; IPTable[52] = 37;
    IPTable[53] = 29; IPTable[54] = 21; IPTable[55] = 13; IPTable[56] = 5;
    IPTable[57] = 63; IPTable[58] = 55; IPTable[59] = 47; IPTable[60] = 39;
    IPTable[61] = 31; IPTable[62] = 23; IPTable[63] = 15; IPTable[64] = 7;
end
/*
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        IPOut <= 64'b0;
    end else if (start) begin  // 添加start信号控制
        for (integer i = 1; i <= 64; i = i + 1) begin  // 修正循环边界
            IPOut[i] <= desIn[IPTable[i]];
        end
    end
end
*/
//使用genvar和generate编写for循环来生成IP置换逻辑
genvar i;
generate
    for (i = 1; i <= 64; i = i + 1) begin : ip_swap_gen
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                IPOut[i] <= 0;
            end else if (start) begin
                IPOut[i] <= desIn[IPTable[i]];
            end
        end
    end
endgenerate

// 生成ready信号
reg start_dly;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        start_dly <= 1'b0;
        ready <= 1'b0;
    end else begin
        start_dly <= start;
        if (start && !start_dly) begin
            ready <= 1'b0;  // 开始置换
        end else if (start_dly && !start) begin
            ready <= 1'b1;  // 置换完成
        end else if (!start) begin
            ready <= 1'b0;
        end
    end
end

endmodule
