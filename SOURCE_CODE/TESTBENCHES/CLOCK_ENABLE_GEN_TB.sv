
`timescale 1ns/1ps

module CLOCK_ENABLE_GEN_TB;

    reg clk;
    reg reset;
    wire one_sec_tick;

    integer tick_count;
    integer errors;

    CLOCK_ENABLE_GEN #(.CLK_FREQ_HZ(5))
    CLK_EN (.clk(clk),
            .reset(reset),
            .one_sec_tick(one_sec_tick));

    always #10 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        tick_count = 0;
        errors = 0;

        repeat (2) @(negedge clk);
        reset = 1'b0;

        repeat (22) begin
            @(negedge clk);

            if (one_sec_tick)
                tick_count = tick_count + 1;
        end

        if (tick_count != 4) begin
            errors = errors + 1;
            $error("Expected 4 ticks, received %0d", tick_count);
        end

        if (errors == 0)
            $display("CLOCK_ENABLE_GEN_TB: PASS");
        else
            $display("CLOCK_ENABLE_GEN_TB: FAIL");

        $finish;
    end

endmodule