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
// Last modified Date:     2025/07/08
// Last Version:           V2.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             AI Assistant
// Created date:           2025/07/08
// mail      :             
// Version:                V2.0
// TEXT NAME:              f_function_controller_v2.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\f_function_controller_v2.v
// Descriptions:           使用握手信号的F函数控制器
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module f_function_controller_v2(
    input clk,
    input rst_n,
    input start,
    input [1:64] desIn,     // 明文输入
    input [1:64] keyIn,     // 密钥输入
    output reg ready,       // 16轮完成信号
    output [1:64] desOut    // 加密结果输出
);

// 状态机定义
reg [3:0] state;
reg start_prev;
parameter IDLE = 4'b0000, LOAD_DATA = 4'b0001, WAIT_IP = 4'b0010, WAIT_KEYS = 4'b0011, SAVE_KEYS = 4'b0100, ENCRYPTING = 4'b0101, DONE = 4'b0110, WAIT_IP_REGEN = 4'b0111;

// 轮计数器
reg [4:0] round_count; // 1-16轮计数

// 输入数据缓存
reg [1:64] desIn_reg, keyIn_reg;

// IP置换相关
wire [1:64] SwappedIpData;
wire ip_swap_ready;
reg ip_swap_start;

// 子密钥生成相关
reg [1:48] subkey[1:16];
wire [1:48] subkey_wire[1:16];
wire subkey_ready[1:16];
reg subkey_start[1:16];
reg all_subkeys_ready;

// L、R数据
reg [1:32] L_current, R_current;

// F函数相关
wire [1:32] f_output;

// IP逆置换相关
reg [1:64] final_LR_reg;  // 保存最终的L、R组合
wire ip_regen_ready;
reg ip_regen_start;

// 输入数据缓存
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        desIn_reg <= 64'b0;
        keyIn_reg <= 64'b0;
    end else if (!start) begin
        desIn_reg <= desIn;
        keyIn_reg <= keyIn;
    end
end

// IP置换模块
IP_Swap IP_Swap_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(ip_swap_start),
    .desIn(desIn_reg),
    .IPOut(SwappedIpData),
    .ready(ip_swap_ready)
);

// 子密钥生成模块（16个）
genvar i;
generate
    for (i = 1; i <= 16; i = i + 1) begin : key_gen_loop
        Branch_Key_Generate Branch_Key_Generate_inst (
            .clk(clk),
            .rst_n(rst_n),
            .start(subkey_start[i]),
            .keyid(6'd0 + i),
            .keyIn(keyIn_reg),
            .branchkey(subkey_wire[i]),
            .ready(subkey_ready[i])
        );
    end
endgenerate

// 检查所有子密钥是否准备好
always @(*) begin
    all_subkeys_ready = subkey_ready[1] & subkey_ready[2] & subkey_ready[3] & subkey_ready[4] &
                       subkey_ready[5] & subkey_ready[6] & subkey_ready[7] & subkey_ready[8] &
                       subkey_ready[9] & subkey_ready[10] & subkey_ready[11] & subkey_ready[12] &
                       subkey_ready[13] & subkey_ready[14] & subkey_ready[15] & subkey_ready[16];
end

// 子密钥数据保存 - 添加保存完成标志
integer j;
reg subkey_saved;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (j = 1; j <= 16; j = j + 1) begin
            subkey[j] <= 48'b0;
        end
        subkey_saved <= 1'b0;
    end else if (all_subkeys_ready && !subkey_saved) begin
        for (j = 1; j <= 16; j = j + 1) begin
            subkey[j] <= subkey_wire[j];
        end
        subkey_saved <= 1'b1;  // 标记subkey已保存
    end else if (state == IDLE) begin
        subkey_saved <= 1'b0;  // 复位保存标志
    end
end

// F函数 - 使用完全组合逻辑版本，消除时钟延迟
f_function_combinational f_function_inst (
    .Keyin((round_count > 0 && round_count <= 16) ? subkey[round_count] : 48'b0),
    .RDatain(R_current),
    .f_out(f_output)
);

// 最终L、R组合保存
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_LR_reg <= 64'b0;
    end else if (state == ENCRYPTING && round_count == 5'd16) begin
        // 在ENCRYPTING状态的最后一轮保存最终结果
        //final_LR_reg <= {R_current, L_current ^ f_output};
        final_LR_reg <= {L_current ^ f_output, R_current}; //这个才是正确排序，即{R16,L16}
    end
end

// IP逆置换
IP_Regenerate IP_Regenerate_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(ip_regen_start),
    .LRCombine(final_LR_reg),
    .ready(ip_regen_ready),
    .desOut(desOut)
);

// 主状态机控制
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        ready <= 1'b0;
        start_prev <= 1'b0;
        round_count <= 5'b0;
        L_current <= 32'b0;
        R_current <= 32'b0;
        final_LR_reg <= 64'b0;
        ip_swap_start <= 1'b0;
        ip_regen_start <= 1'b0;
        for (j = 1; j <= 16; j = j + 1) begin
            subkey_start[j] <= 1'b0;
        end
    end else begin
        start_prev <= start;
        
        case (state)
            IDLE: begin
                if (start && !start_prev) begin
                    state <= LOAD_DATA;
                    ready <= 1'b0;
                end
            end
            
            LOAD_DATA: begin
                // 启动IP置换
                ip_swap_start <= 1'b1;
                // 启动所有子密钥生成
                for (j = 1; j <= 16; j = j + 1) begin
                    subkey_start[j] <= 1'b1;
                end
                state <= WAIT_IP;
            end
            
            WAIT_IP: begin
                if (ip_swap_ready) begin
                    ip_swap_start <= 1'b0;
                    state <= WAIT_KEYS;
                end
            end
            
            WAIT_KEYS: begin
                if (all_subkeys_ready) begin
                    // 停止子密钥生成
                    for (j = 1; j <= 16; j = j + 1) begin
                        subkey_start[j] <= 1'b0;
                    end
                    // 进入保存状态，等待subkey数据稳定
                    state <= SAVE_KEYS;
                end
            end
            
            SAVE_KEYS: begin
                // 等待subkey数据保存完成
                if (subkey_saved) begin
                    // 开始加密
                    state <= ENCRYPTING;
                    round_count <= 5'd1;
                    L_current <= SwappedIpData[1:32];
                    R_current <= SwappedIpData[33:64];
                end
            end
            
            ENCRYPTING: begin //5
                if (round_count == 5'd16) begin
                    // 16轮完成，直接进入DONE状态
                    // final_LR_reg已经在always块中保存了
                    state <= DONE;
                end else begin
                    // 继续下一轮
                    L_current <= R_current;
                    R_current <= L_current ^ f_output;
                    round_count <= round_count + 1'b1;
                end
            end
            
            DONE: begin //6
                // 启动IP逆置换
                ip_regen_start <= 1'b1;
                state <= WAIT_IP_REGEN;
            end
            
            WAIT_IP_REGEN: begin //7
                if (ip_regen_ready) begin
                    ip_regen_start <= 1'b0;
                    ready <= 1'b1;
                    if (!start) begin
                        state <= IDLE;
                        ready <= 1'b0;
                        round_count <= 5'b0;
                    end
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule
