//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-3.8.20250805
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2025/08/12 10:32:19
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/08/12 10:32:19
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              RGB_to_YUV.v
// PATH:                   D:\Working\Preparation_for_Competition\DSC\DSC_Encode\RGB_to_YUV.v
// Descriptions:           
//这个模块是为了实现屏幕空间色彩转换，将RGB颜色空间转换为YUV(Y\Co\Cg)颜色空间                         
//----------------------------------------------------------------------------------------
//****************************************************************************************/dev/
//对于一个像素而言，24位-》8位R、G、B之和
//本模块是为了实现单个像素的转换
//已完成仿真验证
module YCoCgR(
    input [1:8] din_data_R,din_data_G,din_data_B,
    output [1:8] Y_data,
    output [1:9] Co_data,Cg_data
);
//按照公式对RGB进行处理
//不太清楚是否要加offset，也就是(1<<bits_per_component)的偏移,之后再说

localparam bits_per_component = 8;
wire [1:9] cscCo,cscCg,t;

assign cscCo = din_data_R - din_data_B; //
assign t = din_data_B+(cscCo>>1); //
assign cscCg = din_data_G - t; // 
assign Y_data = t + (cscCg>>1); //
assign Co_data = cscCo+(1<<bits_per_component);//将1左移8位(乘2的8次方)
assign Cg_data = cscCg+(1<<bits_per_component);

                                                                   
                                                                   
endmodule
