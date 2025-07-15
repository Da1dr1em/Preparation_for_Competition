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
// Last modified Date:     2025/07/14 15:16:24
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/14 15:16:24
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              DES.v
// PATH:                   D:\Working\Preparation_for_Competition\DES_IMPROVE\DES.v
// Descriptions:           
// A way to improve the DES algorithm implementation in Verilog                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module DES(
    input clk,rst_n,start,
    input [1:64] desIn,keyIn, //输入的明文和密钥 
    output ready,
    output [1:64] desOut                   
);
reg [3:0] roundcount; // 轮计数器(0->16)                                                                 
//模块分成四部分，IP置换，密钥生成，16次迭代，反变换输出
//IP置换模块应在接受到start的信号后开始工作，读取输入的明文并进行IP置换
wire [1:64] swapped_ip_data;
IP ip (
    .desin(desIn),
    .swapped_ip_data(swapped_ip_data)
);
//不对，按照DES的迭代过程来讲，其实用寄存器记录置换后的明文和密钥，然后在明文进行迭代时保证密钥保存的是当前轮需要的子密钥即可
//所以生成密钥的逻辑可以改一下，用寄存器记录密钥，然后在这个寄存器上迭代得到各个轮数的密钥即可
reg [1:64] key_reg; //寄存器记录密钥(公钥到各轮私钥)
reg [1:64] des_reg; //寄存器记录明文到密文的寄存器
always @(negedge rst_n) begin
    if (!rst_n) begin
        roundcount <= 4'b0000; //复位轮计数器
    end
end









endmodule