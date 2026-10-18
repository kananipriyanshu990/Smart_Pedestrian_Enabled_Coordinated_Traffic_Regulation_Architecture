`timescale 1ns/1ps

module BUTTON_SYNC_DEBOUNCE_TB;

    reg clk;
    reg reset;
    reg button_n;
    reg button_e;
    reg button_s;
    reg button_w;

    wire request_n;
    wire request_e;
    wire request_s;
    wire request_w;

    BUTTON_SYNC_DEBOUNCE #(.CLK_FREQ_HZ(1000),
                           .DEBOUNCE_MS(3)) 
    BT_SYNC_DB (.clk(clk),
                .reset(reset),
                .button_n(button_n),
                .button_e(button_e),
                .button_s(button_s),
                .button_w(button_w),
                .request_n(request_n),
                .request_e(request_e),
                .request_s(request_s),
                .request_w(request_w));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        button_n = 1;
        button_e = 1;
        button_s = 1;
        button_w = 1;

        repeat (5) @(negedge clk);
        reset = 0;

        repeat (10) @(negedge clk);

        button_n = 0;
        repeat (8) @(negedge clk);
        button_n = 1;

        repeat (10) @(negedge clk);

        button_e = 0;
        repeat (10) @(negedge clk);
        button_e = 1;

        repeat (10) @(negedge clk);

        button_s = 0;
        button_w = 0;
        repeat (10) @(negedge clk);
        button_s = 1;
        button_w = 1;

        repeat (10) @(negedge clk);

        $finish;
    end

endmodule