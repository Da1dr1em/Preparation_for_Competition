//***********************module des_comb_tb

//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-3.6.20250620
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              des_comb_tb.v
// Last modified Date:     2025/01/17 
// Last Version:           V1.0
// Descriptions:           DES组合逻辑模块测试台
//----------------------------------------------------------------------------------------
// Created by:             GitHub Copilot 
// Created date:           2025/01/17
// Version:                V1.0
// TEXT NAME:              des_comb_tb.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\des_comb_tb.v
// Descriptions:           测试des_comb模块的功能和时序
//----------------------------------------------------------------------------------------
//****************************************************************************************//

`timescale 1ns/1ps

module des_comb_tb();

// 时钟和复位信号
reg clk;
reg rst_n;

// DES输入信号
reg start;
reg [1:64] desIn;
reg [1:64] keyIn;

// DES输出信号
wire ready;
wire [1:64] desOut;

// 实例化被测模块
des_comb dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .desIn(desIn),
    .keyIn(keyIn),
    .ready(ready),
    .desOut(desOut)
);

// 时钟生成
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns周期，100MHz时钟
end

// 测试向量
initial begin
    // 初始化信号
    rst_n = 0;
    start = 0;
    desIn = 64'h0;
    keyIn = 64'h0;
    
    // 复位
    #20 rst_n = 1;
    #10;
    
    $display("=== DES组合逻辑模块测试开始 ===");
    $display("时间: %0t", $time);
    
    // 测试用例1：标准DES测试向量
    $display("\n--- 测试用例1: 标准DES测试向量 ---");
    desIn = 64'h0123456789ABCDEF; // 明文
    keyIn = 64'h133457799BBCDFF1; // 密钥
    
    $display("输入明文: %h", desIn);
    $display("输入密钥: %h", keyIn);
    
    // 启动加密
    start = 1;
    #10 start = 0;
    
    // 等待完成
    wait(ready);
    #10;
    
    $display("输出密文: %h", desOut);
    $display("加密完成时间: %0t", $time);
    
    // 预期结果：85E813540F0AB405
    if (desOut == 64'h85E813540F0AB405) begin
        $display("✓ 测试用例1 通过");
    end else begin
        $display("✗ 测试用例1 失败，预期: 85E813540F0AB405，实际: %h", desOut);
    end
    
    #50;
    
    // 测试用例2：全0测试
    $display("\n--- 测试用例2: 全0输入测试 ---");
    desIn = 64'h0000000000000000;
    keyIn = 64'h0000000000000000;
    
    $display("输入明文: %h", desIn);
    $display("输入密钥: %h", keyIn);
    
    start = 1;
    #10 start = 0;
    
    wait(ready);
    #10;
    
    $display("输出密文: %h", desOut);
    
    #50;
    
    // 测试用例3：全1测试
    $display("\n--- 测试用例3: 全1输入测试 ---");
    desIn = 64'hFFFFFFFFFFFFFFFF;
    keyIn = 64'hFFFFFFFFFFFFFFFF;
    
    $display("输入明文: %h", desIn);
    $display("输入密钥: %h", keyIn);
    
    start = 1;
    #10 start = 0;
    
    wait(ready);
    #10;
    
    $display("输出密文: %h", desOut);
    
    #50;
    
    // 测试用例4：连续多次加密测试
    $display("\n--- 测试用例4: 连续加密测试 ---");
    
    // 第1次加密
    desIn = 64'h0123456789ABCDEF;
    keyIn = 64'h133457799BBCDFF1;
    
    $display("第1次加密，明文: %h，密钥: %h", desIn, keyIn);
    
    start = 1;
    #10 start = 0;
    
    wait(ready);
    #10;
    
    $display("第1次加密结果: %h", desOut);
    #30;
    
    // 第2次加密
    desIn = 64'h0123456789ABCDF0;
    keyIn = 64'h133457799BBCDFF2;
    
    $display("第2次加密，明文: %h，密钥: %h", desIn, keyIn);
    
    start = 1;
    #10 start = 0;
    
    wait(ready);
    #10;
    
    $display("第2次加密结果: %h", desOut);
    #30;
    
    // 第3次加密
    desIn = 64'h0123456789ABCDF1;
    keyIn = 64'h133457799BBCDFF3;
    
    $display("第3次加密，明文: %h，密钥: %h", desIn, keyIn);
    
    start = 1;
    #10 start = 0;
    
    wait(ready);
    #10;
    
    $display("第3次加密结果: %h", desOut);
    #30;
    
    $display("\n=== 测试完成 ===");
    $display("总测试时间: %0t", $time);
    
    #100;
    $finish;
end

// 监控信号变化
initial begin
    $monitor("时间=%0t, rst_n=%b, start=%b, ready=%b, desOut=%h", 
             $time, rst_n, start, ready, desOut);
end

// 生成波形文件
initial begin
    $dumpfile("des_comb_tb.vcd");
    $dumpvars(0, des_comb_tb);
end

endmodule
