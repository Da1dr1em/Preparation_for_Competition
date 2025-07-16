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
// Last modified Date:     2025/07/14 15:35:00
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/14 15:35:00
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Private_Key_Gen.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\Private_Key_Gen.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//本模块也为纯组合逻辑，输入有公钥和轮数，输出子钥
module Private_Key_Gen(
    input [1:64] keyIn, //输入的密钥
    input [4:0] keyid, //要输出的key对应的id，范围为1-16
    output [1:48] subkey //输出的子密钥                  
);
//首先完成密钥的置换A
wire [1:56] key_permuted;                                                                   
assign key_permuted = {keyIn[57], keyIn[49], keyIn[41], keyIn[33], keyIn[25], keyIn[17], keyIn[9], 
                      keyIn[1],keyIn[58], keyIn[50], keyIn[42], keyIn[34], keyIn[26], keyIn[18],
                      keyIn[10],keyIn[2], keyIn[59], keyIn[51], keyIn[43], keyIn[35], keyIn[27],
                      keyIn[19], keyIn[11], keyIn[3],keyIn[60], keyIn[52], keyIn[44], keyIn[36],
                      keyIn[63], keyIn[55], keyIn[47], keyIn[39], keyIn[31], keyIn[23], keyIn[15], 
                      keyIn[7], keyIn[62], keyIn[54], keyIn[46], keyIn[38],keyIn[30], keyIn[22],
                      keyIn[14], keyIn[6], keyIn[61], keyIn[53], keyIn[45], keyIn[37],keyIn[29],
                      keyIn[21],keyIn[13],keyIn[5] ,keyIn[28],keyIn[20] ,keyIn[12],   keyIn[4]
                      };
wire [1:28] left_key, right_key; //分为左半部分和右半部分
assign left_key = key_permuted[1:28]; //左半部分
assign right_key = key_permuted[29:56]; //右半部分
//一次性把所有轮密钥都生成了
wire [1:28] left_key_shifted[1:16], right_key_shifted[1:16];
assign left_key_shifted[1] = {left_key[2:28], left_key[1]};
assign right_key_shifted[1] = {right_key[2:28], right_key[1]};
assign left_key_shifted[2] = {left_key[3:28], left_key[1:2]};
assign right_key_shifted[2] = {right_key[3:28], right_key[1:2]};
assign left_key_shifted[3] = {left_key[5:28], left_key[1:4]};
assign right_key_shifted[3] = {right_key[5:28], right_key[1:4]};
assign left_key_shifted[4] = {left_key[7:28], left_key[1:6]};
assign right_key_shifted[4] = {right_key[7:28], right_key[1:6]};
assign left_key_shifted[5] = {left_key[9:28], left_key[1:8]};
assign right_key_shifted[5] = {right_key[9:28], right_key[1:8]};
assign left_key_shifted[6] = {left_key[11:28], left_key[1:10]};
assign right_key_shifted[6] = {right_key[11:28], right_key[1:10]};
assign left_key_shifted[7] = {left_key[13:28], left_key[1:12]};
assign right_key_shifted[7] = {right_key[13:28], right_key[1:12]};
assign left_key_shifted[8] = {left_key[15:28], left_key[1:14]};
assign right_key_shifted[8] = {right_key[15:28], right_key[1:14]};
assign left_key_shifted[9] = {left_key[16:28], left_key[1:15]};
assign right_key_shifted[9] = {right_key[16:28], right_key[1:15]};
assign left_key_shifted[10] = {left_key[18:28], left_key[1:17]};
assign right_key_shifted[10] = {right_key[18:28], right_key[1:17]};
assign left_key_shifted[11] = {left_key[20:28], left_key[1:19]};
assign right_key_shifted[11] = {right_key[20:28], right_key[1:19]};
assign left_key_shifted[12] = {left_key[22:28], left_key[1:21]};
assign right_key_shifted[12] = {right_key[22:28], right_key[1:21]};
assign left_key_shifted[13] = {left_key[24:28], left_key[1:23]};
assign right_key_shifted[13] = {right_key[24:28], right_key[1:23]};
assign left_key_shifted[14] = {left_key[26:28], left_key[1:25]};
assign right_key_shifted[14] = {right_key[26:28], right_key[1:25]};
assign left_key_shifted[15] = {left_key[28:28], left_key[1:27]};
assign right_key_shifted[15] = {right_key[28:28], right_key[1:27]};
assign left_key_shifted[16] = left_key;
assign right_key_shifted[16] = right_key;                               

wire [1:56] CDcombined;
assign CDcombined = {
    left_key_shifted[keyid][1:28], right_key_shifted[keyid][1:28]
};
//密钥置换B
assign subkey = {
    CDcombined[14], CDcombined[17], CDcombined[11], CDcombined[24],
    CDcombined[1], CDcombined[5], CDcombined[3], CDcombined[28],
    CDcombined[15], CDcombined[6], CDcombined[21], CDcombined[10],
    CDcombined[23], CDcombined[19], CDcombined[12], CDcombined[4],
    CDcombined[26], CDcombined[8], CDcombined[16], CDcombined[7],
    CDcombined[27], CDcombined[20], CDcombined[13], CDcombined[2],
    CDcombined[41], CDcombined[52], CDcombined[31], CDcombined[37],
    CDcombined[47], CDcombined[55], CDcombined[30], CDcombined[40],
    CDcombined[51], CDcombined[45], CDcombined[33], CDcombined[48],
    CDcombined[44], CDcombined[49], CDcombined[39], CDcombined[56],
    CDcombined[34], CDcombined[53], CDcombined[46], CDcombined[42],
    CDcombined[50], CDcombined[36], CDcombined[29], CDcombined[32]
};


endmodule