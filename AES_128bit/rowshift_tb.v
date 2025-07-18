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
// Last modified Date:     2025/07/18 16:45:00
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/18 16:45:00
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              rowshift_tb.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\rowshift_tb.v
// Descriptions:           AES行移位模块测试文件
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

`timescale 1ns/1ps

module rowshift_tb();

    reg [127:0] aesIn;
    wire [127:0] rowshiftOut;
    
    // 实例化待测试模块
    rowshift uut (
        .aesIn(aesIn),
        .rowshiftOut(rowshiftOut)
    );
    
    // 用于显示矩阵的任务
    task display_matrix;
        input [127:0] data;
        input [8*10:1] name;
        begin
            $display("%s Matrix:", name);
            $display("Row 0: %02h %02h %02h %02h", 
                data[127:120], data[95:88], data[63:56], data[31:24]);
            $display("Row 1: %02h %02h %02h %02h", 
                data[119:112], data[87:80], data[55:48], data[23:16]);
            $display("Row 2: %02h %02h %02h %02h", 
                data[111:104], data[79:72], data[47:40], data[15:8]);
            $display("Row 3: %02h %02h %02h %02h", 
                data[103:96], data[71:64], data[39:32], data[7:0]);
            $display("");
        end
    endtask
    
    initial begin
        $display("AES Row Shift Operation Test");
        $display("=============================");
        
        // 测试用例1：标准测试向量
        // 输入矩阵：
        // 00 04 08 0C
        // 01 05 09 0D  
        // 02 06 0A 0E
        // 03 07 0B 0F
        aesIn = 128'h000102030405060708090A0B0C0D0E0F;
        
        #10; // 等待组合逻辑稳定
        
        display_matrix(aesIn, "Input");
        display_matrix(rowshiftOut, "Output");
        
        // 验证结果
        // 期望输出矩阵应该是：
        // 00 04 08 0C  (第0行不变)
        // 05 09 0D 01  (第1行左移1位)
        // 0A 0E 02 06  (第2行左移2位)
        // 0F 03 07 0B  (第3行左移3位)
        
        // 测试用例2：另一个测试向量
        $display("Test Case 2:");
        $display("=============");
        aesIn = 128'h0123456789ABCDEF0123456789ABCDEF;
        
        #10;
        
        display_matrix(aesIn, "Input");
        display_matrix(rowshiftOut, "Output");
        
        $display("Test completed!");
        $finish;
    end

endmodule
