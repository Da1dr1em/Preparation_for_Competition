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
// Last modified Date:     2025/07/14 15:18:41
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/14 15:18:41
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              IP.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\IP.v
// Descriptions:           
// 使用组合逻辑实现IP置换，避免使用寄存器存储中间结果，是否输出由上级模块决定                        
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module IP(
    input [1:64] desin,
    output [1:64] swapped_ip_data
);
//本模块仅通过组合逻辑实现IP置换
assign swapped_ip_data = {
    desin[58], desin[50], desin[42], desin[34], desin[26], desin[18], desin[10], desin[2],
    desin[60], desin[52], desin[44], desin[36], desin[28], desin[20], desin[12], desin[4],
    desin[62], desin[54], desin[46], desin[38], desin[30], desin[22], desin[14], desin[6],
    desin[64], desin[56], desin[48], desin[40], desin[32], desin[24], desin[16], desin[8],
    desin[57], desin[49], desin[41], desin[33], desin[25], desin[17], desin[9], desin[1],
    desin[59], desin[51], desin[43], desin[35], desin[27], desin[19], desin[11], desin[3],
    desin[61], desin[53], desin[45], desin[37], desin[29], desin[21], desin[13], desin[5],
    desin[63], desin[55], desin[47], desin[39], desin[31], desin[23], desin[15], desin[7]
};                                                                   
endmodule