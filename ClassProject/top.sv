module top (input logic 		clk, Start, reset,
			input logic [63:0] 	plaintext, ciphertext, 
			output logic [55:0] count,
			output logic [63:0] Key, 
			output logic 		FoundKeyNum);

  // Put your solution here and remove the following assignments.


  
  


  crack cr1(clk, Start, reset, plaintext, ciphertext, count, Key, FoundKeyNum);
  
  

 
endmodule // top


module crack(input logic clk, Start, reset, input logic [63:0] plaintext, ciphertext, output logic [55:0] count, output logic [63:0] Key, output logic FoundKeyNum);

  logic en1, en2, up;
  logic [63:0] des_out;
  logic [63:0] par_out;
  logic [63:0] ff1_out;
  logic [63:0] ff2_out;
  logic [55:0] cntr_out;
  UDL_Count #(56) UDL_Count(clk, reset, up, 1'b0, 1'b0, 56'b0, count);
  genParity8 genParity8(count, par_out);
  DES des(par_out, plaintext, 1'b1, des_out);
  comparator #(64) comparator(ciphertext, des_out, FoundKeyNum);
  flopenr #(64) cipher(clk, reset, en1, des_out, ff2_out);
  flopenr #(64) key(clk, reset, en2, par_out, Key);
  control control(clk, reset, FoundKeyNum, Start, up, en1, en2);
endmodule