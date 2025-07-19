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
// Last modified Date:     2025/07/19 15:30:00
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/19 15:30:00
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              RoundKeyGen_tb.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\RoundKeyGen_tb.v
// Descriptions:           AES轮密钥生成模块测试文件
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

`timescale 1ns/1ps

module RoundKeyGen_tb();

    reg [1:128] keyin;
    reg [3:0] round;
    wire [1:128] nextkey;
    
    // 期望结果的寄存器
    reg [1:128] expected1;
    integer i, j;
    
    // 实例化待测试模块
    RoundKeyGen uut (
        .keyin(keyin),
        .round(round),
        .nextkey(nextkey)
    );
    
    // 用于显示密钥的任务
    task display_key;
        input [1:128] key;
        input [8*15:1] name;
        begin
            $display("%s:", name);
            $display("W[0] = %08h", key[1:32]);
            $display("W[1] = %08h", key[33:64]);
            $display("W[2] = %08h", key[65:96]);
            $display("W[3] = %08h", key[97:128]);
            $display("Full Key = %032h", key);
            $display("");
        end
    endtask
    
    // 验证结果的任务
    task verify_result;
        input [1:128] expected;
        input [8*20:1] test_name;
        begin
            if (nextkey == expected) begin
                $display("PASS: %s", test_name);
            end else begin
                $display("FAIL: %s", test_name);
                $display("Expected:");
                display_key(expected, "Expected Key");
                $display("Got:");
                display_key(nextkey, "Actual Key");
            end
        end
    endtask
    
    initial begin
        $display("AES Round Key Generation Test");
        $display("=============================");
        
        // 测试用例1：使用README中的例子
        // 初始密钥：3C A1 0B 21 57 F0 19 16 90 2E 13 80 AC C1 07 BD
        // W[0] = 3C A1 0B 21
        // W[1] = 57 F0 19 16  
        // W[2] = 90 2E 13 80
        // W[3] = AC C1 07 BD
        
        keyin = {32'h3CA10B21, 32'h57F01916, 32'h902E1380, 32'hACC107BD};
        round = 4'b0001; // 第1轮
        
        #10; // 等待组合逻辑稳定
        
        $display("Test Case 1: README Example - Round 1");
        $display("=====================================");
        display_key(keyin, "Input Key");
        display_key(nextkey, "Output Key");
        
        // 根据README计算的期望结果：
        // W[4] = 45 64 71 B0
        // W[5] = 12 94 68 A6  
        // W[6] = 82 BA 7B 26
        // W[7] = 2E 7B 7C 9B
        
        expected1 = {32'h456471B0, 32'h129468A6, 32'h82BA7B26, 32'h2E7B7C9B};
        
        verify_result(expected1, "README Example Round 1");
        
        $display("");
        
        // 测试用例2：继续第2轮（使用第1轮的输出作为输入）
        $display("Test Case 2: Round 2 (using Round 1 output)");
        $display("============================================");
        
        keyin = nextkey; // 使用第1轮的输出
        round = 4'b0010; // 第2轮
        
        #10;
        
        display_key(keyin, "Input Key");
        display_key(nextkey, "Output Key");
        
        $display("Round 2 Test - Manual verification needed");
        
        $display("");
        
        // 测试用例3：测试不同轮数的轮常量
        $display("Test Case 3: Different Round Constants");
        $display("======================================");
        
        // 使用一个简单的测试密钥
        keyin = {32'h00000000, 32'h00000000, 32'h00000000, 32'h80000000};
        
        // 测试各轮的轮常量
        for (i = 1; i <= 10; i = i + 1) begin
            round = i[3:0];
            #10;
            $display("Round %0d: Rcon effect visible in output", i);
            $display("W[0] = %08h (should show Rcon influence)", nextkey[1:32]);
        end
        
        $display("");
        
        // 测试用例4：全零密钥
        $display("Test Case 4: All Zero Key");
        $display("=========================");
        
        keyin = 128'h0;
        round = 4'b0001;
        
        #10;
        
        display_key(keyin, "Input Key");
        display_key(nextkey, "Output Key");
        
        $display("All Zero Key Test - Manual verification needed");
        
        $display("");
        
        // 测试用例5：全FF密钥
        $display("Test Case 5: All FF Key");
        $display("=======================");
        
        keyin = {128{1'b1}};
        round = 4'b0001;
        
        #10;
        
        display_key(keyin, "Input Key");
        display_key(nextkey, "Output Key");
        
        $display("All FF Key Test - Manual verification needed");
        
        $display("");
        
        // 测试用例6：验证轮常量的正确性
        $display("Test Case 6: Rcon Values Verification");
        $display("=====================================");
        
        // 使用特殊的密钥来突出轮常量的影响
        keyin = {32'h00000000, 32'h00000000, 32'h00000000, 32'h16000000};
        
        $display("Testing Rcon values for rounds 1-10:");
        for (j = 1; j <= 10; j = j + 1) begin
            round = j[3:0];
            #10;
            $display("Round %0d: First word = %08h", j, nextkey[1:32]);
        end
        
        $display("");
        $display("Test completed!");
        $finish;
    end

endmodule
