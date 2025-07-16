//***********************module f_function_combinational(

//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-3.6.20250620
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              f_function_combinational.v
// Last modified Date:     2025/01/12 
// Last Version:           V3.0
// Descriptions:           完全组合逻辑版本的F函数，无时钟延迟
//                        将所有的寄存器逻辑改为组合逻辑，输出可以在同一时钟周期内产生
//----------------------------------------------------------------------------------------

module f_function(
    input [1:48] Keyin,
    input [1:32] RDatain, //输入的32位数据;
    output [1:32] f_out //输出的32位数据                   
);

//F函数由四个部分组成：对Rdata进行E变换扩展，结果与Keyin进行异或运算，最后对结果进行S盒变换和P变换得到32位输出

// E变换表声明 - 48个6(1~32)位元素的数组

// E变换 - 组合逻辑
wire [1:48] EData;

//为了节省寄存器资源，仍然选择使用组合逻辑实现E变换，直接在输出端口上进行赋值
assign EData = {
    RDatain[32], RDatain[1], RDatain[2], RDatain[3], RDatain[4], RDatain[5],
    RDatain[4], RDatain[5], RDatain[6], RDatain[7], RDatain[8], RDatain[9],
    RDatain[8], RDatain[9], RDatain[10], RDatain[11], RDatain[12], RDatain[13],
    RDatain[12], RDatain[13], RDatain[14], RDatain[15], RDatain[16], RDatain[17],
    RDatain[16], RDatain[17], RDatain[18], RDatain[19], RDatain[20], RDatain[21],
    RDatain[20], RDatain[21], RDatain[22], RDatain[23], RDatain[24], RDatain[25],
    RDatain[24], RDatain[25], RDatain[26], RDatain[27], RDatain[28], RDatain[29],
    RDatain[28], RDatain[29], RDatain[30], RDatain[31], RDatain[32], RDatain[1]
};

// 异或运算 - 组合逻辑
wire [1:48] Sin;
assign Sin = EData ^ Keyin;

//为节省资源，仍然仅使用组合逻辑完成S盒变换，直接在输出端口上进行赋值
wire [1:32] Ri;
SOne S1 (
    .Sin(Sin[1:6]),
    .Sout(Ri[1:4])
);
STwo S2 (
    .Sin(Sin[7:12]),
    .Sout(Ri[5:8])
);
SThree S3 (
    .Sin(Sin[13:18]),
    .Sout(Ri[9:12])
);
SFour S4 (
    .Sin(Sin[19:24]),
    .Sout(Ri[13:16])
);
SFive S5 (
    .Sin(Sin[25:30]),
    .Sout(Ri[17:20])
);
SSix S6 (
    .Sin(Sin[31:36]),
    .Sout(Ri[21:24])
);
SSeven S7 (
    .Sin(Sin[37:42]),
    .Sout(Ri[25:28])
);
SEight S8 (
    .Sin(Sin[43:48]),
    .Sout(Ri[29:32])
);






assign f_out = {
    Ri[16], Ri[7], Ri[20], Ri[21],
    Ri[29], Ri[12], Ri[28], Ri[17],
    Ri[1], Ri[15], Ri[23], Ri[26],
    Ri[5], Ri[18], Ri[31], Ri[10],
    Ri[2], Ri[8], Ri[24], Ri[14],
    Ri[32], Ri[27], Ri[3], Ri[9],
    Ri[19], Ri[13], Ri[30], Ri[6],
    Ri[22], Ri[11], Ri[4], Ri[25]
};

endmodule
