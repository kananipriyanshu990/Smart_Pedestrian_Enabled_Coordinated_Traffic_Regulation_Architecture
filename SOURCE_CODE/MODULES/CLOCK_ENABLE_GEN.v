
module CLOCK_ENABLE_GEN #(parameter CLK_FREQ_HZ = 50000000)
                         (input wire clk,
                          input wire reset,
                          output reg  one_sec_tick);

    integer count;

    always @(posedge clk) begin
        if (reset) begin
            count       <= 0;
            one_sec_tick <= 1'b0;
        end
        else if (count == CLK_FREQ_HZ - 1) begin
            count       <= 0;
            one_sec_tick <= 1'b1;
        end
        else begin
            count       <= count + 1;
            one_sec_tick <= 1'b0;
        end
    end

endmodule