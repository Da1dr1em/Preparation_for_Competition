
`timescale 1ns/100ps 

module ks (
  keyIn,
  roundNum,
  roundKey
);

  input  [1:64] keyIn;
  input  [4:0]  roundNum;
  output [1:48] roundKey;
  
  wire   [1:56] KeyC0D0 ;
  wire   [1:56] KeyC1D1;
  wire   [1:56] KeyC2D2;
  wire   [1:56] KeyC3D3;
  wire   [1:56] KeyC4D4;
  wire   [1:56] KeyC5D5;
  wire   [1:56] KeyC6D6;
  wire   [1:56] KeyC7D7;
  wire   [1:56] KeyC8D8;
  wire   [1:56] KeyC9D9;
  wire   [1:56] KeyC10D10;
  wire   [1:56] KeyC11D11;
  wire   [1:56] KeyC12D12;
  wire   [1:56] KeyC13D13;
  wire   [1:56] KeyC14D14;
  wire   [1:56] KeyC15D15;
  wire   [1:56] KeyC16D16;
  wire   [3:0]  activeSel;
  reg    [1:56] activeKey;
  
  assign KeyC0D0 = {
    keyIn[57], keyIn[49], keyIn[41], keyIn[33], keyIn[25], keyIn[17], keyIn[09],
    keyIn[01], keyIn[58], keyIn[50], keyIn[42], keyIn[34], keyIn[26], keyIn[18],
    keyIn[10], keyIn[02], keyIn[59], keyIn[51], keyIn[43], keyIn[35], keyIn[27],
    keyIn[19], keyIn[11], keyIn[03], keyIn[60], keyIn[52], keyIn[44], keyIn[36],
    keyIn[63], keyIn[55], keyIn[47], keyIn[39], keyIn[31], keyIn[23], keyIn[15],
    keyIn[07], keyIn[62], keyIn[54], keyIn[46], keyIn[38], keyIn[30], keyIn[22],
    keyIn[14], keyIn[06], keyIn[61], keyIn[53], keyIn[45], keyIn[37], keyIn[29],
    keyIn[21], keyIn[13], keyIn[05], keyIn[28], keyIn[20] ,keyIn[12], keyIn[04]
  };

  assign KeyC1D1  = {KeyC0D0[2:28],  KeyC0D0[1],    KeyC0D0[30:56],  KeyC0D0[29]};
  assign KeyC2D2  = {KeyC1D1[2:28],  KeyC1D1[1],    KeyC1D1[30:56],  KeyC1D1[29]};
  assign KeyC3D3  = {KeyC2D2[3:28],  KeyC2D2[1:2],  KeyC2D2[31:56],  KeyC2D2[29:30]};
  assign KeyC4D4  = {KeyC3D3[3:28],  KeyC3D3[1:2],  KeyC3D3[31:56],  KeyC3D3[29:30]};
  assign KeyC5D5  = {KeyC4D4[3:28],  KeyC4D4[1:2],  KeyC4D4[31:56],  KeyC4D4[29:30]};
  assign KeyC6D6  = {KeyC5D5[3:28],  KeyC5D5[1:2],  KeyC5D5[31:56],  KeyC5D5[29:30]};
  assign KeyC7D7  = {KeyC6D6[3:28],  KeyC6D6[1:2],  KeyC6D6[31:56],  KeyC6D6[29:30]};
  assign KeyC8D8  = {KeyC7D7[3:28],  KeyC7D7[1:2],  KeyC7D7[31:56],  KeyC7D7[29:30]};
  assign KeyC9D9  = {KeyC8D8[2:28],  KeyC8D8[1],    KeyC8D8[30:56],  KeyC8D8[29]};
  assign KeyC10D10= {KeyC9D9[3:28],  KeyC9D9[1:2],  KeyC9D9[31:56],  KeyC9D9[29:30]};
  assign KeyC11D11= {KeyC10D10[3:28],KeyC10D10[1:2],KeyC10D10[31:56],KeyC10D10[29:30]};
  assign KeyC12D12= {KeyC11D11[3:28],KeyC11D11[1:2],KeyC11D11[31:56],KeyC11D11[29:30]};
  assign KeyC13D13= {KeyC12D12[3:28],KeyC12D12[1:2],KeyC12D12[31:56],KeyC12D12[29:30]};
  assign KeyC14D14= {KeyC13D13[3:28],KeyC13D13[1:2],KeyC13D13[31:56],KeyC13D13[29:30]};
  assign KeyC15D15= {KeyC14D14[3:28],KeyC14D14[1:2],KeyC14D14[31:56],KeyC14D14[29:30]};
  assign KeyC16D16= {KeyC15D15[2:28],KeyC15D15[1],  KeyC15D15[30:56],KeyC15D15[29]};
  
  assign roundKey = {
    activeKey[14],activeKey[17],activeKey[11],activeKey[24],activeKey[1], activeKey[5],
    activeKey[3] ,activeKey[28],activeKey[15],activeKey[6], activeKey[21],activeKey[10],
    activeKey[23],activeKey[19],activeKey[12],activeKey[4], activeKey[26],activeKey[8],
    activeKey[16],activeKey[7], activeKey[27],activeKey[20],activeKey[13],activeKey[2],
    activeKey[41],activeKey[52],activeKey[31],activeKey[37],activeKey[47],activeKey[55],
    activeKey[30],activeKey[40],activeKey[51],activeKey[45],activeKey[33],activeKey[48],
    activeKey[44],activeKey[49],activeKey[39],activeKey[56],activeKey[34],activeKey[53],
    activeKey[46],activeKey[42],activeKey[50],activeKey[36],activeKey[29],activeKey[32]
  };

  always @(*) begin
    case( roundNum )
      1       : activeKey = KeyC1D1;
      2       : activeKey = KeyC2D2;
      3       : activeKey = KeyC3D3;
      4       : activeKey = KeyC4D4;
      5       : activeKey = KeyC5D5;
      6       : activeKey = KeyC6D6;
      7       : activeKey = KeyC7D7;
      8       : activeKey = KeyC8D8;
      9       : activeKey = KeyC9D9;
      10      : activeKey = KeyC10D10;
      11      : activeKey = KeyC11D11;
      12      : activeKey = KeyC12D12;
      13      : activeKey = KeyC13D13;
      14      : activeKey = KeyC14D14;
      15      : activeKey = KeyC15D15;
      16      : activeKey = KeyC16D16;
      default : activeKey = 0;
    endcase
  end

endmodule
