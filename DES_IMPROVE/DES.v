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
reg [4:0] roundcount; // 轮计数器(0->16)                                                                 
//模块分成四部分，IP置换，密钥生成，16次迭代，反变换输出
//IP置换模块应在接受到start的信号后开始工作，读取输入的明文并进行IP置换
wire [1:64] swapped_ip_data;
assign swapped_ip_data = {
    desIn[58], desIn[50], desIn[42], desIn[34], desIn[26], desIn[18], desIn[10], desIn[2],
    desIn[60], desIn[52], desIn[44], desIn[36], desIn[28], desIn[20], desIn[12], desIn[4],
    desIn[62], desIn[54], desIn[46], desIn[38], desIn[30], desIn[22], desIn[14], desIn[6],
    desIn[64], desIn[56], desIn[48], desIn[40], desIn[32], desIn[24], desIn[16], desIn[8],
    desIn[57], desIn[49], desIn[41], desIn[33], desIn[25], desIn[17], desIn[9], desIn[1],
    desIn[59], desIn[51], desIn[43], desIn[35], desIn[27], desIn[19], desIn[11], desIn[3],
    desIn[61], desIn[53], desIn[45], desIn[37], desIn[29], desIn[21], desIn[13], desIn[5],
    desIn[63], desIn[55], desIn[47], desIn[39], desIn[31], desIn[23], desIn[15], desIn[7]
};  
reg [1:64] des_reg; //寄存器记录明文到密文的寄存器

wire [1:32] Rdatain;
wire [1:32] Ldatain;
assign Rdatain = des_reg[33:64]; //IP置换后明文的右半部分
assign Ldatain = des_reg[1:32]; //IP置换后明文的左半部分
wire [1:48] subkey;
wire [1:32] f_out;

Private_Key_Gen keygen (
    .keyIn(keyIn), //输入的密钥
    .keyid(roundcount+5'b00001), //要输出的key对应的id，范围为1-16
    .subkey(subkey) //输出的子密钥
);
//F函数模块

f_function f (
    .RDatain(Rdatain), //输入的右半部分
    .Keyin(subkey), //输入的子密钥
    .f_out(f_out) //输出的F函数结果
);


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        roundcount <= 5'b00000; //复位轮计数器
        des_reg <= 64'b0; //复位寄存器
        //key_reg <= 64'b0; //复位密钥寄存器
    end
    else if (start) begin
        roundcount <= 5'b00000; //开始时轮计数器从0开始
        //key_reg <= keyIn; //将输入的密钥存入寄存器
        des_reg <= swapped_ip_data; //将IP置换后的明文存入寄存器
    end//以下仅在start信号为低和rst为高时执行
    else if (roundcount < 5'b01111) begin //轮计数器小于15时继续迭代
        des_reg <= {Rdatain, Ldatain ^ f_out}; //更新寄存器，左半部分和F函数结果异或后作为新的右半部分
        roundcount <= roundcount + 1; //轮计数器加1
    end
    else if (roundcount == 5'b01111) begin //轮计数器等于15时，表示迭代16次完成
        des_reg <= {Ldatain ^ f_out,Rdatain}; //最后一次迭代后更新寄存器{R16,L16}
        roundcount <= 5'b10000; //输出ready的信号
    end
end


/*
//写一个时钟控制的迭代过程
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        des_reg <= 64'b0; //复位寄存器
        key_reg <= 64'b0; //复位密钥寄存器
    end
    else begin
        if (roundcount < 4'b1111) begin //轮计数器小于15时继续迭代
            des_reg <= {Rdatain, Ldatain ^ f_out}; //更新寄存器，左半部分和F函数结果异或后作为新的右半部分
        end
        else if (roundcount == 4'b1111) begin //轮计数器等于15时，表示迭代完成
            des_reg <= {Ldatain ^ f_out,Rdatain}; //最后一次迭代后更新寄存器{R16,L16}
        end
    end
end
*/
assign ready = (roundcount == 5'b10000); //当轮计数器等于15时，表示迭代完成，ready信号为高
//反IP置换模块
assign desOut = {
    des_reg[40], des_reg[8], des_reg[48], des_reg[16],
    des_reg[56], des_reg[24], des_reg[64], des_reg[32],
    des_reg[39], des_reg[7], des_reg[47], des_reg[15],
    des_reg[55], des_reg[23], des_reg[63], des_reg[31],
    des_reg[38], des_reg[6], des_reg[46], des_reg[14],
    des_reg[54], des_reg[22], des_reg[62], des_reg[30],
    des_reg[37], des_reg[5], des_reg[45], des_reg[13],
    des_reg[53], des_reg[21], des_reg[61], des_reg[29],
    des_reg[36], des_reg[4], des_reg[44], des_reg[12],
    des_reg[52], des_reg[20], des_reg[60], des_reg[28],
    des_reg[35], des_reg[3], des_reg[43], des_reg[11],
    des_reg[51], des_reg[19], des_reg[59], des_reg[27],
    des_reg[34], des_reg[2], des_reg[42], des_reg[10],
    des_reg[50], des_reg[18], des_reg[58], des_reg[26],
    des_reg[33], des_reg[1], des_reg[41], des_reg[9],
    des_reg[49], des_reg[17], des_reg[57], des_reg[25]
}; //反IP置换后的密文输出






endmodule