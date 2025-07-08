`timescale 1ns/1ps

module timing_test;

reg clk, rst_n, start;
reg [1:64] desIn, keyIn;
wire ready;
wire [1:64] desOut;

// 实例化DUT
des dut (
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
    forever #10 clk = ~clk; // 50MHz时钟
end

// 测试序列
initial begin
    // 初始化
    rst_n = 0;
    start = 0;
    desIn = 64'h0123456789ABCDEF;
    keyIn = 64'h133457799BBCDFF1;
    
    // 复位
    #100;
    rst_n = 1;
    #50;
    
    // 开始加密
    $display("时间: %0t - 开始加密", $time);
    start = 1;
    #20;
    start = 0;
    
    // 等待完成
    wait(ready);
    $display("时间: %0t - 加密完成", $time);
    $display("明文: %h", desIn);
    $display("密钥: %h", keyIn);
    $display("密文: %h", desOut);
    
    #100;
    $finish;
end

// 监控关键信号
initial begin
    $monitor("时间: %0t, 状态: %d, 轮数: %d, ready: %b", 
             $time, 
             dut.f_controller_inst.state, 
             dut.f_controller_inst.round_count, 
             ready);
end

endmodule
