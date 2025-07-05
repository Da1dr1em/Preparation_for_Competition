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
// Last modified Date:     2025/07/05 13:38:38
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/05 13:38:38
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              left_loop.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\left_loop.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//本模块功能是在接受C0、D0输入的前提下按照要求的keyid实现循环左移
module left_loop(
    input                               clk                        ,
    input                               rst_n,
    input reg [1:28] C0,D0,
    input [5:0] keyid, //要求生成的私钥ID(1~16)
    output reg [1:28] Ci,Di                      
);
reg [1:0] left_shift_count[0:16];
reg [1:28] Ctemp,Dtemp;
initial begin
    left_shift_count[0] = 2'b00; //不左移,赋初值
    left_shift_count[1] = 2'b01; //左移1位
    left_shift_count[2] = 2'b01; //左移1位
    left_shift_count[3] = 2'b10; //左移2位
    left_shift_count[4] = 2'b10; //左移1位
    left_shift_count[5] = 2'b10; //左移1位
    left_shift_count[6] = 2'b10; //左移2位
    left_shift_count[7] = 2'b10; //左移1位
    left_shift_count[8] = 2'b10; //左移1位
    left_shift_count[9] = 2'b01; //左移2位
    left_shift_count[10] = 2'b10; //左移1位
    left_shift_count[11] = 2'b10; //左移1位
    left_shift_count[12] = 2'b10; //左移2位
    left_shift_count[13] = 2'b10; //左移1位
    left_shift_count[14] = 2'b10; //左移1位
    left_shift_count[15] = 2'b10; //左移2位
    left_shift_count[16] = 2'b01; //左移1位
end
reg left_shift_count_total [5:0];
genvar i;
generate
    for (i = 0; i <= 16; i = i + 1) begin : left_shift_loop
    //实现循环左移，按照left_shift_count[i]的值确定左移的位数
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                Ci <= 0;
                Di <= 0;
            end else if (i <= keyid) begin
                if (left_shift_count[i] == 0) begin
                    Ctemp <= C0;
                    Dtemp <= D0;
                end
                else if (left_shift_count[i] == 2'b01) begin
                    //则循环左移一位
                    Ctemp <= {Ctemp[2:28],Ctemp[1]};
                    Dtemp <= {Dtemp[2:28],Dtemp[1]};
                end
                else if (left_shift_count[i] == 2'b10) begin
                    //循环左移二位
                    Ctemp <= {Ctemp[3:28],Ctemp[1:2]};
                    Dtemp <= {Dtemp[3:28],Dtemp[1:2]};
                end
                else  ;//不做任何操作
            end 
        end
    end                                        
endgenerate
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Ci <= 0;
        Di <= 0;
    end else if (keyid > 0 && keyid <= 16) begin
        Ci <= Ctemp;
        Di <= Dtemp;
    end else begin
        Ci <= 0; //如果keyid不在1~16范围内，输出为0
        Di <= 0;
    end
end
                                                                   
endmodule