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
// Last modified Date:     2025/07/05 13:17:41
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/05 13:17:41
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Branch_Key_Generate.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\Branch_Key_Generate.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//功能是得到第keyid个分支的48位私钥
//输入的keyid范围为1~16，keyIn为64位公钥
module Branch_Key_Generate(
    input clk,rst_n,start,
    input [5:0] keyid, //要求生成的私钥ID(1~16)
    input [1:64] keyIn, //输入的公钥       
    output [1:48] branchkey //生成48位私钥 - 改为wire类型
);

// 内部reg信号
reg [1:48] branchkey_reg;
//对密钥进行初始置换A
reg [1:56] keyA;
reg [5:0] keySwapA[1:56];
initial begin
    keySwapA[1] = 57; keySwapA[2] = 49; keySwapA[3] = 41; keySwapA[4] = 33;
    keySwapA[5] = 25; keySwapA[6] = 17; keySwapA[7] = 9; keySwapA[8] = 1;
    keySwapA[9] = 58; keySwapA[10] =  50; keySwapA[11] = 42; keySwapA[12] = 34;
    keySwapA[13] = 26; keySwapA[14] = 18; keySwapA[15] = 10; keySwapA[16] = 2;
    keySwapA[17] = 59; keySwapA[18] = 51; keySwapA[19] = 43; keySwapA[20] = 35;
    keySwapA[21] = 27; keySwapA[22] = 19; keySwapA[23] = 11; keySwapA[24] = 3;
    keySwapA[25] = 60; keySwapA[26] = 52; keySwapA[27] = 44; keySwapA[28] = 36;
    keySwapA[29] = 63; keySwapA[30] = 55; keySwapA[31] = 47; keySwapA[32] = 39;
    keySwapA[33] = 31; keySwapA[34] = 23; keySwapA[35] = 15; keySwapA[36] = 7;
    keySwapA[37] = 62; keySwapA[38] = 54; keySwapA[39] = 46; keySwapA[40] = 38;
    keySwapA[41] = 30; keySwapA[42] = 22; keySwapA[43] = 14; keySwapA[44] = 6;
    keySwapA[45] = 61; keySwapA[46] = 53; keySwapA[47] = 45; keySwapA[48] = 37;
    keySwapA[49] = 29; keySwapA[50] = 21; keySwapA[51] = 13; keySwapA[52] = 5;
    keySwapA[53] = 28; keySwapA[54] = 20; keySwapA[55] = 12; keySwapA[56] = 4;
end
genvar i,j;
//生成循环完成对输入的A变换。
generate
    for (i = 1; i <= 56; i = i + 1) begin : keySwapA_loop
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                keyA[i] <= 0;
            end else if (start) begin
                keyA[i] <= keyIn[keySwapA[i]];
            end
        end
    end
endgenerate

//对密钥进行C、D拆分和循环左移
reg [1:28] C,D; //C、D部分
wire [1:28] Ci,Di; //循环左移后的C、D，改为wire类型
reg start_dly, start_dly2, start_dly3, start_dly4; // start信号延迟

//核心思路是先把keyA拆分为C、D，然后根据输入的keyid进行循环左移得到要的Ci和Di
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        C <= 28'b0;
        D <= 28'b0;
        start_dly <= 1'b0;
        start_dly2 <= 1'b0;
        start_dly3 <= 1'b0;
        start_dly4 <= 1'b0;
    end else begin
        start_dly <= start;
        start_dly2 <= start_dly;
        start_dly3 <= start_dly2;
        start_dly4 <= start_dly3;
        if(start && !start_dly) begin  // start上升沿
            C <= keyA[1:28];
            D <= keyA[29:56];
        end
    end
end

//现在我们得到了C0、D0，接下来按照keyid进行循环左移
left_loop left_loop_inst(
    .clk(clk),
    .rst_n(rst_n),
    .start(start_dly2),  // 在C、D稳定后启动left_loop
    .C0(C),
    .D0(D),
    .keyid(keyid),
    .Ci(Ci), //循环左移后的C - wire类型
    .Di(Di)  //循环左移后的D - wire类型
);

reg [1:56] CombinedCD; //组合C和D
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        CombinedCD <= 56'b0;
    end else if (start_dly3) begin  // 等待left_loop输出稳定后再更新
        CombinedCD <= {Ci, Di}; //组合C和D
    end
end
//接下来进行B变换得到48位私钥
reg [5:0] keySwapBTable[1:48];
initial begin
keySwapBTable[1] = 14; keySwapBTable[2] = 17; keySwapBTable[3] = 11; keySwapBTable[4] = 24;
keySwapBTable[5] = 1; keySwapBTable[6] = 5; keySwapBTable[7] = 3; keySwapBTable[8] = 28;
keySwapBTable[9] = 15; keySwapBTable[10] = 6; keySwapBTable[11] = 21; keySwapBTable[12] = 10;
keySwapBTable[13] = 23; keySwapBTable[14] = 19; keySwapBTable[15] = 12; keySwapBTable[16] = 4;
keySwapBTable[17] = 26; keySwapBTable[18] = 8; keySwapBTable[19] = 16; keySwapBTable[20] = 7;
keySwapBTable[21] = 27; keySwapBTable[22] = 20; keySwapBTable[23] = 13; keySwapBTable[24] = 2;
keySwapBTable[25] = 41; keySwapBTable[26] = 52; keySwapBTable[27] = 31; keySwapBTable[28] = 37;
keySwapBTable[29] = 47; keySwapBTable[30] = 55; keySwapBTable[31] = 30; keySwapBTable[32] = 40;
keySwapBTable[33] = 51; keySwapBTable[34] = 45; keySwapBTable[35] = 33; keySwapBTable[36] = 48;
keySwapBTable[37] = 44; keySwapBTable[38] = 49; keySwapBTable[39] = 39; keySwapBTable[40] = 56;
keySwapBTable[41] = 34; keySwapBTable[42] = 53; keySwapBTable[43] = 46; keySwapBTable[44] = 42;
keySwapBTable[45] = 50; keySwapBTable[46] = 36; keySwapBTable[47] = 29; keySwapBTable[48] = 32;
end
generate
    for (j = 1; j <= 48; j = j + 1) begin : keySwapB_loop
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                branchkey_reg[j] <= 1'b0;
            end else if (start_dly4) begin  // 在CombinedCD稳定后再更新
                branchkey_reg[j] <= CombinedCD[keySwapBTable[j]];
            end
        end
    end
endgenerate

// 将内部reg信号连接到输出端口
assign branchkey = branchkey_reg;


endmodule