/////////////////////////////////////////////////////////////////////
////                                                             ////
////  DES TEST BENCH                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2001 Rudolf Usselmann                         ////
////                    rudi@asics.ws                            ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

`include "timescale.v" 

module aes_tb();

  reg           dut_sys_clk;
  reg           dut_sys_rst_n;
  reg  [127:0]  dut_text_in;
  reg  [127:0]  dut_key;
  reg           dut_ld;

  wire [127:0]  dut_text_out;
  wire          dut_done;

  aes dut ( 
    .sys_clk  ( dut_sys_clk  ),
    .sys_rst_n( dut_sys_rst_n),
    .key      ( dut_key      ),
    .text_in  ( dut_text_in  ),
    .ld       ( dut_ld       ),
    .text_out ( dut_text_out ),
    .done     ( dut_done     )
  );

  task delay;
    input [31:0] num;
  begin
    repeat(num) @(posedge dut_sys_clk);
    #1;
  end
  endtask

  initial begin
    dut_sys_clk   = 1'b0;
    dut_sys_rst_n = 1'b1;
    repeat(1) @(negedge dut_sys_clk);
    dut_sys_rst_n = 1'b0;
    repeat(1) @(posedge dut_sys_clk);
    #1;
    dut_sys_rst_n = 1'b1;
  end

  //always #7.5 dut_sys_clk = ~dut_sys_clk; // 66MHz
  //always #5 dut_sys_clk = ~dut_sys_clk; // 100MHz
  always #4 dut_sys_clk = ~dut_sys_clk; // 125MHz
  //always #3 dut_sys_clk = ~dut_sys_clk; // 166MHz

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

  initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars();
  end

  integer   seed;
  reg[31:0] num1;
  reg[31:0] num2;
  reg[31:0] num3;
  reg[31:0] num4;
  reg[31:0] num5;

  initial begin
    if ( !$value$plusargs("seed+%d", seed) ) begin
      seed = 0;
    end
    @(posedge dut_sys_clk);
    #1;
    num1 = $random(seed);
    num2 = $random(seed);
    num3 = $random(seed);
    num4 = $random(seed);
    num5 = $random(seed);
  end

  integer PLOGFILE;
  integer CLOGFILE;

  initial begin
    PLOGFILE=$fopen("plain.txt", "a"); 
    CLOGFILE=$fopen("cipher.txt", "a"); 
    $display("");
    $display("**************************************");
    $display("* AES Test started ...               *");
    $display("**************************************");
    $display("");
    dut_ld = 1'b0;
    dut_key     = 128'h00000000000000000000000000000000;
    dut_text_in = 128'h00000000000000000000000000000000;
    @(posedge dut_sys_rst_n);
    //
    // key        : 128'h000102030405060708090a0b0c0d0e0f;
    // plaintext  : 128'h00112233445566778899aabbccddeeff;
    // ciphertext : 128'h69c4e0d86a7b0430d8cdb78070b4c55a
    //
    dut_key = 128'h000102030405060708090a0b0c0d0e0f;
    dut_text_in = 128'h00112233445566778899aabbccddeeff;
    //dut_text_in = {num2,num3,num4,num5};
    $fdisplay(PLOGFILE, "plaintext = %h", dut_text_in); 
    delay(3);  // Dont change this delay
    dut_ld = 1'b1;
    delay(1);
    dut_ld = 1'b0;
    
    // 
    // key        : 128'h2b7e151628aed2a6abf7158809cf4f3c;
    // plaintext  : 128'h3243f6a8885a308d313198a2e0370734
    // ciphertext : 128'h06355b9005249e3a87cc793567dfa4b4
    // 
    delay(30);
    dut_ld = 1'b0;
    dut_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    dut_text_in = 128'h3243f6a8885a308d313198a2e0370734;
    $fdisplay(PLOGFILE, "plaintext = %h", dut_text_in); 
    delay(13);
    dut_ld = 1'b1;
    delay(1);
    dut_ld = 1'b0;
    
  end
    
  // 
  // Print the cipher text to cipher.txt
  //
  reg      dut_done_dly;
  wire     dut_done_pulse;

  initial begin 
    dut_done_dly = 1;
  end

  always @(posedge dut_sys_clk) begin
    dut_done_dly <= #1 dut_done;
  end

  assign dut_done_pulse = ~dut_done_dly & dut_done;

  always @(posedge dut_sys_clk) begin
    if ( dut_done_pulse ) begin
      $fdisplay(CLOGFILE, "ciphertext = %h", dut_text_out); 
      @(posedge dut_sys_clk);
      #1;
      $display("");
      $display("**************************************");
      $display("* AES Test done ...                  *");
      $display("**************************************");
      $display("");
      $fclose(PLOGFILE);
      $fclose(CLOGFILE);
      $finish;
    end
  end

endmodule

