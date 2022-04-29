module controljoey(input logic clk, Start, reset, FoundKeyNum,
output logic cntr_en, cntr_rst);



typedef enum logic [3:0] {Default, Check, Increment, Final} statetype;
statetype state, nextstate;

always_ff @(posedge clk, posedge reset)
    if (reset) state <= Default;
    else state <= nextstate;

    assign cntr_rst = state == Default;
    assign cntr_en = state == Increment;
always_comb
    case (state)
        Default: begin
            if (Start) nextstate = Check;
            else nextstate = Default;
        end
        Check: begin
            if (FoundKeyNum) nextstate = Final;
            else nextstate = Increment;
        end
        Increment: nextstate = Check;
        Final: nextstate = Final;
        default: nextstate = Default;
    endcase
endmodule
