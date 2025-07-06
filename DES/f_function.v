//***********************module f_function(

//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-3.6.20250620
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2025/07/05 14:46:38
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/05 14:46:38
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              f_function.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\f_function.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module f_function(
    input clk, //时钟信号;
    input rst_n, //复位信号;
    input [1:48] Keyin,
    input [1:32] RDatain, //输入的32位数据;
    output reg [1:32] f_out //输出的32位数据                   
);
//F函数由四个部分组成：对Rdata进行E变换扩展，结果与Keyin进行异或运算，最后对结果进行S盒变换和P变换得到32位输出
// E变换表声明 - 48个6(1~32)位元素的数组
reg [5:0] ETable [1:48];
initial begin
    ETable[1] = 32; ETable[2] = 1; ETable[3] = 2; ETable[4] = 3;
    ETable[5] = 4; ETable[6] = 5; ETable[7] = 4; ETable[8] = 5;
    ETable[9] = 6; ETable[10] = 7; ETable[11] = 8; ETable[12] = 9;
    ETable[13] = 8; ETable[14] = 9; ETable[15] = 10; ETable[16] = 11;
    ETable[17] = 12; ETable[18] = 13; ETable[19] = 12; ETable[20] = 13;
    ETable[21] = 14; ETable[22] = 15; ETable[23] = 16; ETable[24] = 17;
    ETable[25] = 16; ETable[26] = 17; ETable[27] = 18; ETable[28] = 19;
    ETable[29] = 20; ETable[30] = 21; ETable[31] = 20; ETable[32] = 21;
    ETable[33] = 22; ETable[34] = 23; ETable[35] = 24; ETable[36] = 25;
    ETable[37] = 24; ETable[38] = 25; ETable[39] = 26; ETable[40] = 27;
    ETable[41] = 28; ETable[42] = 29; ETable[43] = 28; ETable[44] = 29;
    ETable[45] = 30; ETable[46] = 31; ETable[47] = 32; ETable[48] = 1;
end
genvar i,j,k;
// E变换
wire [1:48] EData;
generate
    for (i = 1; i <= 48; i = i + 1) begin : E_transform_loop
        assign EData[i] = RDatain[ETable[i]];
    end
endgenerate
wire [1:48] Sin;
assign Sin = EData ^ Keyin; // E变换结果与Keyin进行按位异或运算

//接下来进行S盒变换
//8个S盒，每个盒有6位输入，4位输出，六到4的变换由S表实现,每个S表有64个元素,每个元素最高为15(4'b1111)
reg [3:0] S_table1 [1:64];
reg [3:0] S_table2 [1:64];
reg [3:0] S_table3 [1:64];
reg [3:0] S_table4 [1:64];
reg [3:0] S_table5 [1:64];
reg [3:0] S_table6 [1:64];
reg [3:0] S_table7 [1:64];
reg [3:0] S_table8 [1:64];
//接下来对每个S盒赋初值
initial begin
    // S盒1 - 完整的64个值
    S_table1[1] = 14; S_table1[2] = 4; S_table1[3] = 13; S_table1[4] = 1; S_table1[5] = 2; S_table1[6] = 15; S_table1[7] = 11; S_table1[8] = 8;
    S_table1[9] = 3; S_table1[10] = 10; S_table1[11] = 6; S_table1[12] = 12; S_table1[13] = 5; S_table1[14] = 9; S_table1[15] = 0; S_table1[16] = 7;
    S_table1[17] = 0; S_table1[18] = 15; S_table1[19] = 7; S_table1[20] = 4; S_table1[21] = 14; S_table1[22] = 2; S_table1[23] = 13; S_table1[24] = 1;
    S_table1[25] = 10; S_table1[26] = 6; S_table1[27] = 12; S_table1[28] = 11; S_table1[29] = 9; S_table1[30] = 5; S_table1[31] = 3; S_table1[32] = 8;
    S_table1[33] = 4; S_table1[34] = 1; S_table1[35] = 14; S_table1[36] = 8; S_table1[37] = 13; S_table1[38] = 6; S_table1[39] = 2; S_table1[40] = 11;
    S_table1[41] = 15; S_table1[42] = 12; S_table1[43] = 9; S_table1[44] = 7; S_table1[45] = 3; S_table1[46] = 10; S_table1[47] = 5; S_table1[48] = 0;
    S_table1[49] = 15; S_table1[50] = 12; S_table1[51] = 8; S_table1[52] = 2; S_table1[53] = 4; S_table1[54] = 9; S_table1[55] = 1; S_table1[56] = 7;
    S_table1[57] = 5; S_table1[58] = 11; S_table1[59] = 3; S_table1[60] = 14; S_table1[61] = 10; S_table1[62] = 0; S_table1[63] = 6; S_table1[64] = 13;

    // S盒2 - 完整的64个值
    S_table2[1] = 15; S_table2[2] = 1; S_table2[3] = 8; S_table2[4] = 14; S_table2[5] = 6; S_table2[6] = 11; S_table2[7] = 3; S_table2[8] = 4;
    S_table2[9] = 9; S_table2[10] = 7; S_table2[11] = 2; S_table2[12] = 13; S_table2[13] = 12; S_table2[14] = 0; S_table2[15] = 5; S_table2[16] = 10;
    S_table2[17] = 3; S_table2[18] = 13; S_table2[19] = 4; S_table2[20] = 7; S_table2[21] = 15; S_table2[22] = 2; S_table2[23] = 8; S_table2[24] = 14;
    S_table2[25] = 12; S_table2[26] = 0; S_table2[27] = 1; S_table2[28] = 10; S_table2[29] = 6; S_table2[30] = 9; S_table2[31] = 11; S_table2[32] = 5;
    S_table2[33] = 0; S_table2[34] = 14; S_table2[35] = 7; S_table2[36] = 11; S_table2[37] = 10; S_table2[38] = 4; S_table2[39] = 13; S_table2[40] = 1;
    S_table2[41] = 5; S_table2[42] = 8; S_table2[43] = 12; S_table2[44] = 6; S_table2[45] = 9; S_table2[46] = 3; S_table2[47] = 2; S_table2[48] = 15;
    S_table2[49] = 13; S_table2[50] = 8; S_table2[51] = 10; S_table2[52] = 1; S_table2[53] = 3; S_table2[54] = 15; S_table2[55] = 4; S_table2[56] = 2;
    S_table2[57] = 11; S_table2[58] = 6; S_table2[59] = 7; S_table2[60] = 12; S_table2[61] = 0; S_table2[62] = 5; S_table2[63] = 14; S_table2[64] = 9;

    // S盒3 - 完整的64个值
    S_table3[1] = 10; S_table3[2] = 0; S_table3[3] = 9; S_table3[4] = 14; S_table3[5] = 6; S_table3[6] = 3; S_table3[7] = 15; S_table3[8] = 5;
    S_table3[9] = 1; S_table3[10] = 13; S_table3[11] = 12; S_table3[12] = 7; S_table3[13] = 11; S_table3[14] = 4; S_table3[15] = 2; S_table3[16] = 8;
    S_table3[17] = 13; S_table3[18] = 7; S_table3[19] = 0; S_table3[20] = 9; S_table3[21] = 3; S_table3[22] = 4; S_table3[23] = 6; S_table3[24] = 10;
    S_table3[25] = 2; S_table3[26] = 8; S_table3[27] = 5; S_table3[28] = 14; S_table3[29] = 12; S_table3[30] = 11; S_table3[31] = 15; S_table3[32] = 1;
    S_table3[33] = 13; S_table3[34] = 6; S_table3[35] = 4; S_table3[36] = 9; S_table3[37] = 8; S_table3[38] = 15; S_table3[39] = 3; S_table3[40] = 0;
    S_table3[41] = 11; S_table3[42] = 1; S_table3[43] = 2; S_table3[44] = 12; S_table3[45] = 5; S_table3[46] = 10; S_table3[47] = 14; S_table3[48] = 7;
    S_table3[49] = 1; S_table3[50] = 10; S_table3[51] = 13; S_table3[52] = 0; S_table3[53] = 6; S_table3[54] = 9; S_table3[55] = 8; S_table3[56] = 7;
    S_table3[57] = 4; S_table3[58] = 15; S_table3[59] = 14; S_table3[60] = 3; S_table3[61] = 11; S_table3[62] = 5; S_table3[63] = 2; S_table3[64] = 12;

    // S盒4 - 完整的64个值
    S_table4[1] = 7; S_table4[2] = 13; S_table4[3] = 14; S_table4[4] = 3; S_table4[5] = 0; S_table4[6] = 6; S_table4[7] = 9; S_table4[8] = 10;
    S_table4[9] = 1; S_table4[10] = 2; S_table4[11] = 8; S_table4[12] = 5; S_table4[13] = 11; S_table4[14] = 12; S_table4[15] = 4; S_table4[16] = 15;
    S_table4[17] = 13; S_table4[18] = 8; S_table4[19] = 11; S_table4[20] = 5; S_table4[21] = 6; S_table4[22] = 15; S_table4[23] = 0; S_table4[24] = 3;
    S_table4[25] = 4; S_table4[26] = 7; S_table4[27] = 2; S_table4[28] = 12; S_table4[29] = 1; S_table4[30] = 10; S_table4[31] = 14; S_table4[32] = 9;
    S_table4[33] = 10; S_table4[34] = 6; S_table4[35] = 9; S_table4[36] = 0; S_table4[37] = 12; S_table4[38] = 11; S_table4[39] = 7; S_table4[40] = 13;
    S_table4[41] = 15; S_table4[42] = 1; S_table4[43] = 3; S_table4[44] = 14; S_table4[45] = 5; S_table4[46] = 2; S_table4[47] = 8; S_table4[48] = 4;
    S_table4[49] = 3; S_table4[50] = 15; S_table4[51] = 0; S_table4[52] = 6; S_table4[53] = 10; S_table4[54] = 1; S_table4[55] = 13; S_table4[56] = 8;
    S_table4[57] = 9; S_table4[58] = 4; S_table4[59] = 5; S_table4[60] = 11; S_table4[61] = 12; S_table4[62] = 7; S_table4[63] = 2; S_table4[64] = 14;

    // S盒5 - 完整的64个值
    S_table5[1] = 2; S_table5[2] = 12; S_table5[3] = 4; S_table5[4] = 1; S_table5[5] = 7; S_table5[6] = 10; S_table5[7] = 11; S_table5[8] = 6;
    S_table5[9] = 8; S_table5[10] = 5; S_table5[11] = 3; S_table5[12] = 15; S_table5[13] = 13; S_table5[14] = 0; S_table5[15] = 14; S_table5[16] = 9;
    S_table5[17] = 14; S_table5[18] = 11; S_table5[19] = 2; S_table5[20] = 12; S_table5[21] = 4; S_table5[22] = 7; S_table5[23] = 13; S_table5[24] = 1;
    S_table5[25] = 5; S_table5[26] = 0; S_table5[27] = 15; S_table5[28] = 10; S_table5[29] = 3; S_table5[30] = 9; S_table5[31] = 8; S_table5[32] = 6;
    S_table5[33] = 4; S_table5[34] = 2; S_table5[35] = 1; S_table5[36] = 11; S_table5[37] = 10; S_table5[38] = 13; S_table5[39] = 7; S_table5[40] = 8;
    S_table5[41] = 15; S_table5[42] = 9; S_table5[43] = 12; S_table5[44] = 5; S_table5[45] = 6; S_table5[46] = 3; S_table5[47] = 0; S_table5[48] = 14;
    S_table5[49] = 11; S_table5[50] = 8; S_table5[51] = 12; S_table5[52] = 7; S_table5[53] = 1; S_table5[54] = 14; S_table5[55] = 2; S_table5[56] = 13;
    S_table5[57] = 6; S_table5[58] = 15; S_table5[59] = 0; S_table5[60] = 9; S_table5[61] = 10; S_table5[62] = 4; S_table5[63] = 5; S_table5[64] = 3;

    // S盒6 - 完整的64个值
    S_table6[1] = 12; S_table6[2] = 1; S_table6[3] = 10; S_table6[4] = 15; S_table6[5] = 9; S_table6[6] = 2; S_table6[7] = 6; S_table6[8] = 8;
    S_table6[9] = 0; S_table6[10] = 13; S_table6[11] = 3; S_table6[12] = 4; S_table6[13] = 14; S_table6[14] = 7; S_table6[15] = 5; S_table6[16] = 11;
    S_table6[17] = 10; S_table6[18] = 15; S_table6[19] = 4; S_table6[20] = 2; S_table6[21] = 7; S_table6[22] = 12; S_table6[23] = 9; S_table6[24] = 5;
    S_table6[25] = 6; S_table6[26] = 1; S_table6[27] = 13; S_table6[28] = 14; S_table6[29] = 0; S_table6[30] = 11; S_table6[31] = 3; S_table6[32] = 8;
    S_table6[33] = 9; S_table6[34] = 14; S_table6[35] = 15; S_table6[36] = 5; S_table6[37] = 2; S_table6[38] = 8; S_table6[39] = 12; S_table6[40] = 3;
    S_table6[41] = 7; S_table6[42] = 0; S_table6[43] = 4; S_table6[44] = 10; S_table6[45] = 1; S_table6[46] = 13; S_table6[47] = 11; S_table6[48] = 6;
    S_table6[49] = 4; S_table6[50] = 3; S_table6[51] = 2; S_table6[52] = 12; S_table6[53] = 9; S_table6[54] = 5; S_table6[55] = 15; S_table6[56] = 10;
    S_table6[57] = 11; S_table6[58] = 14; S_table6[59] = 1; S_table6[60] = 7; S_table6[61] = 6; S_table6[62] = 0; S_table6[63] = 8; S_table6[64] = 13;

    // S盒7 - 完整的64个值
    S_table7[1] = 4; S_table7[2] = 11; S_table7[3] = 2; S_table7[4] = 14; S_table7[5] = 15; S_table7[6] = 0; S_table7[7] = 8; S_table7[8] = 13;
    S_table7[9] = 3; S_table7[10] = 12; S_table7[11] = 9; S_table7[12] = 7; S_table7[13] = 5; S_table7[14] = 10; S_table7[15] = 6; S_table7[16] = 1;
    S_table7[17] = 13; S_table7[18] = 0; S_table7[19] = 11; S_table7[20] = 7; S_table7[21] = 4; S_table7[22] = 9; S_table7[23] = 1; S_table7[24] = 10;
    S_table7[25] = 14; S_table7[26] = 3; S_table7[27] = 5; S_table7[28] = 12; S_table7[29] = 2; S_table7[30] = 15; S_table7[31] = 8; S_table7[32] = 6;
    S_table7[33] = 1; S_table7[34] = 4; S_table7[35] = 11; S_table7[36] = 13; S_table7[37] = 12; S_table7[38] = 3; S_table7[39] = 7; S_table7[40] = 14;
    S_table7[41] = 10; S_table7[42] = 15; S_table7[43] = 6; S_table7[44] = 8; S_table7[45] = 0; S_table7[46] = 5; S_table7[47] = 9; S_table7[48] = 2;
    S_table7[49] = 6; S_table7[50] = 11; S_table7[51] = 13; S_table7[52] = 8; S_table7[53] = 1; S_table7[54] = 4; S_table7[55] = 10; S_table7[56] = 7;
    S_table7[57] = 9; S_table7[58] = 5; S_table7[59] = 0; S_table7[60] = 15; S_table7[61] = 14; S_table7[62] = 2; S_table7[63] = 3; S_table7[64] = 12;

    // S盒8 - 完整的64个值
    S_table8[1] = 13; S_table8[2] = 2; S_table8[3] = 8; S_table8[4] = 4; S_table8[5] = 6; S_table8[6] = 15; S_table8[7] = 11; S_table8[8] = 1;
    S_table8[9] = 10; S_table8[10] = 9; S_table8[11] = 3; S_table8[12] = 14; S_table8[13] = 5; S_table8[14] = 0; S_table8[15] = 12; S_table8[16] = 7;
    S_table8[17] = 1; S_table8[18] = 15; S_table8[19] = 13; S_table8[20] = 8; S_table8[21] = 10; S_table8[22] = 3; S_table8[23] = 7; S_table8[24] = 4;
    S_table8[25] = 12; S_table8[26] = 5; S_table8[27] = 6; S_table8[28] = 11; S_table8[29] = 0; S_table8[30] = 14; S_table8[31] = 9; S_table8[32] = 2;
    S_table8[33] = 7; S_table8[34] = 11; S_table8[35] = 4; S_table8[36] = 1; S_table8[37] = 9; S_table8[38] = 12; S_table8[39] = 14; S_table8[40] = 2;
    S_table8[41] = 0; S_table8[42] = 6; S_table8[43] = 10; S_table8[44] = 13; S_table8[45] = 15; S_table8[46] = 3; S_table8[47] = 5; S_table8[48] = 8;
    S_table8[49] = 2; S_table8[50] = 1; S_table8[51] = 14; S_table8[52] = 7; S_table8[53] = 4; S_table8[54] = 10; S_table8[55] = 8; S_table8[56] = 13;
    S_table8[57] = 15; S_table8[58] = 12; S_table8[59] = 9; S_table8[60] = 0; S_table8[61] = 3; S_table8[62] = 5; S_table8[63] = 6; S_table8[64] = 11;
end
//对Sin进行拆分和S盒变换
wire [1:6] S_in[1:8]; //每个S盒的输入-》6*8
reg  [1:32] S_out ;//S盒的输出
generate
    for (j = 1; j <= 8; j = j + 1) begin : S_box_loop
        assign S_in[j] = Sin[(j-1)*6 + 1: j*6]; // 修正：拆分Sin为每个S盒的输入
    end
endgenerate
//接下来在时钟的控制下进行S变换
reg [1:48] Sin_reg; // 注册Sin信号以改善时序
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Sin_reg <= 48'b0;
    end else begin
        Sin_reg <= Sin;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        S_out <= 32'b0;
    end else begin
        // 使用注册的Sin信号来改善时序
        S_out[1:4]   <= S_table1[{Sin_reg[1], Sin_reg[6], Sin_reg[2:5]} + 1];     //S盒1
        S_out[5:8]   <= S_table2[{Sin_reg[7], Sin_reg[12], Sin_reg[8:11]} + 1];   //S盒2
        S_out[9:12]  <= S_table3[{Sin_reg[13], Sin_reg[18], Sin_reg[14:17]} + 1]; //S盒3
        S_out[13:16] <= S_table4[{Sin_reg[19], Sin_reg[24], Sin_reg[20:23]} + 1]; //S盒4
        S_out[17:20] <= S_table5[{Sin_reg[25], Sin_reg[30], Sin_reg[26:29]} + 1]; //S盒5
        S_out[21:24] <= S_table6[{Sin_reg[31], Sin_reg[36], Sin_reg[32:35]} + 1]; //S盒6
        S_out[25:28] <= S_table7[{Sin_reg[37], Sin_reg[42], Sin_reg[38:41]} + 1]; //S盒7
        S_out[29:32] <= S_table8[{Sin_reg[43], Sin_reg[48], Sin_reg[44:47]} + 1]; //S盒8
    end
end
          
// P变换表声明 - 32个5位元素(1~32)的数组
reg [4:0] PTable [1:32];
initial begin
    PTable[1] = 16; PTable[2] = 7; PTable[3] = 20; PTable[4] = 21;
    PTable[5] = 29; PTable[6] = 12; PTable[7] = 28; PTable[8] = 17;
    PTable[9] = 1; PTable[10] = 15; PTable[11] = 23; PTable[12] = 26;
    PTable[13] = 5; PTable[14] = 18; PTable[15] = 31; PTable[16] = 10;
    PTable[17] = 2; PTable[18] = 8; PTable[19] = 24; PTable[20] = 14;
    PTable[21] = 32; PTable[22] = 27; PTable[23] = 3; PTable[24] = 9;
    PTable[25] = 19; PTable[26] = 13; PTable[27] = 30; PTable[28] = 6;
    PTable[29] = 22; PTable[30] = 11; PTable[31] = 4; PTable[32] = 25;
end
//执行P变换得到最终的f_out
generate
    for (k = 1; k <= 32; k = k + 1) begin : P_transform_loop
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                f_out[k] <= 0;
            end else begin
                f_out[k] <= S_out[PTable[k]];
            end
        end
    end
endgenerate

endmodule