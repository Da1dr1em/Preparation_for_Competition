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
// Last modified Date:     2025/09/01 16:00:15
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/09/01 16:00:15
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              sanxiangsu.v
// PATH:                   D:\Working\Preparation_for_Competition\DSC\DSC_Encode\sanxiangsu.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//一次处理三个像素，像素的RGB构成为{P2,P1,P0}
module sanxiangsu(
    input                               clk                        ,
    input                               rst_n                      ,
    input [1:24] din_data_R,din_data_G,din_data_B,
    output [1:24] Y_data,
    output [1:27] Co_data,Cg_data                    
);
YCoCgR u_YCoCgR_bit1(
    .clk        (clk            ),
    .rst_n      (rst_n          ),
    .din_data_R (din_data_R[1:8]),
    .din_data_G (din_data_G[1:8]),
    .din_data_B (din_data_B[1:8]),
    .Y_data     (Y_data[1:8]    ),
    .Co_data    (Co_data[1:9]   ),
    .Cg_data    (Cg_data[1:9]   )
);
YCoCgR u_YCoCgR_bit2(
    .clk        (clk            ),
    .rst_n      (rst_n          ),
    .din_data_R (din_data_R[9:16]),
    .din_data_G (din_data_G[9:16]),
    .din_data_B (din_data_B[9:16]),
    .Y_data     (Y_data[9:16]    ),
    .Co_data    (Co_data[10:18]   ),
    .Cg_data    (Cg_data[10:18]   )
);
YCoCgR u_YCoCgR_bit3(
    .clk        (clk            ),
    .rst_n      (rst_n          ),
    .din_data_R (din_data_R[17:24]),
    .din_data_G (din_data_G[17:24]),
    .din_data_B (din_data_B[17:24]),
    .Y_data     (Y_data[17:24]    ),
    .Co_data    (Co_data[19:27]   ),
    .Cg_data    (Cg_data[19:27]   )
);


                                                                   
endmodule