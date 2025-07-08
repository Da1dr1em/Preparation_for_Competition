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
// TEXT NAME:              Branch_Key_Generate_v2.v
// PATH:                   D:\Working\Preparation_for_Competition\DES\Branch_Key_Generate_v2.v
// Descriptions:           使用握手信号的分支密钥生成模块
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Branch_Key_Generate_v2(
    input clk,rst_n,start,
    input [5:0] keyid, //要求生成的私钥ID(1~16)
    input [1:64] keyIn, //输入的公钥       
    output [1:48] branchkey, //生成48位私钥
    output reg ready //完成标志
);

// 状态机定义
reg [2:0] state;
reg start_prev;
parameter IDLE = 3'b000, KEYA_GEN = 3'b001, CD_SPLIT = 3'b010, LEFT_SHIFT = 3'b011, COMBINE_CD = 3'b100, FINAL_PERM = 3'b101, DONE = 3'b110;

// 内部寄存器
reg [1:48] branchkey_reg;
reg [1:56] keyA;
reg [1:28] C, D;
reg [1:56] CombinedCD;
reg left_shift_start;
wire left_shift_ready;
wire [1:28] Ci, Di;

// 置换表
reg [5:0] keySwapA[1:56];
reg [5:0] keySwapBTable[1:48];

// 初始化置换表
initial begin
    // keySwapA表
    keySwapA[1] = 57; keySwapA[2] = 49; keySwapA[3] = 41; keySwapA[4] = 33;
    keySwapA[5] = 25; keySwapA[6] = 17; keySwapA[7] = 9; keySwapA[8] = 1;
    keySwapA[9] = 58; keySwapA[10] = 50; keySwapA[11] = 42; keySwapA[12] = 34;
    keySwapA[13] = 26; keySwapA[14] = 18; keySwapA[15] = 10; keySwapA[16] = 2;
    keySwapA[17] = 59; keySwapA[18] = 51; keySwapA[19] = 43; keySwapA[20] = 35;
    keySwapA[21] = 27; keySwapA[22] = 19; keySwapA[23] = 11; keySwapA[24] = 3;
    keySwapA[25] = 60; keySwapA[26] = 52; keySwapA[27] = 44; keySwapA[28] = 36;
    keySwapA[29] = 63; keySwapA[30] = 55; keySwapA[31] = 47; keySwapA[32] = 39;
    keySwapA[33] = 31; keySwapA[34] = 23; keySwapA[35] = 15; keySwapA[36] = 7;
    keySwapA[37] = 62; keySwapA[38] = 54; keySwapA[39] = 46; keySwapA[40] = 38;
    keySwapA[41] = 30; keySwapA[42] = 22; keySwapA[43] = 14; keySwapA[44] = 6;
    keySwapA[45] = 61; keySwapA[46] = 53; keySwapA[47] = 45; keySwapA[48] = 37;
    keySwapA[49] = 29; keySwapA[50] = 21; keySwapA[51] = 13; keySwapA[52] = 5;
    keySwapA[53] = 28; keySwapA[54] = 20; keySwapA[55] = 12; keySwapA[56] = 4;
    
    // keySwapBTable表
    keySwapBTable[1] = 14; keySwapBTable[2] = 17; keySwapBTable[3] = 11; keySwapBTable[4] = 24;
    keySwapBTable[5] = 1; keySwapBTable[6] = 5; keySwapBTable[7] = 3; keySwapBTable[8] = 28;
    keySwapBTable[9] = 15; keySwapBTable[10] = 6; keySwapBTable[11] = 21; keySwapBTable[12] = 10;
    keySwapBTable[13] = 23; keySwapBTable[14] = 19; keySwapBTable[15] = 12; keySwapBTable[16] = 4;
    keySwapBTable[17] = 26; keySwapBTable[18] = 8; keySwapBTable[19] = 16; keySwapBTable[20] = 7;
    keySwapBTable[21] = 27; keySwapBTable[22] = 20; keySwapBTable[23] = 13; keySwapBTable[24] = 2;
    keySwapBTable[25] = 41; keySwapBTable[26] = 52; keySwapBTable[27] = 31; keySwapBTable[28] = 37;
    keySwapBTable[29] = 47; keySwapBTable[30] = 55; keySwapBTable[31] = 30; keySwapBTable[32] = 40;
    keySwapBTable[33] = 51; keySwapBTable[34] = 45; keySwapBTable[35] = 33; keySwapBTable[36] = 48;
    keySwapBTable[37] = 44; keySwapBTable[38] = 49; keySwapBTable[39] = 39; keySwapBTable[40] = 56;
    keySwapBTable[41] = 34; keySwapBTable[42] = 53; keySwapBTable[43] = 46; keySwapBTable[44] = 42;
    keySwapBTable[45] = 50; keySwapBTable[46] = 36; keySwapBTable[47] = 29; keySwapBTable[48] = 32;
end

// 循环左移模块实例化
left_loop left_loop_inst(
    .clk(clk),
    .rst_n(rst_n),
    .start(left_shift_start),
    .C0(C),
    .D0(D),
    .keyid(keyid),
    .ready(left_shift_ready),
    .Ci(Ci),
    .Di(Di)
);

// 主状态机
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        ready <= 1'b0;
        start_prev <= 1'b0;
        keyA <= 56'b0;
        C <= 28'b0;
        D <= 28'b0;
        CombinedCD <= 56'b0;
        branchkey_reg <= 48'b0;
        left_shift_start <= 1'b0;
    end else begin
        start_prev <= start;
        
        case (state)
            IDLE: begin
                if (start && !start_prev) begin
                    state <= KEYA_GEN;
                    ready <= 1'b0;
                end
            end
            
            KEYA_GEN: begin
                // 生成keyA - 使用组合逻辑
                keyA[1] <= keyIn[keySwapA[1]];   keyA[2] <= keyIn[keySwapA[2]];   keyA[3] <= keyIn[keySwapA[3]];   keyA[4] <= keyIn[keySwapA[4]];
                keyA[5] <= keyIn[keySwapA[5]];   keyA[6] <= keyIn[keySwapA[6]];   keyA[7] <= keyIn[keySwapA[7]];   keyA[8] <= keyIn[keySwapA[8]];
                keyA[9] <= keyIn[keySwapA[9]];   keyA[10] <= keyIn[keySwapA[10]]; keyA[11] <= keyIn[keySwapA[11]]; keyA[12] <= keyIn[keySwapA[12]];
                keyA[13] <= keyIn[keySwapA[13]]; keyA[14] <= keyIn[keySwapA[14]]; keyA[15] <= keyIn[keySwapA[15]]; keyA[16] <= keyIn[keySwapA[16]];
                keyA[17] <= keyIn[keySwapA[17]]; keyA[18] <= keyIn[keySwapA[18]]; keyA[19] <= keyIn[keySwapA[19]]; keyA[20] <= keyIn[keySwapA[20]];
                keyA[21] <= keyIn[keySwapA[21]]; keyA[22] <= keyIn[keySwapA[22]]; keyA[23] <= keyIn[keySwapA[23]]; keyA[24] <= keyIn[keySwapA[24]];
                keyA[25] <= keyIn[keySwapA[25]]; keyA[26] <= keyIn[keySwapA[26]]; keyA[27] <= keyIn[keySwapA[27]]; keyA[28] <= keyIn[keySwapA[28]];
                keyA[29] <= keyIn[keySwapA[29]]; keyA[30] <= keyIn[keySwapA[30]]; keyA[31] <= keyIn[keySwapA[31]]; keyA[32] <= keyIn[keySwapA[32]];
                keyA[33] <= keyIn[keySwapA[33]]; keyA[34] <= keyIn[keySwapA[34]]; keyA[35] <= keyIn[keySwapA[35]]; keyA[36] <= keyIn[keySwapA[36]];
                keyA[37] <= keyIn[keySwapA[37]]; keyA[38] <= keyIn[keySwapA[38]]; keyA[39] <= keyIn[keySwapA[39]]; keyA[40] <= keyIn[keySwapA[40]];
                keyA[41] <= keyIn[keySwapA[41]]; keyA[42] <= keyIn[keySwapA[42]]; keyA[43] <= keyIn[keySwapA[43]]; keyA[44] <= keyIn[keySwapA[44]];
                keyA[45] <= keyIn[keySwapA[45]]; keyA[46] <= keyIn[keySwapA[46]]; keyA[47] <= keyIn[keySwapA[47]]; keyA[48] <= keyIn[keySwapA[48]];
                keyA[49] <= keyIn[keySwapA[49]]; keyA[50] <= keyIn[keySwapA[50]]; keyA[51] <= keyIn[keySwapA[51]]; keyA[52] <= keyIn[keySwapA[52]];
                keyA[53] <= keyIn[keySwapA[53]]; keyA[54] <= keyIn[keySwapA[54]]; keyA[55] <= keyIn[keySwapA[55]]; keyA[56] <= keyIn[keySwapA[56]];
                state <= CD_SPLIT;
            end
            
            CD_SPLIT: begin
                // 拆分为C和D
                C <= keyA[1:28];
                D <= keyA[29:56];
                state <= LEFT_SHIFT;
            end
            
            LEFT_SHIFT: begin
                if (!left_shift_start) begin
                    left_shift_start <= 1'b1;  // 启动left_loop
                end else if (left_shift_ready) begin
                    left_shift_start <= 1'b0;
                    state <= COMBINE_CD;
                end
            end
            
            COMBINE_CD: begin
                CombinedCD <= {Ci, Di};
                state <= FINAL_PERM;
            end
            
            FINAL_PERM: begin
                // 执行最终置换
                branchkey_reg[1] <= CombinedCD[keySwapBTable[1]];   branchkey_reg[2] <= CombinedCD[keySwapBTable[2]];   branchkey_reg[3] <= CombinedCD[keySwapBTable[3]];   branchkey_reg[4] <= CombinedCD[keySwapBTable[4]];
                branchkey_reg[5] <= CombinedCD[keySwapBTable[5]];   branchkey_reg[6] <= CombinedCD[keySwapBTable[6]];   branchkey_reg[7] <= CombinedCD[keySwapBTable[7]];   branchkey_reg[8] <= CombinedCD[keySwapBTable[8]];
                branchkey_reg[9] <= CombinedCD[keySwapBTable[9]];   branchkey_reg[10] <= CombinedCD[keySwapBTable[10]]; branchkey_reg[11] <= CombinedCD[keySwapBTable[11]]; branchkey_reg[12] <= CombinedCD[keySwapBTable[12]];
                branchkey_reg[13] <= CombinedCD[keySwapBTable[13]]; branchkey_reg[14] <= CombinedCD[keySwapBTable[14]]; branchkey_reg[15] <= CombinedCD[keySwapBTable[15]]; branchkey_reg[16] <= CombinedCD[keySwapBTable[16]];
                branchkey_reg[17] <= CombinedCD[keySwapBTable[17]]; branchkey_reg[18] <= CombinedCD[keySwapBTable[18]]; branchkey_reg[19] <= CombinedCD[keySwapBTable[19]]; branchkey_reg[20] <= CombinedCD[keySwapBTable[20]];
                branchkey_reg[21] <= CombinedCD[keySwapBTable[21]]; branchkey_reg[22] <= CombinedCD[keySwapBTable[22]]; branchkey_reg[23] <= CombinedCD[keySwapBTable[23]]; branchkey_reg[24] <= CombinedCD[keySwapBTable[24]];
                branchkey_reg[25] <= CombinedCD[keySwapBTable[25]]; branchkey_reg[26] <= CombinedCD[keySwapBTable[26]]; branchkey_reg[27] <= CombinedCD[keySwapBTable[27]]; branchkey_reg[28] <= CombinedCD[keySwapBTable[28]];
                branchkey_reg[29] <= CombinedCD[keySwapBTable[29]]; branchkey_reg[30] <= CombinedCD[keySwapBTable[30]]; branchkey_reg[31] <= CombinedCD[keySwapBTable[31]]; branchkey_reg[32] <= CombinedCD[keySwapBTable[32]];
                branchkey_reg[33] <= CombinedCD[keySwapBTable[33]]; branchkey_reg[34] <= CombinedCD[keySwapBTable[34]]; branchkey_reg[35] <= CombinedCD[keySwapBTable[35]]; branchkey_reg[36] <= CombinedCD[keySwapBTable[36]];
                branchkey_reg[37] <= CombinedCD[keySwapBTable[37]]; branchkey_reg[38] <= CombinedCD[keySwapBTable[38]]; branchkey_reg[39] <= CombinedCD[keySwapBTable[39]]; branchkey_reg[40] <= CombinedCD[keySwapBTable[40]];
                branchkey_reg[41] <= CombinedCD[keySwapBTable[41]]; branchkey_reg[42] <= CombinedCD[keySwapBTable[42]]; branchkey_reg[43] <= CombinedCD[keySwapBTable[43]]; branchkey_reg[44] <= CombinedCD[keySwapBTable[44]];
                branchkey_reg[45] <= CombinedCD[keySwapBTable[45]]; branchkey_reg[46] <= CombinedCD[keySwapBTable[46]]; branchkey_reg[47] <= CombinedCD[keySwapBTable[47]]; branchkey_reg[48] <= CombinedCD[keySwapBTable[48]];
                state <= DONE;
            end
            
            DONE: begin
                ready <= 1'b1;
                if (!start) begin
                    state <= IDLE;
                    ready <= 1'b0;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

// 输出连接
assign branchkey = branchkey_reg;

endmodule
