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
// Last modified Date:     2025/09/01 16:14:14
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/09/01 16:14:14
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              P-mode.v
// PATH:                   D:\Working\Preparation_for_Competition\DSC\DSC_Encode\P-mode.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Pmode(
    input clk,
    input rst_n,
    input slice_int, //图像片段第一组信号
    input first_line_flag,//图像片段第一行信号
    input lin_first_group,//图像每行第一组信号
    input pred_start_i,//
    input forceMPP,//中点预测模式使用信号,值为1时使用
    input [1:4] qp,//量化参数
//下方为原始像素值    
    input [1:24] Y_data_ori,
    input [1:27] Co_data_ori,Cg_data_ori,

    input [1:48] prevline_Ydata_6P,
    input [1:54] prevline_Codata_6P,prevline_Cgdata_6P,
//下方为重建像素值
    input [1:24] recon_data_Y,
    input [1:27] recon_data_Co,recon_data_Cg,
    
    input [1:4] min_vector_o,//最小残差向量

    output recon_done_o,//预测结束信号
//量化残差值
    output [1:33] Y_err_q_o,
    output [1:33] Co_err_q_o,Cg_err_q_o,

    output [1:4] Y_max_size_o,
    output [1:4] Co_max_size_o,Cg_max_size_o,

    output [1:12] size_e_Y,size_e_Co,size_e_Cg,

    output [1:4] MMAP_Y_max_size,MMAP_Co_max_size,MMAP_Cg_max_size,
//P-mode的最大误差
    output [1:8] Y_max_err_p_mode,
    output [1:9] Co_max_err_p_mode,Cg_max_err_p_mode,

    output [1:24] Pmode_Y_recon,
    output [1:27] Pmode_Co_recon,Pmode_Cg_recon                      
);
//P-mode 模块处理像素的过程中首先进行的是预测量化，然后是模式选择，最后是重建                                                                  
                                                                   




endmodule