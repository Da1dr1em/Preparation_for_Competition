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
    input clk,
    input rst_n,
    input [1:28] C0,D0,
    input [5:0] keyid, //要求生成的私钥ID(1~16)
    output reg [1:28] Ci,Di                      
);

// DES标准的左移位数表
reg [1:0] left_shift_count[1:16];
initial begin
    left_shift_count[1] = 2'b01;  //左移1位
    left_shift_count[2] = 2'b01;  //左移1位
    left_shift_count[3] = 2'b10;  //左移2位
    left_shift_count[4] = 2'b10;  //左移2位
    left_shift_count[5] = 2'b10;  //左移2位
    left_shift_count[6] = 2'b10;  //左移2位
    left_shift_count[7] = 2'b10;  //左移2位
    left_shift_count[8] = 2'b10;  //左移2位
    left_shift_count[9] = 2'b01;  //左移1位
    left_shift_count[10] = 2'b10; //左移2位
    left_shift_count[11] = 2'b10; //左移2位
    left_shift_count[12] = 2'b10; //左移2位
    left_shift_count[13] = 2'b10; //左移2位
    left_shift_count[14] = 2'b10; //左移2位
    left_shift_count[15] = 2'b10; //左移2位
    left_shift_count[16] = 2'b01; //左移1位
end

// 累积左移逻辑
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Ci <= 28'b0;
        Di <= 28'b0;
    end else begin
        if (keyid >= 1 && keyid <= 16) begin
            // 根据keyid累积计算总的左移位数
            case (keyid)
                1: begin  // 第1轮，左移1位
                    Ci <= {C0[2:28], C0[1]};
                    Di <= {D0[2:28], D0[1]};
                end
                2: begin  // 第2轮，累积左移2位
                    Ci <= {C0[3:28], C0[1:2]};
                    Di <= {D0[3:28], D0[1:2]};
                end
                3: begin  // 第3轮，累积左移4位
                    Ci <= {C0[5:28], C0[1:4]};
                    Di <= {D0[5:28], D0[1:4]};
                end
                4: begin  // 第4轮，累积左移6位
                    Ci <= {C0[7:28], C0[1:6]};
                    Di <= {D0[7:28], D0[1:6]};
                end
                5: begin  // 第5轮，累积左移8位
                    Ci <= {C0[9:28], C0[1:8]};
                    Di <= {D0[9:28], D0[1:8]};
                end
                6: begin  // 第6轮，累积左移10位
                    Ci <= {C0[11:28], C0[1:10]};
                    Di <= {D0[11:28], D0[1:10]};
                end
                7: begin  // 第7轮，累积左移12位
                    Ci <= {C0[13:28], C0[1:12]};
                    Di <= {D0[13:28], D0[1:12]};
                end
                8: begin  // 第8轮，累积左移14位
                    Ci <= {C0[15:28], C0[1:14]};
                    Di <= {D0[15:28], D0[1:14]};
                end
                9: begin  // 第9轮，累积左移15位
                    Ci <= {C0[16:28], C0[1:15]};
                    Di <= {D0[16:28], D0[1:15]};
                end
                10: begin  // 第10轮，累积左移17位
                    Ci <= {C0[18:28], C0[1:17]};
                    Di <= {D0[18:28], D0[1:17]};
                end
                11: begin  // 第11轮，累积左移19位
                    Ci <= {C0[20:28], C0[1:19]};
                    Di <= {D0[20:28], D0[1:19]};
                end
                12: begin  // 第12轮，累积左移21位
                    Ci <= {C0[22:28], C0[1:21]};
                    Di <= {D0[22:28], D0[1:21]};
                end
                13: begin  // 第13轮，累积左移23位
                    Ci <= {C0[24:28], C0[1:23]};
                    Di <= {D0[24:28], D0[1:23]};
                end
                14: begin  // 第14轮，累积左移25位
                    Ci <= {C0[26:28], C0[1:25]};
                    Di <= {D0[26:28], D0[1:25]};
                end
                15: begin  // 第15轮，累积左移27位
                    Ci <= {C0[28], C0[1:27]};
                    Di <= {D0[28], D0[1:27]};
                end
                16: begin  // 第16轮，累积左移28位（等于不移位）
                    Ci <= C0;
                    Di <= D0;
                end
                default: begin
                    Ci <= 28'b0;
                    Di <= 28'b0;
                end
            endcase
        end else begin
            Ci <= 28'b0;
            Di <= 28'b0;
        end
    end
end
                                                                   
endmodule