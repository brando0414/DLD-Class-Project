`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2021 06:40:11 PM
// Design Name: 
// Module Name: top_demo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_demo
(
  // input
  input  logic [7:0] sw,
  input  logic [3:0] btn,
  input  logic       sysclk_125mhz,
  input  logic       rst,
  // output  
  output logic [7:0] led,
  output logic sseg_ca,
  output logic sseg_cb,
  output logic sseg_cc,
  output logic sseg_cd,
  output logic sseg_ce,
  output logic sseg_cf,
  output logic sseg_cg,
  output logic sseg_dp,
  output logic [3:0] sseg_an
);

  logic [16:0] CURRENT_COUNT;
  logic [16:0] NEXT_COUNT;
  logic        smol_clk;
  logic  [55:0] count;
  logic [63:0] ciphertext, plaintext, Key;
  assign ciphertext = 64'h874d5f9a668ebfc5;
  assing plaintext = 64'hcd4afbe967f761fd;
   
  // Place TicTacToe instantiation here
  top dut(smol_clk, sw[7], btn[1], plaintext, ciphertext, count, Key, led[0]);
  // 7-segment display
  segment_driver driver(
  .clk(smol_clk),
  .rst(btn[3]),
  .digit0((sw[0]&sw[1]) ? (Key[3:0]) : (sw[1] ? (Key[19:16]) : (sw[0] ? Key[35:32] : Key[51:48]))),        
  .digit1((sw[0]&sw[1]) ? (Key[7:4]) : (sw[1] ? (Key[23:20]) : (sw[0] ? Key[39:36] : Key[55:52]))),        
  .digit2((sw[0]&sw[1]) ? (Key[11:8]) : (sw[1] ? (Key[27:24]) : (sw[0] ? Key[43:40] : Key[59:56]))),        
  .digit3((sw[0]&sw[1]) ? (Key[15:12]) : (sw[1] ? (Key[31:28]) : (sw[0] ? Key[47:44] : Key[63:60]))),
  .decimals({1'b0, btn[2:0]}),
  .segment_cathodes({sseg_dp, sseg_cg, sseg_cf, sseg_ce, sseg_cd, sseg_cc, sseg_cb, sseg_ca}),
  .digit_anodes(sseg_an)
  );

// Register logic storing clock counts
  always@(posedge sysclk_125mhz)
  begin
    if(btn[3])
      CURRENT_COUNT = 17'h00000;
    else
      CURRENT_COUNT = NEXT_COUNT;
  end
  
  // Increment logic
  assign NEXT_COUNT = CURRENT_COUNT == 17'd100000 ? 17'h00000 : CURRENT_COUNT + 1;

  // Creation of smaller clock signal from counters
  assign smol_clk = CURRENT_COUNT == 17'd100000 ? 1'b1 : 1'b0;

endmodule
