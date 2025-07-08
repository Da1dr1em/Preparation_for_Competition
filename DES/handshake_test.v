`timescale 1ns/1ps

module handshake_test;

reg clk, rst_n, start;
reg [1:64] desIn, keyIn;
wire ready;
wire [1:64] desOut;

// 实例化新的握手信号版本
f_function_controller_v2 dut (
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
    #40;  // 保持start信号2个时钟周期
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
    $monitor("时间: %0t, 状态: %d, 轮数: %d, IP_ready: %b, keys_ready: %b, ready: %b", 
             $time, 
             dut.state, 
             dut.round_count, 
             dut.ip_swap_ready,
             dut.all_subkeys_ready,
             ready);
end

// 详细状态跟踪
initial begin
    $display("=== 握手信号测试开始 ===");
    wait(dut.state == 4'b0001); // LOAD_DATA
    $display("时间: %0t - 进入LOAD_DATA状态，启动IP置换和密钥生成", $time);
    
    wait(dut.state == 4'b0010); // WAIT_IP
    $display("时间: %0t - 进入WAIT_IP状态，等待IP置换完成", $time);
    
    wait(dut.state == 4'b0011); // WAIT_KEYS
    $display("时间: %0t - 进入WAIT_KEYS状态，等待所有子密钥生成完成", $time);
    
    wait(dut.state == 4'b0100); // ENCRYPTING
    $display("时间: %0t - 进入ENCRYPTING状态，开始16轮加密", $time);
    
    wait(dut.state == 4'b0101); // DONE
    $display("时间: %0t - 进入DONE状态，16轮加密完成", $time);
    
    wait(dut.state == 4'b0110); // WAIT_IP_REGEN
    $display("时间: %0t - 进入WAIT_IP_REGEN状态，等待IP逆置换完成", $time);
    
    wait(ready);
    $display("时间: %0t - 整个加密过程完成", $time);
end

endmodule
