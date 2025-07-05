`timescale 1ns / 1ps
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
// Last modified Date:     2025/07/05 09:14:43
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             NGL
// Created date:           2025/07/05 09:14:43
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              des.v
// PATH:                   D:\Working\竞赛练习\des.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module des(
    input clk,rst_n,start,
    input [1:64] desIn,keyIn, //输入的明文和密钥 
    output ready,
    output [1:64] desOut 
);                                            
wire [1:64] SwappedIpData;   
IP_Swap IP_Swap_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .desIn(desIn),
    .IPOut(SwappedIpData)
);
//拆分打散后的数组
reg [1:32] LData,RData;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        LData <= 32'b0;
        RData <= 32'b0;
    end else if (start) begin
        LData <= SwappedIpData[1:32];
        RData <= SwappedIpData[33:64];
    end
end

reg [1:48] subkey[1:16];
genvar i;
//生成16个私钥
generate
    for (i = 1; i <= 16; i = i + 1) begin : key_gen_loop
        Branch_Key_Generate Branch_Key_Generate_inst (
            .clk(clk),
            .rst_n(rst_n),
            .start(start),
            .keyid(i),
            .keyIn(keyIn),
            .branchkey(subkey[i])
        );
    end
endgenerate
//下一步是编写并使用f函数

// 状态控制和轮计数
reg [4:0] round_count; // 1-16轮计数
reg [2:0] state; // 状态机：0-空闲，1-加密中，2-完成
parameter IDLE = 3'b000, ENCRYPTING = 3'b001, DONE = 3'b010;

// 16轮加密的中间变量
reg [1:32] L_current, R_current;
reg [1:32] L_next, R_next;
wire [1:32] f_output;
reg start_f_function;

// F函数实例化
f_function f_function_inst (
    .clk(clk),
    .rst_n(rst_n),
    .Keyin(subkey[round_count]),
    .RDatain(R_current),
    .f_out(f_output)
);

// 状态机控制
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        round_count <= 5'b0;
        L_current <= 32'b0;
        R_current <= 32'b0;
        L_next <= 32'b0;
        R_next <= 32'b0;
        start_f_function <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= ENCRYPTING;
                    round_count <= 5'd1;
                    L_current <= LData;
                    R_current <= RData;
                    start_f_function <= 1'b1;
                end
            end
            
            ENCRYPTING: begin
                // 计算下一轮的L和R值
                L_next <= R_current;
                R_next <= L_current ^ f_output;
                
                if (round_count == 5'd16) begin
                    state <= DONE;
                    start_f_function <= 1'b0;
                end else begin
                    round_count <= round_count + 1'b1;
                    L_current <= R_current;
                    R_current <= L_current ^ f_output;
                end
            end
            
            DONE: begin
                if (!start) begin
                    state <= IDLE;
                    round_count <= 5'b0;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

// 16轮后的L、R组合（注意：最后一轮不交换L、R）
wire [1:64] final_LR;
assign final_LR = {R_next, L_next}; // 最后一轮后R在左，L在右

// IP逆置换
wire ip_regen_ready;
IP_Regenerate IP_Regenerate_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(state == DONE),
    .LRCombine(final_LR),
    .ready(ip_regen_ready),
    .desOut(desOut)
);

// ready信号生成
assign ready = (state == DONE) && ip_regen_ready;
endmodule