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
// Last modified Date:     2025/07/13 15:43:12
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/13 15:43:12
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              1011identicator.v
// PATH:                   D:\Working\Preparation_for_Competition\FeelFree\1011identicator.v
// Descriptions:           
//目的是判断输入的流式信号是否为1011
//                         如果是则输出true_out为1，否则为0                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module identicator (
    input clk,
    input rst_n,
    input in,start,
    output true_out
);  

localparam EMPTY = 3'b000,ONE = 3'b001,TWO = 3'b010,THREE = 3'b011,FULL = 3'b100;                          
reg [1:4] record;
reg [1:3] state;
    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n)begin                           
                record <= 4'b0;
                state <= EMPTY;
            end                                   
            else if(start) begin
              case (state)
                EMPTY: begin record[1] <= in;
                            state <= ONE; // 更新状态为ONE
                        end
                ONE:   begin record[2] <= in;
                            state <= TWO; // 更新状态为TWO
                        end
                TWO:   begin record[3] <= in;
                            state <= THREE; // 更新状态为THREE
                        end
                THREE: begin
                        record[4] <= in;
                        state <= FULL; // 更新状态为FULL
                end
                FULL:  begin record <= {in,record[2:4]}; // 滑动窗口
                        end
                default: ;
              endcase
            end                                                               
            else ;                               
        end                                          
assign true_out = (record == 4'b1011) ? 1'b1 : 1'b0; // 如果record为1011，则输出true_out为1，否则为0
endmodule