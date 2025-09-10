//本模块是存储模块，目的是存储经过色彩空间转换后的图像，并向预测模块发送数据
//以三个像素为一组进行存储，使用 2 个宽度为 78 比特，深度为 640 的 RAM作为存储中介。
//则本模块的存储结构是26*3=78，即一行3个像素
//640列*3  = 1980，即一个RAM存储1980个像素，代表1980*1080图像的一行
//存储两个RAM交替使用，方便于上一行给下一行预测提供参考并进行预测
//当然，还需要对第一组、第一行等特殊情况分别标识出标志信号进行输出
//所以需要对色彩空间转换的模块进行一定的修改，让它能够做到输出标志信号
`timescale 1ns / 1ps
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
// Last modified Date:     2025/09/02 10:30:21
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/09/02 10:30:21
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Data_buffer.v
// PATH:                   D:\Working\Preparation_for_Competition\DSC\DSC_Encode\Data_buffer.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Data_buffer(
    input                               clk                        ,
    input                               rst_n,
    input                               ram_enable,
    input      [1:24]                  din_data_Y                 ,
    input      [1:27]                  din_data_Co                ,
    input      [1:27]                  din_data_Cg                ,
    input [1:10] pixel_groupcount, //像素组计数器,可以计数2^10 * 3 = 3072 > 1980，可以计算行内像素组总数
    input [1:11] line_count, //行计数器，可以计数2^11 = 2048 > 1080，可以计算图像总行数
    output [1:48]               prevline_Ydata_6P          ,//发送给pmode模块的上一行Y像素的重建值
    output [1:54]               prevline_Codata_6P         ,
    output [1:54]               prevline_Cgdata_6P         ,
    output [1:56]               prevline_Ydata_ICH,//发送给ICH模块的上一行Y像素的重建值
    output [1:63]               prevline_Codata_ICH,
    output [1:63]               prevline_Cgdata_ICH      
);
                                                                   
                                                                   
endmodule