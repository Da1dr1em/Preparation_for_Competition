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
// Last modified Date:     2025/07/18 16:22:41
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/18 16:22:41
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Byte_transform.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\Byte_transform.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//实现字节代换的功能，输入为128位，输出为代换后的128位结果
module Byte_transform(
    input [1:128] aesIn,
    output [1:128] ByteTransOut                      
);
    Sbox Sbox_inst1 (
        .matrix(aesIn[1:8]), //将输入的128位分成16个8位的部分
        .Sout(ByteTransOut[1:8]) //输出的128位也分成16个8位的部分
    );                                                                   
    Sbox Sbox_inst2 (
        .matrix(aesIn[9:16]),
        .Sout(ByteTransOut[9:16])
    );
    Sbox Sbox_inst3 (
        .matrix(aesIn[17:24]),
        .Sout(ByteTransOut[17:24])
    );
    Sbox Sbox_inst4 (
        .matrix(aesIn[25:32]),
        .Sout(ByteTransOut[25:32])
    );
    Sbox Sbox_inst5 (
        .matrix(aesIn[33:40]),
        .Sout(ByteTransOut[33:40])
    );
    Sbox Sbox_inst6 (
        .matrix(aesIn[41:48]),
        .Sout(ByteTransOut[41:48])
    );
    Sbox Sbox_inst7 (
        .matrix(aesIn[49:56]),
        .Sout(ByteTransOut[49:56])
    );
    Sbox Sbox_inst8 (
        .matrix(aesIn[57:64]),
        .Sout(ByteTransOut[57:64])
    );
    Sbox Sbox_inst9 (
        .matrix(aesIn[65:72]),
        .Sout(ByteTransOut[65:72])
    );
    Sbox Sbox_inst10 (
        .matrix(aesIn[73:80]),
        .Sout(ByteTransOut[73:80])
    );
    Sbox Sbox_inst11 (
        .matrix(aesIn[81:88]),
        .Sout(ByteTransOut[81:88])
    );
    Sbox Sbox_inst12 (
        .matrix(aesIn[89:96]),
        .Sout(ByteTransOut[89:96])
    );
    Sbox Sbox_inst13 (
        .matrix(aesIn[97:104]),
        .Sout(ByteTransOut[97:104])
    );
    Sbox Sbox_inst14 (
        .matrix(aesIn[105:112]),
        .Sout(ByteTransOut[105:112])
    );
    Sbox Sbox_inst15 (
        .matrix(aesIn[113:120]),
        .Sout(ByteTransOut[113:120])
    );
    Sbox Sbox_inst16 (
        .matrix(aesIn[121:128]),
        .Sout(ByteTransOut[121:128])
    );

endmodule