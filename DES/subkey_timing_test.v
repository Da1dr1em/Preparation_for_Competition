`timescale 1ns/1ps

module subkey_timing_test;

reg clk, rst_n, start;
reg [1:64] keyIn;
wire [1:48] subkey_out;

// 实例化单个分支密钥生成器来测试时序
Branch_Key_Generate dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .keyid(6'd1),  // 测试第1个子密钥
    .keyIn(keyIn),
    .branchkey(subkey_out)
);

// 时钟生成
initial begin
    clk = 0;
    forever #10 clk = ~clk; // 50MHz时钟
end

// 测试序列
initial begin
    // 初始化
    rst_n = 0;
    start = 0;
    keyIn = 64'h133457799BBCDFF1;
    
    // 复位
    #100;
    rst_n = 1;
    #50;
    
    // 开始密钥生成
    $display("时间: %0t - 开始密钥生成, keyIn = %h", $time, keyIn);
    start = 1;
    #20;
    start = 0;
    
    // 监控10个时钟周期
    repeat(10) begin
        #20;
        $display("时间: %0t - subkey_out = %h", $time, subkey_out);
    end
    
    #100;
    $finish;
end

// 监控内部信号
initial begin
    $monitor("时间: %0t, start: %b, start_dly2: %b, keyA[1:4]: %b, C[1:4]: %b, D[1:4]: %b, Ci[1:4]: %b, Di[1:4]: %b, CombinedCD[1:8]: %h, subkey[1:8]: %h", 
             $time, 
             start,
             dut.start_dly2,
             {dut.keyA[1], dut.keyA[2], dut.keyA[3], dut.keyA[4]},
             {dut.C[1], dut.C[2], dut.C[3], dut.C[4]},
             {dut.D[1], dut.D[2], dut.D[3], dut.D[4]},
             {dut.Ci[1], dut.Ci[2], dut.Ci[3], dut.Ci[4]},
             {dut.Di[1], dut.Di[2], dut.Di[3], dut.Di[4]},
             {dut.CombinedCD[1], dut.CombinedCD[2], dut.CombinedCD[3], dut.CombinedCD[4], dut.CombinedCD[5], dut.CombinedCD[6], dut.CombinedCD[7], dut.CombinedCD[8]},
             {subkey_out[1], subkey_out[2], subkey_out[3], subkey_out[4], subkey_out[5], subkey_out[6], subkey_out[7], subkey_out[8]});
end

endmodule
