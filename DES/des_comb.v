//***********************module des_comb

//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-3.6.20250620
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              des_comb.v
// Last modified Date:     2025/01/17 
// Last Version:           V1.0
// Descriptions:           DES加密模块 - 使用全组合逻辑F函数
//----------------------------------------------------------------------------------------
// Created by:             GitHub Copilot 
// Created date:           2025/01/17
// Version:                V1.0
// TEXT NAME:              des_comb.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\des_comb.v
// Descriptions:           DES算法主模块，使用全组合逻辑实现16轮迭代
//                         消除时序依赖，提供稳定的输出
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module des_comb(
    input clk,
    input rst_n,
    input start,
    input [1:64] desIn,
    input [1:64] keyIn,
    output reg ready,
    output reg [1:64] desOut 
);

// 状态机状态定义
parameter IDLE = 2'b00;
parameter COMPUTING = 2'b01;
parameter DONE = 2'b10;

reg [1:0] current_state, next_state;
reg [3:0] round_cnt;
reg start_compute;

// 内部信号
wire [1:64] IP_out;
wire [1:32] L0, R0;
wire [1:64] key_out;

// 16轮迭代的L和R寄存器
reg [1:32] L_reg[0:16], R_reg[0:16];
wire [1:32] L_wire[0:16], R_wire[0:16];

// 16轮密钥
wire [1:48] round_keys[1:16];

//========================================================================================
// 初始置换IP
//========================================================================================
IP_Regenerate ip_inst (
    .data_in(desIn),
    .data_out(IP_out)
);

// 分离L0和R0
assign L0 = IP_out[1:32];
assign R0 = IP_out[33:64];

//========================================================================================
// 密钥扩展
//========================================================================================
Branch_Key_Generate key_gen_inst (
    .key_in(keyIn),
    .key_out(key_out)
);

// 提取16轮密钥
assign round_keys[1]  = key_out[1:48];
assign round_keys[2]  = key_out[49:96];
assign round_keys[3]  = key_out[97:144];
assign round_keys[4]  = key_out[145:192];
assign round_keys[5]  = key_out[193:240];
assign round_keys[6]  = key_out[241:288];
assign round_keys[7]  = key_out[289:336];
assign round_keys[8]  = key_out[337:384];
assign round_keys[9]  = key_out[385:432];
assign round_keys[10] = key_out[433:480];
assign round_keys[11] = key_out[481:528];
assign round_keys[12] = key_out[529:576];
assign round_keys[13] = key_out[577:624];
assign round_keys[14] = key_out[625:672];
assign round_keys[15] = key_out[673:720];
assign round_keys[16] = key_out[721:768];

//========================================================================================
// 16轮F函数实例化（全组合逻辑）
//========================================================================================
wire [1:32] f_outputs[1:16];

genvar i;
generate
    for (i = 1; i <= 16; i = i + 1) begin : f_function_round
        f_function_comb_v2 f_inst (
            .Keyin(round_keys[i]),
            .RDatain(R_wire[i-1]),
            .f_out(f_outputs[i])
        );
    end
endgenerate

//========================================================================================
// 16轮迭代逻辑（组合逻辑）
//========================================================================================

// 第0轮（初始值）
assign L_wire[0] = L0;
assign R_wire[0] = R0;

// 第1-16轮迭代
generate
    for (i = 1; i <= 16; i = i + 1) begin : des_round
        assign L_wire[i] = R_wire[i-1];
        assign R_wire[i] = L_wire[i-1] ^ f_outputs[i];
    end
endgenerate

//========================================================================================
// 最终置换
//========================================================================================
wire [1:64] pre_swap;
wire [1:64] final_out;

// 注意：DES的最后一轮需要交换L和R
assign pre_swap = {R_wire[16], L_wire[16]};

IP_Swap ip_swap_inst (
    .data_in(pre_swap),
    .data_out(final_out)
);

//========================================================================================
// 控制逻辑
//========================================================================================

// 状态机时序逻辑
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        round_cnt <= 4'b0000;
        start_compute <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == COMPUTING) begin
            round_cnt <= round_cnt + 1;
        end else if (current_state == IDLE) begin
            round_cnt <= 4'b0000;
        end
        
        if (start && current_state == IDLE) begin
            start_compute <= 1'b1;
        end else if (current_state == DONE) begin
            start_compute <= 1'b0;
        end
    end
end

// 状态机组合逻辑
always @(*) begin
    case (current_state)
        IDLE: begin
            if (start) begin
                next_state = COMPUTING;
            end else begin
                next_state = IDLE;
            end
        end
        
        COMPUTING: begin
            // 由于使用全组合逻辑，只需要1个时钟周期就能完成所有16轮计算
            next_state = DONE;
        end
        
        DONE: begin
            next_state = IDLE;
        end
        
        default: begin
            next_state = IDLE;
        end
    endcase
end

// 输出逻辑
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready <= 1'b0;
        desOut <= 64'b0;
    end else begin
        case (current_state)
            IDLE: begin
                ready <= 1'b0;
                if (!start) begin
                    desOut <= 64'b0;
                end
            end
            
            COMPUTING: begin
                ready <= 1'b0;
                // 组合逻辑计算在同一时钟周期内完成
                desOut <= final_out;
            end
            
            DONE: begin
                ready <= 1'b1;
                // 保持输出稳定
            end
            
            default: begin
                ready <= 1'b0;
                desOut <= 64'b0;
            end
        endcase
    end
end

endmodule
