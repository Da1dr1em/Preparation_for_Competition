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
// Last modified Date:     2025/07/18 09:50:31
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/18 09:50:31
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              AES.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\AES.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module AES(
    input [1:128] aesIn,keyIn,
    input clk,rst_n,start,
    output ready,
    output [1:128] aesOut                    
);
//传入的128位明文其实就已经是状态矩阵1了，但是要先把它写成矩阵的形式
//二维数组不好赋值，先把它当成一维编写
reg [1:128] aes_reg; //寄存器记录明文到密文的寄存器
wire [1:8] statusMatrix [1:16];
wire [1:128] ByteTransOut; //字节代换的输出
wire [1:128] aesregsignal; //寄存器的输出信号



genvar i;
generate
    for (i = 1;i < 17 ;i=i+1) begin
    assign statusMatrix[i] = aes_reg[8*i-7:8*i];
end
endgenerate
assign aesregsignal = aes_reg; //将寄存器的输出信号赋值给aesOut
    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n)                               
                aes_reg <= 128'b0; //复位时清空寄存器
            else if(start) begin
                aes_reg <= aesIn; //开始时将输入的明文赋值给寄存器
            end
            else if(ready) begin //如果ready信号为高，表示处理完成
                aes_reg <= aesOut; //将输出的密文赋值给寄存器
            end                                                                    
        end                                          
//进行字节代换
Byte_transform Byte_transform_inst (
    .aesIn(aesregsignal), //输入的128位明文
    .ByteTransOut(ByteTransOut) //输出的128位代换后的结果
);

                                                                   
endmodule