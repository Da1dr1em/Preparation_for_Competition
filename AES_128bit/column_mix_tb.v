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
// Last modified Date:     2025/07/19 09:00:00
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/19 09:00:00
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              column_mix_tb.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\column_mix_tb.v
// Descriptions:           AES列混合模块测试文件
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

`timescale 1ns/1ps

module column_mix_tb();

    reg [1:128] messagein;
    wire [1:128] messageout;
    
    // 期望结果的寄存器
    reg [127:0] expected1, expected3;
    
    // 实例化待测试模块
    column_mix uut (
        .messagein(messagein),
        .messageout(messageout)
    );
    
    // 用于显示矩阵的任务
    task display_matrix;
        input [1:128] data;
        input [8*10:1] name;
        begin
            $display("%s Matrix:", name);
            $display("Col0   Col1   Col2   Col3");
            $display("%02h     %02h     %02h     %02h", 
                data[1:8], data[33:40], data[65:72], data[97:104]);
            $display("%02h     %02h     %02h     %02h", 
                data[9:16], data[41:48], data[73:80], data[105:112]);
            $display("%02h     %02h     %02h     %02h", 
                data[17:24], data[49:56], data[81:88], data[113:120]);
            $display("%02h     %02h     %02h     %02h", 
                data[25:32], data[57:64], data[89:96], data[121:128]);
            $display("");
        end
    endtask
    
    // 验证结果的任务
    task verify_result;
        input [127:0] expected;
        input [8*20:1] test_name;
        begin
            if (messageout == expected) begin
                $display("PASS: %s", test_name);
            end else begin
                $display("FAIL: %s", test_name);
                $display("Expected:");
                display_matrix(expected, "Expected");
                $display("Got:");
                display_matrix(messageout, "Actual");
            end
        end
    endtask
    
    initial begin
        $display("AES Column Mix Operation Test");
        $display("=============================");
        
        // 测试用例1：使用README中的例子
        // 输入矩阵：
        // C9 E5 FD 2B
        // 7A F2 78 6E  
        // 63 9C 26 67
        // B0 A7 82 E5
        
        // 按照[1:128]格式组织数据，按列优先存储
        // [1:8]=C9(S0), [9:16]=7A(S1), [17:24]=63(S2), [25:32]=B0(S3)     - 第1列
        // [33:40]=E5(S4), [41:48]=F2(S5), [49:56]=9C(S6), [57:64]=A7(S7)  - 第2列
        // [65:72]=FD(S8), [73:80]=78(S9), [81:88]=26(S10), [89:96]=82(S11) - 第3列  
        // [97:104]=2B(S12), [105:112]=6E(S13), [113:120]=67(S14), [121:128]=E5(S15) - 第4列
        
        messagein = {8'hC9, 8'h7A, 8'h63, 8'hB0,         // [1:8],[9:16],[17:24],[25:32] - 第1列
                     8'hE5, 8'hF2, 8'h9C, 8'hA7,         // [33:40],[41:48],[49:56],[57:64] - 第2列
                     8'hFD, 8'h78, 8'h26, 8'h82,         // [65:72],[73:80],[81:88],[89:96] - 第3列
                     8'h2B, 8'h6E, 8'h67, 8'hE5};        // [97:104],[105:112],[113:120],[121:128] - 第4列
        
        #10; // 等待组合逻辑稳定
        
        $display("Test Case 1: README Example");
        $display("===========================");
        display_matrix(messagein, "Input");
        display_matrix(messageout, "Output");
        
        // 期望的输出矩阵：
        // D4 E7 CD 66
        // 28 02 E5 BB
        // BE C6 54 BF
        // 22 0F 5D A5
        
        // 按同样方式组织期望输出
        // [1:8]=D4, [9:16]=28, [17:24]=BE, [25:32]=22      - 第1列
        // [33:40]=E7, [41:48]=02, [49:56]=C6, [57:64]=0F  - 第2列  
        // [65:72]=CD, [73:80]=E5, [81:88]=54, [89:96]=5D  - 第3列
        // [97:104]=66, [105:112]=BB, [113:120]=BF, [121:128]=A5 - 第4列
        expected1 = {8'hD4, 8'h28, 8'hBE, 8'h22,         // 第1列
                     8'hE7, 8'h02, 8'hC6, 8'h0F,         // 第2列
                     8'hCD, 8'hE5, 8'h54, 8'h5D,         // 第3列
                     8'h66, 8'hBB, 8'hBF, 8'hA5};        // 第4列
        
        verify_result(expected1, "README Example Test");
        
        $display("");
        
        // 测试用例2：零矩阵
        $display("Test Case 2: Zero Matrix");
        $display("========================");
        messagein = 128'h0;
        
        #10;
        
        display_matrix(messagein, "Input");
        display_matrix(messageout, "Output");
        
        // 零矩阵的列混合结果应该还是零矩阵
        verify_result(128'h0, "Zero Matrix Test");
        
        $display("");
        
        // 测试用例3：单位矩阵（对角线为1）
        $display("Test Case 3: Identity-like Matrix");
        $display("=================================");
        // 输入矩阵：
        // 01 00 00 00
        // 00 01 00 00
        // 00 00 01 00
        // 00 00 00 01
        
        messagein = {8'h01, 8'h00, 8'h00, 8'h00,         // 第4列
                     8'h00, 8'h01, 8'h00, 8'h00,         // 第3列
                     8'h00, 8'h00, 8'h01, 8'h00,         // 第2列
                     8'h00, 8'h00, 8'h00, 8'h01};        // 第1列
        
        #10;
        
        display_matrix(messagein, "Input");
        display_matrix(messageout, "Output");
        
        // 对于这种输入，输出应该是列混合矩阵的各列
        expected3 = {8'h02, 8'h03, 8'h01, 8'h01,         // 第4列 [2,3,1,1]
                     8'h01, 8'h02, 8'h03, 8'h01,         // 第3列 [1,2,3,1]  
                     8'h01, 8'h01, 8'h02, 8'h03,         // 第2列 [1,1,2,3]
                     8'h03, 8'h01, 8'h01, 8'h02};        // 第1列 [3,1,1,2]
        
        verify_result(expected3, "Identity Matrix Test");
        
        $display("");
        
        // 测试用例4：全FF矩阵
        $display("Test Case 4: All FF Matrix");
        $display("=========================");
        messagein = {128{1'b1}}; // 全1
        
        #10;
        
        display_matrix(messagein, "Input");
        display_matrix(messageout, "Output");
        
        $display("All FF Matrix Test - Manual verification needed");
        
        $display("");
        $display("Test completed!");
        $finish;
    end

endmodule
