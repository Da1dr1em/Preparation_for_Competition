//***********************module f_function_combinational(

//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-3.6.20250620
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              f_function_combinational.v
// Last modified Date:     2025/01/12 
// Last Version:           V3.0
// Descriptions:           完全组合逻辑版本的F函数，无时钟延迟
//                        将所有的寄存器逻辑改为组合逻辑，输出可以在同一时钟周期内产生
//----------------------------------------------------------------------------------------

module f_function(
    input [1:48] Keyin,
    input [1:32] RDatain, //输入的32位数据;
    output [1:32] f_out //输出的32位数据                   
);

//F函数由四个部分组成：对Rdata进行E变换扩展，结果与Keyin进行异或运算，最后对结果进行S盒变换和P变换得到32位输出

// E变换表声明 - 48个6(1~32)位元素的数组

// E变换 - 组合逻辑
wire [1:48] EData;

//为了节省寄存器资源，仍然选择使用组合逻辑实现E变换，直接在输出端口上进行赋值
assign EData = {
    RDatain[32], RDatain[1], RDatain[2], RDatain[3], RDatain[4], RDatain[5],
    RDatain[4], RDatain[5], RDatain[6], RDatain[7], RDatain[8], RDatain[9],
    RDatain[8], RDatain[9], RDatain[10], RDatain[11], RDatain[12], RDatain[13],
    RDatain[12], RDatain[13], RDatain[14], RDatain[15], RDatain[16], RDatain[17],
    RDatain[16], RDatain[17], RDatain[18], RDatain[19], RDatain[20], RDatain[21],
    RDatain[20], RDatain[21], RDatain[22], RDatain[23], RDatain[24], RDatain[25],
    RDatain[24], RDatain[25], RDatain[26], RDatain[27], RDatain[28], RDatain[29],
    RDatain[28], RDatain[29], RDatain[30], RDatain[31], RDatain[32], RDatain[1]
};

// 异或运算 - 组合逻辑
wire [1:48] Sin;
assign Sin = EData ^ Keyin;

//为节省资源，仍然仅使用组合逻辑完成S盒变换，直接在输出端口上进行赋值
wire [1:32] S_out;
//不好使用赋值的方式，应该使用case语句实现，内容太多考虑另起模块








// P变换表声明
assign f_out[1]  = S_out[16];
assign f_out[2]  = S_out[7];
assign f_out[3]  = S_out[20];
assign f_out[4]  = S_out[21];
assign f_out[5]  = S_out[29];
assign f_out[6]  = S_out[12];
assign f_out[7]  = S_out[28];
assign f_out[8]  = S_out[17];
assign f_out[9]  = S_out[1];
assign f_out[10] = S_out[15];
assign f_out[11] = S_out[23];
assign f_out[12] = S_out[26];
assign f_out[13] = S_out[5];
assign f_out[14] = S_out[18];
assign f_out[15] = S_out[31];
assign f_out[16] = S_out[10];
assign f_out[17] = S_out[2];
assign f_out[18] = S_out[8];
assign f_out[19] = S_out[24];
assign f_out[20] = S_out[14];
assign f_out[21] = S_out[32];
assign f_out[22] = S_out[27];
assign f_out[23] = S_out[3];
assign f_out[24] = S_out[9];
assign f_out[25] = S_out[19];
assign f_out[26] = S_out[13];
assign f_out[27] = S_out[30];
assign f_out[28] = S_out[6];
assign f_out[29] = S_out[22];
assign f_out[30] = S_out[11];
assign f_out[31] = S_out[4];
assign f_out[32] = S_out[25];

endmodule
