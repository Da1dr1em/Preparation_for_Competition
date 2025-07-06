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
// Last modified Date:     2025/07/06 
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             AI Assistant
// Created date:           2025/07/06 
// mail      :             
// Version:                V1.0
// TEXT NAME:              f_function_controller.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\f_function_controller.v
// Descriptions:           F函数控制器，控制16轮DES加密迭代
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module f_function_controller(
    input clk,
    input rst_n,
    input start,
    input [1:64] desIn,     // 明文输入
    input [1:64] keyIn,     // 密钥输入
    output ready,           // 16轮完成信号
    output [1:64] desOut    // 加密结果输出
);

// 状态机定义
reg [2:0] state;
parameter IDLE = 3'b000, LOAD_DATA = 3'b001, ENCRYPTING = 3'b010, DONE = 3'b011;

// 轮计数器
reg [4:0] round_count; // 1-16轮计数

// 输入数据缓存（在start为0时才能更新）
reg [1:64] desIn_reg, keyIn_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        desIn_reg <= 64'b0;
        keyIn_reg <= 64'b0;
    end else if (!start) begin
        // 只在start为0时从外界读取数据，避免输入干扰
        desIn_reg <= desIn;
        keyIn_reg <= keyIn;
    end
end

// IP置换
wire [1:64] SwappedIpData;
IP_Swap IP_Swap_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(state == LOAD_DATA),
    .desIn(desIn_reg),
    .IPOut(SwappedIpData)
);

// L、R数据
reg [1:32] L_current, R_current;
reg [1:32] L_next, R_next;

// 子密钥生成
reg [1:48] subkey[1:16];
wire [1:48] subkey_wire[1:16];
genvar i;
integer j;

generate
    for (i = 1; i <= 16; i = i + 1) begin : key_gen_loop
        Branch_Key_Generate Branch_Key_Generate_inst (
            .clk(clk),
            .rst_n(rst_n),
            .start(state == LOAD_DATA),
            .keyid(6'd0 + i),
            .keyIn(keyIn_reg),
            .branchkey(subkey_wire[i])
        );
    end
endgenerate

// 子密钥寄存
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (j = 1; j <= 16; j = j + 1) begin
            subkey[j] <= 48'b0;
        end
    end else begin
        for (j = 1; j <= 16; j = j + 1) begin
            subkey[j] <= subkey_wire[j];
        end
    end
end

// F函数
wire [1:32] f_output;
f_function f_function_inst (
    .clk(clk),
    .rst_n(rst_n),
    .Keyin(round_count > 0 && round_count <= 16 ? subkey[round_count] : 48'b0),
    .RDatain(R_current),
    .f_out(f_output)
);

// 主状态机控制
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        round_count <= 5'b0;
        L_current <= 32'b0;
        R_current <= 32'b0;
        L_next <= 32'b0;
        R_next <= 32'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= LOAD_DATA;
                    round_count <= 5'b0;
                end
            end
            
            LOAD_DATA: begin
                // 等待IP置换和密钥生成完成，然后开始加密
                state <= ENCRYPTING;
                round_count <= 5'd1;
                L_current <= SwappedIpData[1:32];
                R_current <= SwappedIpData[33:64];
            end
            
            ENCRYPTING: begin
                if (round_count == 5'd16) begin
                    // 16轮完成，保存最终结果
                    L_next <= R_current;
                    R_next <= L_current ^ f_output;
                    state <= DONE;
                end else begin
                    // 继续下一轮
                    L_current <= R_current;
                    R_current <= L_current ^ f_output;
                    round_count <= round_count + 1'b1;
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

// 最终L、R组合
wire [1:64] final_LR;
assign final_LR = (state == DONE) ? {R_next, L_next} : 64'b0;

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

// ready信号生成 - 当16轮完成且IP逆置换完成时
assign ready = (state == DONE) && ip_regen_ready;

endmodule
