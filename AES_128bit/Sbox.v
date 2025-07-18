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
// Last modified Date:     2025/07/18 15:36:17
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/07/18 15:36:17
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Sbox.v
// PATH:                   D:\Working\Preparation_for_Competition\AES_128bit\Sbox.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//S盒映射(对8位输入进行S盒映射，输出8位)
module Sbox(
    input [1:8] matrix,
    output [1:8] Sout
    );
    reg [1:8] Sout_reg;
    always @(matrix)begin           
        case({matrix[1:4],matrix[5:8]})
            //第一行
            8'h00:Sout_reg = 8'h63;
            8'h01:Sout_reg = 8'h7c;
            8'h02:Sout_reg = 8'h77;
            8'h03:Sout_reg = 8'h7b;
            8'h04:Sout_reg = 8'hf2;
            8'h05:Sout_reg = 8'h6b;
            8'h06:Sout_reg = 8'h6f;
            8'h07:Sout_reg = 8'hc5;
            8'h08:Sout_reg = 8'h30;
            8'h09:Sout_reg = 8'h01;
            8'h0a:Sout_reg = 8'h67;
            8'h0b:Sout_reg = 8'h2b;
            8'h0c:Sout_reg = 8'hfe;
            8'h0d:Sout_reg = 8'hd7;
            8'h0e:Sout_reg = 8'hab;
            8'h0f:Sout_reg = 8'h76;
            //第二行
            8'h10:Sout_reg = 8'hca;
            8'h11:Sout_reg = 8'h82;
            8'h12:Sout_reg = 8'hc9;
            8'h13:Sout_reg = 8'h7d;
            8'h14:Sout_reg = 8'hfa;
            8'h15:Sout_reg = 8'h59;
            8'h16:Sout_reg = 8'h47;
            8'h17:Sout_reg = 8'hf0;
            8'h18:Sout_reg = 8'had;
            8'h19:Sout_reg = 8'hd4;
            8'h1a:Sout_reg = 8'ha2;
            8'h1b:Sout_reg = 8'haf;
            8'h1c:Sout_reg = 8'h9c;
            8'h1d:Sout_reg = 8'ha4;
            8'h1e:Sout_reg = 8'h72;
            8'h1f:Sout_reg = 8'hc0;
            //第三行
            8'h20:Sout_reg = 8'hb7;
            8'h21:Sout_reg = 8'hfd;
            8'h22:Sout_reg = 8'h93;
            8'h23:Sout_reg = 8'h26;
            8'h24:Sout_reg = 8'h36;
            8'h25:Sout_reg = 8'h3f;
            8'h26:Sout_reg = 8'hf7;
            8'h27:Sout_reg = 8'hcc;
            8'h28:Sout_reg = 8'h34;
            8'h29:Sout_reg = 8'ha5;
            8'h2a:Sout_reg = 8'he5;
            8'h2b:Sout_reg = 8'hf1;
            8'h2c:Sout_reg = 8'h71;
            8'h2d:Sout_reg = 8'hd8;
            8'h2e:Sout_reg = 8'h31;
            8'h2f:Sout_reg = 8'h15;
            //第四行
            8'h30:Sout_reg = 8'h04;
            8'h31:Sout_reg = 8'hc7;
            8'h32:Sout_reg = 8'h43;
            8'h33:Sout_reg = 8'hc3;
            8'h34:Sout_reg = 8'h18;
            8'h35:Sout_reg = 8'h96;
            8'h36:Sout_reg = 8'h05;
            8'h37:Sout_reg = 8'h9a;
            8'h38:Sout_reg = 8'h07;
            8'h39:Sout_reg = 8'h12;
            8'h3a:Sout_reg = 8'h80;
            8'h3b:Sout_reg = 8'he2;
            8'h3c:Sout_reg = 8'heb;
            8'h3d:Sout_reg = 8'h47;
            8'h3e:Sout_reg = 8'hb2;
            8'h3f:Sout_reg = 8'h75;
            //第五行
            8'h40:Sout_reg = 8'h09;
            8'h41:Sout_reg = 8'h83;
            8'h42:Sout_reg = 8'h2c;
            8'h43:Sout_reg = 8'h1a;
            8'h44:Sout_reg = 8'h1b;
            8'h45:Sout_reg = 8'h6e;
            8'h46:Sout_reg = 8'h5a;
            8'h47:Sout_reg = 8'ha0;
            8'h48:Sout_reg = 8'h52;
            8'h49:Sout_reg = 8'h3b;
            8'h4a:Sout_reg = 8'hd6;
            8'h4b:Sout_reg = 8'hb3;
            8'h4c:Sout_reg = 8'h29;
            8'h4d:Sout_reg = 8'he3;
            8'h4e:Sout_reg = 8'h2f;
            8'h4f:Sout_reg = 8'h84;
            //第六行
            8'h50:Sout_reg = 8'h53;
            8'h51:Sout_reg = 8'hd1;
            8'h52:Sout_reg = 8'h00;
            8'h53:Sout_reg = 8'hed;
            8'h54:Sout_reg = 8'h20;
            8'h55:Sout_reg = 8'hfc;
            8'h56:Sout_reg = 8'hb1;
            8'h57:Sout_reg = 8'h5b;
            8'h58:Sout_reg = 8'h6a;
            8'h59:Sout_reg = 8'hcb;
            8'h5a:Sout_reg = 8'hbe;
            8'h5b:Sout_reg = 8'h39;
            8'h5c:Sout_reg = 8'h4a;
            8'h5d:Sout_reg = 8'h4c;
            8'h5e:Sout_reg = 8'h58;
            8'h5f:Sout_reg = 8'hcf;
            //第七行
            8'h60:Sout_reg = 8'hd0;
            8'h61:Sout_reg = 8'hef;
            8'h62:Sout_reg = 8'haa;
            8'h63:Sout_reg = 8'hfb;
            8'h64:Sout_reg = 8'h43;
            8'h65:Sout_reg = 8'h4d;
            8'h66:Sout_reg = 8'h33;
            8'h67:Sout_reg = 8'h85;
            8'h68:Sout_reg = 8'h45;
            8'h69:Sout_reg = 8'hf9;
            8'h6a:Sout_reg = 8'h02;
            8'h6b:Sout_reg = 8'h7f;
            8'h6c:Sout_reg = 8'h50;
            8'h6d:Sout_reg = 8'h3c;
            8'h6e:Sout_reg = 8'h9f;
            8'h6f:Sout_reg = 8'ha8;
            //第八行
            8'h70:Sout_reg = 8'h51;
            8'h71:Sout_reg = 8'ha3;
            8'h72:Sout_reg = 8'h40;
            8'h73:Sout_reg = 8'h8f;
            8'h74:Sout_reg = 8'h92;
            8'h75:Sout_reg = 8'h9d;
            8'h76:Sout_reg = 8'h38;
            8'h77:Sout_reg = 8'hf5;
            8'h78:Sout_reg = 8'hbc;
            8'h79:Sout_reg = 8'hb6;
            8'h7a:Sout_reg = 8'hda;
            8'h7b:Sout_reg = 8'h21;
            8'h7c:Sout_reg = 8'h10;
            8'h7d:Sout_reg = 8'hff;
            8'h7e:Sout_reg = 8'hf3;
            8'h7f:Sout_reg = 8'hd2;
            //第九行
            8'h80:Sout_reg = 8'hcd;
            8'h81:Sout_reg = 8'h0c;
            8'h82:Sout_reg = 8'h13;
            8'h83:Sout_reg = 8'hec;
            8'h84:Sout_reg = 8'h5f;
            8'h85:Sout_reg = 8'h97;
            8'h86:Sout_reg = 8'h44;
            8'h87:Sout_reg = 8'h17;
            8'h88:Sout_reg = 8'hc4;
            8'h89:Sout_reg = 8'ha7;
            8'h8a:Sout_reg = 8'h7e;
            8'h8b:Sout_reg = 8'h3d;
            8'h8c:Sout_reg = 8'h64;
            8'h8d:Sout_reg = 8'h5d;
            8'h8e:Sout_reg = 8'h19;
            8'h8f:Sout_reg = 8'h73;
            //第十行
            8'h90:Sout_reg = 8'h60;
            8'h91:Sout_reg = 8'h81;
            8'h92:Sout_reg = 8'h4f;
            8'h93:Sout_reg = 8'hdc;
            8'h94:Sout_reg = 8'h22;
            8'h95:Sout_reg = 8'h2a;
            8'h96:Sout_reg = 8'h90;
            8'h97:Sout_reg = 8'h88;
            8'h98:Sout_reg = 8'h46;
            8'h99:Sout_reg = 8'hee;
            8'h9a:Sout_reg = 8'hb8;
            8'h9b:Sout_reg = 8'h14;
            8'h9c:Sout_reg = 8'hde;
            8'h9d:Sout_reg = 8'h5e;
            8'h9e:Sout_reg = 8'h0b;
            8'h9f:Sout_reg = 8'hdb;
            //第十一行
            8'ha0:Sout_reg = 8'he0;
            8'ha1:Sout_reg = 8'h32;
            8'ha2:Sout_reg = 8'h3a;
            8'ha3:Sout_reg = 8'h0a;
            8'ha4:Sout_reg = 8'h49;
            8'ha5:Sout_reg = 8'h06;
            8'ha6:Sout_reg = 8'h24;
            8'ha7:Sout_reg = 8'h5c;
            8'ha8:Sout_reg = 8'hc2;
            8'ha9:Sout_reg = 8'hd3;
            8'haa:Sout_reg = 8'hac;
            8'hab:Sout_reg = 8'h62;
            8'hac:Sout_reg = 8'h91;
            8'had:Sout_reg = 8'h95;
            8'hae:Sout_reg = 8'he4;
            8'haf:Sout_reg = 8'h79;
            //第十二行
            8'hb0:Sout_reg = 8'he7;
            8'hb1:Sout_reg = 8'hc8;
            8'hb2:Sout_reg = 8'h37;
            8'hb3:Sout_reg = 8'h6d;
            8'hb4:Sout_reg = 8'h8d;
            8'hb5:Sout_reg = 8'hd5;
            8'hb6:Sout_reg = 8'h4e;
            8'hb7:Sout_reg = 8'ha9;
            8'hb8:Sout_reg = 8'h6c;
            8'hb9:Sout_reg = 8'h56;
            8'hba:Sout_reg = 8'hf4;
            8'hbb:Sout_reg = 8'hea;
            8'hbc:Sout_reg = 8'h65;
            8'hbd:Sout_reg = 8'h7a;
            8'hbe:Sout_reg = 8'hae;
            8'hbf:Sout_reg = 8'h08;
            //第十三行
            8'hc0:Sout_reg = 8'hba;
            8'hc1:Sout_reg = 8'h78;
            8'hc2:Sout_reg = 8'h25;
            8'hc3:Sout_reg = 8'h2e;
            8'hc4:Sout_reg = 8'h1c;
            8'hc5:Sout_reg = 8'ha6;
            8'hc6:Sout_reg = 8'hb4;
            8'hc7:Sout_reg = 8'hc6;
            8'hc8:Sout_reg = 8'he8;
            8'hc9:Sout_reg = 8'hdd;
            8'hca:Sout_reg = 8'h74;
            8'hcb:Sout_reg = 8'h1f;
            8'hcc:Sout_reg = 8'h4b;
            8'hcd:Sout_reg = 8'hbd;
            8'hce:Sout_reg = 8'h8b;
            8'hcf:Sout_reg = 8'h8a;
            //第十四行
            8'hd0:Sout_reg = 8'h70;
            8'hd1:Sout_reg = 8'h3e;
            8'hd2:Sout_reg = 8'hb5;
            8'hd3:Sout_reg = 8'h66;
            8'hd4:Sout_reg = 8'h48;
            8'hd5:Sout_reg = 8'h03;
            8'hd6:Sout_reg = 8'hf6;
            8'hd7:Sout_reg = 8'h0e;
            8'hd8:Sout_reg = 8'h61;
            8'hd9:Sout_reg = 8'h35;
            8'hda:Sout_reg = 8'h57;
            8'hdb:Sout_reg = 8'hb9;
            8'hdc:Sout_reg = 8'h86;
            8'hdd:Sout_reg = 8'hc1;
            8'hde:Sout_reg = 8'h1d;
            8'hdf:Sout_reg = 8'h9e;
            //第十五行
            8'he0:Sout_reg = 8'he1;
            8'he1:Sout_reg = 8'hf8;
            8'he2:Sout_reg = 8'h98;
            8'he3:Sout_reg = 8'h11;
            8'he4:Sout_reg = 8'h69;
            8'he5:Sout_reg = 8'hd9;
            8'he6:Sout_reg = 8'h8e;
            8'he7:Sout_reg = 8'h94;
            8'he8:Sout_reg = 8'h9b;
            8'he9:Sout_reg = 8'h1e;
            8'hea:Sout_reg = 8'h87;
            8'heb:Sout_reg = 8'he9;
            8'hec:Sout_reg = 8'hce;
            8'hed:Sout_reg = 8'h55;
            8'hee:Sout_reg = 8'h28;
            8'hef:Sout_reg = 8'hdf;
            //第十六行
            8'hf0:Sout_reg = 8'h8c;
            8'hf1:Sout_reg = 8'ha1;
            8'hf2:Sout_reg = 8'h89;
            8'hf3:Sout_reg = 8'h0d;
            8'hf4:Sout_reg = 8'hbf;
            8'hf5:Sout_reg = 8'he6;
            8'hf6:Sout_reg = 8'h42;
            8'hf7:Sout_reg = 8'h68;
            8'hf8:Sout_reg = 8'h41;
            8'hf9:Sout_reg = 8'h99;
            8'hfa:Sout_reg = 8'h2d;
            8'hfb:Sout_reg = 8'h0f;
            8'hfc:Sout_reg = 8'hb0;
            8'hfd:Sout_reg = 8'h54;
            8'hfe:Sout_reg = 8'hbb;
            8'hff:Sout_reg = 8'h16;
            default: ;
        endcase
    end                                                                                                             
assign Sout = Sout_reg; //将寄存器的值赋给输出                                                                  
endmodule