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
reg [1:128] key_reg; //寄存器记录密钥到轮密钥的寄存器
wire [1:8] statusMatrix [1:16];
wire [1:128] ByteTransOut; //字节代换的输出
wire [1:128] aesregsignal; //寄存器的输出信号
wire [1:128] keyregsignal; //轮密钥的输出信号
wire [1:128] keyupdatesignal; //轮密钥的输出信号
reg [3:0] roundcount; //轮计数器

wire [1:128] rowshiftOut; //行移位的输出
wire [1:128] MixColumnOut; //列混合的输出

assign aesregsignal = aes_reg; //将寄存器的输出信号赋值给wire
assign keyregsignal = key_reg; //将轮密钥的输出信号赋值给wire
    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n) begin                              
                aes_reg <= 128'b0; //复位时清空寄存器
                key_reg <= 128'b0; //复位时清空密钥寄存器
                roundcount <= 4'b0; //复位时清空轮计数器
            end
            else if(start) begin
                aes_reg <= aesIn; //开始时将输入的明文赋值给寄存器
                key_reg <= keyIn; //将输入的密钥赋值给轮密钥寄存器
                roundcount <= 4'b0; //轮计数器归零
            end
            else if (roundcount==4'b0) begin //明文输入之后先仅进行轮密钥加
                aes_reg <= aesregsignal^keyregsignal; //轮密钥加
                roundcount <= roundcount + 1; //轮计数器加1
                //补充key的更新逻辑
                key_reg <= keyupdatesignal; //更新轮密钥
            end
            else if(roundcount<4'b1010) begin //第1到第九轮应顺序完成：字节代换，行移位，列混合，轮密钥加
                aes_reg <= MixColumnOut^keyregsignal; //轮密钥加
                roundcount <= roundcount + 1; //轮计数器加1
                key_reg <= keyupdatesignal; //更新轮密钥
            end    
            else if(roundcount==4'b1010) begin
                aes_reg <= rowshiftOut^keyregsignal; //轮密钥加
                roundcount <= 4'b1011; //进入输出ready的状态
            end
                
        end                                          
assign ready = (roundcount==4'b1011)?1:0; //当轮计数器为1011时，表示AES加密完成
//进行字节代换
Byte_transform Byte_transform_inst (
    .aesIn(aesregsignal), //输入的128位明文
    .ByteTransOut(ByteTransOut) //输出的128位代换后的结果
);
rowshift rowshift_inst (
    .aesIn(ByteTransOut), //输入的128位代换后的结果
    .rowshiftOut(rowshiftOut) //输出的128位行移位后的结果
);
column_mix column_mix_inst (
    .messagein(rowshiftOut), //输入的128位行移位后的结果
    .messageout(MixColumnOut) //输出的128位列混合后的结果
);
RoundKeyGen RoundKeyGen_inst (
    .keyin(keyregsignal), //输入的轮密钥
    .round(roundcount+4'b0001), //下一轮轮数，由于非阻塞赋值的性质，要求本轮生成下一轮的密钥，否则下一轮会出错
    .nextkey(keyupdatesignal) //输出的下一轮密钥
);
                                                                   
endmodule