
`timescale 1ns/100ps 

module ks (
  clk,
  rst_n,
  start,
  keyIn,
  roundNum,
  roundKey
);

  input         clk;
  input         rst_n;
  input         start;
  input  [1:64] keyIn;
  input  [4:0]  roundNum;
  output [1:48] roundKey;

  reg    [1:56] CD;
  
  wire   [1:56] C0D0;
  wire   [1:56] C1D1;
  wire   [1:56] C2D2;
  wire   [1:56] C3D3;
  wire   [1:56] C4D4;
  wire   [1:56] C5D5;
  wire   [1:56] C6D6;
  wire   [1:56] C7D7;
  wire   [1:56] C8D8;
  wire   [1:56] C9D9;
  wire   [1:56] C10D10;
  wire   [1:56] C11D11;
  wire   [1:56] C12D12;
  wire   [1:56] C13D13;
  wire   [1:56] C14D14;
  wire   [1:56] C15D15;
  wire   [1:56] C16D16;
  
  assign C0D0 = {
    keyIn[57], keyIn[49], keyIn[41], keyIn[33], keyIn[25], keyIn[17], keyIn[09],
    keyIn[01], keyIn[58], keyIn[50], keyIn[42], keyIn[34], keyIn[26], keyIn[18],
    keyIn[10], keyIn[02], keyIn[59], keyIn[51], keyIn[43], keyIn[35], keyIn[27],
    keyIn[19], keyIn[11], keyIn[03], keyIn[60], keyIn[52], keyIn[44], keyIn[36],
    keyIn[63], keyIn[55], keyIn[47], keyIn[39], keyIn[31], keyIn[23], keyIn[15],
    keyIn[07], keyIn[62], keyIn[54], keyIn[46], keyIn[38], keyIn[30], keyIn[22],
    keyIn[14], keyIn[06], keyIn[61], keyIn[53], keyIn[45], keyIn[37], keyIn[29],
    keyIn[21], keyIn[13], keyIn[05], keyIn[28], keyIn[20] ,keyIn[12], keyIn[04]
  };
  assign C1D1  = {C0D0[2:28], C0D0[1], C0D0[30:56], C0D0[29]};

  assign C2D2  = {CD[2:28], CD[1],   CD[30:56], CD[29]};
  assign C3D3  = {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C4D4  = {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C5D5  = {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C6D6  = {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C7D7  = {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C8D8  = {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C9D9  = {CD[2:28], CD[1],   CD[30:56], CD[29]};
  assign C10D10= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C11D11= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C12D12= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C13D13= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C14D14= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C15D15= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
  assign C16D16= {CD[2:28], CD[1],   CD[30:56], CD[29]};
  
  always @( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      CD <= #1 56'b0;
    end
    else if ( ~|roundNum && start ) begin
      CD <= #1 C1D1;
    end
    else begin
      case( roundNum )
        1       : CD <= #1 C2D2;
        2       : CD <= #1 C3D3;
        3       : CD <= #1 C4D4;
        4       : CD <= #1 C5D5;
        5       : CD <= #1 C6D6;
        6       : CD <= #1 C7D7;
        7       : CD <= #1 C8D8;
        8       : CD <= #1 C9D9;
        9       : CD <= #1 C10D10;
        10      : CD <= #1 C11D11;
        11      : CD <= #1 C12D12;
        12      : CD <= #1 C13D13;
        13      : CD <= #1 C14D14;
        14      : CD <= #1 C15D15;
        15      : CD <= #1 C16D16;
        default : CD <= #1 CD;
      endcase
    end
  end

  assign roundKey = {
    CD[14],CD[17],CD[11],CD[24],CD[1], CD[5],
    CD[3] ,CD[28],CD[15],CD[6], CD[21],CD[10],
    CD[23],CD[19],CD[12],CD[4], CD[26],CD[8],
    CD[16],CD[7], CD[27],CD[20],CD[13],CD[2],
    CD[41],CD[52],CD[31],CD[37],CD[47],CD[55],
    CD[30],CD[40],CD[51],CD[45],CD[33],CD[48],
    CD[44],CD[49],CD[39],CD[56],CD[34],CD[53],
    CD[46],CD[42],CD[50],CD[36],CD[29],CD[32]
  };

endmodule
