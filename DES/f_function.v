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
    input reg [1:48] Keyin,
    input reg [1:32] RDatain, //输入的32位数据;
    output reg [1:32] f_out //输出的48位数据                   
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
    // S盒1
    S_table1[1] = 14; S_table1[2] = 4; S_table1[3] = 13; S_table1[4] = 1;
    S_table1[5] = 2; S_table1[6] = 15; S_table1[7] = 11; S_table1[8] = 8;
    S_table1[9] = 3; S_table1[10] = 10; S_table1[11] = 6; S_table1[12] = 12;
    S_table1[13] = 5; S_table1[14] = 9; S_table1[15] = 0; S_table1[16] = 7;
    // S2
    S_table2[1] = 0; S_table2[2] = 15; S_table2[3] = 7; S_table2[4] = 4;
    S_table2[5] = 14; S_table2[6] = 2; S_table2[7] = 13; S_table2[8] = 1;
    S_table2[9] = 10; S_table2[10] = 6; S_table2[11] = 12; S_table2[12] = 11;
    S_table2[13] = 9; S_table2[14] = 5; S_table2[15] = 3; S_table2[16] = 8;
    // S3
    S_table3[1] = 4; S_table3[2] = 1; S_table3[3] = 14; S_table3[4] = 8;
    S_table3[5] = 13; S_table3[6] = 6; S_table3[7] = 2; S_table3[8] = 11;
    S_table3[9] = 15; S_table3[10] = 12; S_table3[11] = 9; S_table3[12] = 7;
    S_table3[13] = 3; S_table3[14] = 10; S_table3[15] = 5; S_table3[16] = 0;
    // S4
    S_table4[1] = 15; S_table4[2] = 12; S_table4[3] = 8; S_table4[4] = 2;
    S_table4[5] = 4; S_table4[6] = 9; S_table4[7] = 1; S_table4[8] = 7;
    S_table4[9] = 5; S_table4[10] = 11; S_table4[11] = 3; S_table4[12] = 14;
    S_table4[13] = 10; S_table4[14] = 6; S_table4[15] = 0; S_table4[16] = 13;
    // S5
    S_table5[1] = 2; S_table5[2] = 1; S_table5[3] = 14; S_table5[4] = 7;
    S_table5[5] = 4; S_table5[6] = 10; S_table5[7] = 8; S_table5[8] = 13;
    S_table5[9] = 15; S_table5[10] = 12; S_table5[11] = 9; S_table5[12] = 0;
    S_table5[13] = 3; S_table5[14] = 5; S_table5[15] = 6; S_table5[16] = 11;
    // S6
    S_table6[1] = 12; S_table6[2] = 10; S_table6[3] = 15; S_table6[4] = 4;
    S_table6[5] = 9; S_table6[6] = 7; S_table6[7] = 3; S_table6[8] = 2;
    S_table6[9] = 8; S_table6[10] = 1; S_table6[11] = 6; S_table6[12] = 13;
    S_table6[13] = 0; S_table6[14] = 5; S_table6[15] = 14; S_table6[16] = 11;
    // S7
    S_table7[1] = 10; S_table7[2] = 0; S_table7[3] = 9; S_table7[4] = 14;
    S_table7[5] = 6; S_table7[6] = 3; S_table7[7] = 15; S_table7[8] = 5;
    S_table7[9] = 1; S_table7[10] = 13; S_table7[11] = 2; S_table7[12] = 8;
    S_table7[13] = 12; S_table7[14] = 7; S_table7[15] = 11; S_table7[16] = 4;
    // S8
    S_table8[1] = 3; S_table8[2] = 13; S_table8[3] = 4; S_table8[4] = 7;
    S_table8[5] = 15; S_table8[6] = 2; S_table8[7] = 8; S_table8[8] = 14;
    S_table8[9] = 12; S_table8[10] = 0; S_table8[11] = 1; S_table8[12] = 10;
    S_table8[13] = 6; S_table8[14] = 9; S_table8[15] = 11; S_table8[16] = 5;
end
//对Sin进行拆分和S盒变换
wire [1:6] S_in[1:8]; //每个S盒的输入-》6*8
reg  [1:32] S_out ;//S盒的输出
generate
    for (j = 1; j <= 8; j = j + 1) begin : S_box_loop
        assign S_in[j] = Sin[(j-1)*6 +1: 6*j+1]; // 拆分Sin为每个S盒的输入
    end
endgenerate
//接下来在时钟的控制下进行S变换,发现不需要使用循环
    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n)                               
                S_out <=0;                                   
            else begin
                S_out[1:4]<=S_table1[{S_in[1][1], S_in[1][6], S_in[1][2:5]}]; //S盒1
                S_out[5:8]<=S_table2[{S_in[2][1], S_in[2][6], S_in[2][2:5]}]; //S盒2
                S_out[9:12]<=S_table3[{S_in[3][1], S_in[3][6], S_in[3][2:5]}]; //S盒3
                S_out[13:16]<=S_table4[{S_in[4][1], S_in[4][6], S_in[4][2:5]}]; //S盒4
                S_out[17:20]<=S_table5[{S_in[5][1], S_in[5][6], S_in[5][2:5]}]; //S盒5
                S_out[21:24]<=S_table6[{S_in[6][1], S_in[6][6], S_in[6][2:5]}]; //S盒6
                S_out[25:28]<=S_table7[{S_in[7][1], S_in[7][6], S_in[7][2:5]}]; //S盒7
                S_out[29:32]<=S_table8[{S_in[8][1], S_in[8][6], S_in[8][2:5]}]; //S盒8
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