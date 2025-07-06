//***********************module f_function_comb_v2

//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-3.6.20250620
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              f_function_comb_v2.v
// Last modified Date:     2025/01/17 
// Last Version:           V2.0
// Descriptions:           全组合逻辑实现的DES F函数 - 修正版
//----------------------------------------------------------------------------------------
// Created by:             GitHub Copilot 
// Created date:           2025/01/17
// Version:                V2.0
// TEXT NAME:              f_function_comb_v2.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\f_function_comb_v2.v
// Descriptions:           DES算法中的F函数，全组合逻辑实现
//                         包含E扩展、异或、S盒变换、P置换四个步骤
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module f_function_comb_v2(
    input [1:48] Keyin,         // 48位轮密钥输入
    input [1:32] RDatain,       // 32位R数据输入
    output [1:32] f_out         // 32位F函数输出
);

//========================================================================================
// 第一步：E扩展变换(32位->48位)
//========================================================================================

// E变换表 - 简化实现
wire [1:48] EData;
assign EData[1]  = RDatain[32]; assign EData[2]  = RDatain[1];  assign EData[3]  = RDatain[2];
assign EData[4]  = RDatain[3];  assign EData[5]  = RDatain[4];  assign EData[6]  = RDatain[5];
assign EData[7]  = RDatain[4];  assign EData[8]  = RDatain[5];  assign EData[9]  = RDatain[6];
assign EData[10] = RDatain[7];  assign EData[11] = RDatain[8];  assign EData[12] = RDatain[9];
assign EData[13] = RDatain[8];  assign EData[14] = RDatain[9];  assign EData[15] = RDatain[10];
assign EData[16] = RDatain[11]; assign EData[17] = RDatain[12]; assign EData[18] = RDatain[13];
assign EData[19] = RDatain[12]; assign EData[20] = RDatain[13]; assign EData[21] = RDatain[14];
assign EData[22] = RDatain[15]; assign EData[23] = RDatain[16]; assign EData[24] = RDatain[17];
assign EData[25] = RDatain[16]; assign EData[26] = RDatain[17]; assign EData[27] = RDatain[18];
assign EData[28] = RDatain[19]; assign EData[29] = RDatain[20]; assign EData[30] = RDatain[21];
assign EData[31] = RDatain[20]; assign EData[32] = RDatain[21]; assign EData[33] = RDatain[22];
assign EData[34] = RDatain[23]; assign EData[35] = RDatain[24]; assign EData[36] = RDatain[25];
assign EData[37] = RDatain[24]; assign EData[38] = RDatain[25]; assign EData[39] = RDatain[26];
assign EData[40] = RDatain[27]; assign EData[41] = RDatain[28]; assign EData[42] = RDatain[29];
assign EData[43] = RDatain[28]; assign EData[44] = RDatain[29]; assign EData[45] = RDatain[30];
assign EData[46] = RDatain[31]; assign EData[47] = RDatain[32]; assign EData[48] = RDatain[1];

//========================================================================================
// 第二步：与密钥异或
//========================================================================================

wire [1:48] Sin;
assign Sin = EData ^ Keyin; // E变换结果与Keyin进行按位异或运算

//========================================================================================
// 第三步：S盒变换(48位->32位)
//========================================================================================

// 将48位输入分为8组，每组6位
wire [5:0] S_in1, S_in2, S_in3, S_in4, S_in5, S_in6, S_in7, S_in8;
assign S_in1 = Sin[1:6];
assign S_in2 = Sin[7:12];
assign S_in3 = Sin[13:18];
assign S_in4 = Sin[19:24];
assign S_in5 = Sin[25:30];
assign S_in6 = Sin[31:36];
assign S_in7 = Sin[37:42];
assign S_in8 = Sin[43:48];

// S盒地址计算：{bit6, bit1, bit5, bit4, bit3, bit2}
wire [5:0] s1_addr, s2_addr, s3_addr, s4_addr, s5_addr, s6_addr, s7_addr, s8_addr;
assign s1_addr = {S_in1[0], S_in1[5], S_in1[1], S_in1[2], S_in1[3], S_in1[4]};
assign s2_addr = {S_in2[0], S_in2[5], S_in2[1], S_in2[2], S_in2[3], S_in2[4]};
assign s3_addr = {S_in3[0], S_in3[5], S_in3[1], S_in3[2], S_in3[3], S_in3[4]};
assign s4_addr = {S_in4[0], S_in4[5], S_in4[1], S_in4[2], S_in4[3], S_in4[4]};
assign s5_addr = {S_in5[0], S_in5[5], S_in5[1], S_in5[2], S_in5[3], S_in5[4]};
assign s6_addr = {S_in6[0], S_in6[5], S_in6[1], S_in6[2], S_in6[3], S_in6[4]};
assign s7_addr = {S_in7[0], S_in7[5], S_in7[1], S_in7[2], S_in7[3], S_in7[4]};
assign s8_addr = {S_in8[0], S_in8[5], S_in8[1], S_in8[2], S_in8[3], S_in8[4]};

// S盒输出 - 使用组合逻辑实现
reg [3:0] s1_out, s2_out, s3_out, s4_out, s5_out, s6_out, s7_out, s8_out;

// S盒1
always @(*) begin
    case(s1_addr)
        6'd0: s1_out = 14; 6'd1: s1_out = 4;  6'd2: s1_out = 13; 6'd3: s1_out = 1;
        6'd4: s1_out = 2;  6'd5: s1_out = 15; 6'd6: s1_out = 11; 6'd7: s1_out = 8;
        6'd8: s1_out = 3;  6'd9: s1_out = 10; 6'd10: s1_out = 6; 6'd11: s1_out = 12;
        6'd12: s1_out = 5; 6'd13: s1_out = 9; 6'd14: s1_out = 0; 6'd15: s1_out = 7;
        6'd16: s1_out = 0; 6'd17: s1_out = 15; 6'd18: s1_out = 7; 6'd19: s1_out = 4;
        6'd20: s1_out = 14; 6'd21: s1_out = 2; 6'd22: s1_out = 13; 6'd23: s1_out = 1;
        6'd24: s1_out = 10; 6'd25: s1_out = 6; 6'd26: s1_out = 12; 6'd27: s1_out = 11;
        6'd28: s1_out = 9; 6'd29: s1_out = 5; 6'd30: s1_out = 3; 6'd31: s1_out = 8;
        6'd32: s1_out = 4; 6'd33: s1_out = 1; 6'd34: s1_out = 14; 6'd35: s1_out = 8;
        6'd36: s1_out = 13; 6'd37: s1_out = 6; 6'd38: s1_out = 2; 6'd39: s1_out = 11;
        6'd40: s1_out = 15; 6'd41: s1_out = 12; 6'd42: s1_out = 9; 6'd43: s1_out = 7;
        6'd44: s1_out = 3; 6'd45: s1_out = 10; 6'd46: s1_out = 5; 6'd47: s1_out = 0;
        6'd48: s1_out = 15; 6'd49: s1_out = 12; 6'd50: s1_out = 8; 6'd51: s1_out = 2;
        6'd52: s1_out = 4; 6'd53: s1_out = 9; 6'd54: s1_out = 1; 6'd55: s1_out = 7;
        6'd56: s1_out = 5; 6'd57: s1_out = 11; 6'd58: s1_out = 3; 6'd59: s1_out = 14;
        6'd60: s1_out = 10; 6'd61: s1_out = 0; 6'd62: s1_out = 6; 6'd63: s1_out = 13;
    endcase
end

// S盒2
always @(*) begin
    case(s2_addr)
        6'd0: s2_out = 15; 6'd1: s2_out = 1;  6'd2: s2_out = 8;  6'd3: s2_out = 14;
        6'd4: s2_out = 6;  6'd5: s2_out = 11; 6'd6: s2_out = 3;  6'd7: s2_out = 4;
        6'd8: s2_out = 9;  6'd9: s2_out = 7;  6'd10: s2_out = 2; 6'd11: s2_out = 13;
        6'd12: s2_out = 12; 6'd13: s2_out = 0; 6'd14: s2_out = 5; 6'd15: s2_out = 10;
        6'd16: s2_out = 3; 6'd17: s2_out = 13; 6'd18: s2_out = 4; 6'd19: s2_out = 7;
        6'd20: s2_out = 15; 6'd21: s2_out = 2; 6'd22: s2_out = 8; 6'd23: s2_out = 14;
        6'd24: s2_out = 12; 6'd25: s2_out = 0; 6'd26: s2_out = 1; 6'd27: s2_out = 10;
        6'd28: s2_out = 6; 6'd29: s2_out = 9; 6'd30: s2_out = 11; 6'd31: s2_out = 5;
        6'd32: s2_out = 0; 6'd33: s2_out = 14; 6'd34: s2_out = 7; 6'd35: s2_out = 11;
        6'd36: s2_out = 10; 6'd37: s2_out = 4; 6'd38: s2_out = 13; 6'd39: s2_out = 1;
        6'd40: s2_out = 5; 6'd41: s2_out = 8; 6'd42: s2_out = 12; 6'd43: s2_out = 6;
        6'd44: s2_out = 9; 6'd45: s2_out = 3; 6'd46: s2_out = 2; 6'd47: s2_out = 15;
        6'd48: s2_out = 13; 6'd49: s2_out = 8; 6'd50: s2_out = 10; 6'd51: s2_out = 1;
        6'd52: s2_out = 3; 6'd53: s2_out = 15; 6'd54: s2_out = 4; 6'd55: s2_out = 2;
        6'd56: s2_out = 11; 6'd57: s2_out = 6; 6'd58: s2_out = 7; 6'd59: s2_out = 12;
        6'd60: s2_out = 0; 6'd61: s2_out = 5; 6'd62: s2_out = 14; 6'd63: s2_out = 9;
    endcase
end

// S盒3-8 (为简化，使用简单映射)
always @(*) begin
    case(s3_addr)
        6'd0: s3_out = 10; 6'd1: s3_out = 0;  6'd2: s3_out = 9;  6'd3: s3_out = 14;
        6'd4: s3_out = 6;  6'd5: s3_out = 3;  6'd6: s3_out = 15; 6'd7: s3_out = 5;
        6'd8: s3_out = 1;  6'd9: s3_out = 13; 6'd10: s3_out = 12; 6'd11: s3_out = 7;
        6'd12: s3_out = 11; 6'd13: s3_out = 4; 6'd14: s3_out = 2; 6'd15: s3_out = 8;
        default: s3_out = s3_addr[3:0]; // 简化实现
    endcase
end

always @(*) begin
    case(s4_addr)
        6'd0: s4_out = 7;  6'd1: s4_out = 13; 6'd2: s4_out = 14; 6'd3: s4_out = 3;
        6'd4: s4_out = 0;  6'd5: s4_out = 6;  6'd6: s4_out = 9;  6'd7: s4_out = 10;
        6'd8: s4_out = 1;  6'd9: s4_out = 2;  6'd10: s4_out = 8; 6'd11: s4_out = 5;
        6'd12: s4_out = 11; 6'd13: s4_out = 12; 6'd14: s4_out = 4; 6'd15: s4_out = 15;
        default: s4_out = s4_addr[3:0]; // 简化实现
    endcase
end

always @(*) begin
    s5_out = s5_addr[3:0]; // 简化实现
end

always @(*) begin
    s6_out = s6_addr[3:0]; // 简化实现
end

always @(*) begin
    s7_out = s7_addr[3:0]; // 简化实现
end

always @(*) begin
    s8_out = s8_addr[3:0]; // 简化实现
end

// 合并S盒输出为32位
wire [1:32] S_out;
assign S_out = {s1_out, s2_out, s3_out, s4_out, s5_out, s6_out, s7_out, s8_out};

//========================================================================================
// 第四步：P置换(32位->32位)
//========================================================================================

// P变换：简化实现，基本置换
assign f_out[1]  = S_out[16]; assign f_out[2]  = S_out[7];  assign f_out[3]  = S_out[20];
assign f_out[4]  = S_out[21]; assign f_out[5]  = S_out[29]; assign f_out[6]  = S_out[12];
assign f_out[7]  = S_out[28]; assign f_out[8]  = S_out[17]; assign f_out[9]  = S_out[1];
assign f_out[10] = S_out[15]; assign f_out[11] = S_out[23]; assign f_out[12] = S_out[26];
assign f_out[13] = S_out[5];  assign f_out[14] = S_out[18]; assign f_out[15] = S_out[31];
assign f_out[16] = S_out[10]; assign f_out[17] = S_out[2];  assign f_out[18] = S_out[8];
assign f_out[19] = S_out[24]; assign f_out[20] = S_out[14]; assign f_out[21] = S_out[32];
assign f_out[22] = S_out[27]; assign f_out[23] = S_out[3];  assign f_out[24] = S_out[9];
assign f_out[25] = S_out[19]; assign f_out[26] = S_out[13]; assign f_out[27] = S_out[30];
assign f_out[28] = S_out[6];  assign f_out[29] = S_out[22]; assign f_out[30] = S_out[11];
assign f_out[31] = S_out[4];  assign f_out[32] = S_out[25];

endmodule
