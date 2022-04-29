module control(clk, reset, found, start, UP, en1, en2);

   input logic  clk;
   input logic  reset;
   input logic 	found;
   input logic start;
   
   output logic UP, en1, en2;

   typedef enum 	logic [1:0] {Idle, UpCount, Store, FoundKey} statetype;
   statetype state, nextstate;
   
   // state register
   always_ff @(posedge clk, posedge reset)
     if (reset) state <= Idle;
     else       state <= nextstate;
   
   // next state logic
   always_comb
     case (state)
       Idle: begin
	UP <= 0;
    en1 <= 0;
    en2 <= 0;

	  if (start) nextstate <= UpCount;
    else if (!start) nextstate <= Idle;
       end
       UpCount: begin
	  UP <= 1;
    en1 <= 0;
    en2 <= 0;

	  nextstate <= Store;
       end
       Store: begin
	  UP <= 0;
    en1 <= 1;
    en2 <= 0;

	  if (found) nextstate <= FoundKey;
	  else   nextstate <= UpCount;
       end
       FoundKey: begin
	  UP <= 0;
    en1 <= 0;
    en2 <= 1;
	  
    if (start) nextstate <= FoundKey;
	  else   nextstate <= Idle;
       end
     endcase
   
endmodule

