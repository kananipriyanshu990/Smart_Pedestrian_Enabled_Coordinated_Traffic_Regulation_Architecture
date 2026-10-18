`timescale 1ns/1ps

module TRAFFIC_LIGHT_TB;

    reg  [1:0] color;
    wire red;
    wire yellow;
    wire green;

    TRAFFIC_LIGHT TRF_LT (.color(color),
                          .red(red),
                          .yellow(yellow),
                          .green(green));

    initial begin
        color = 2'b00;
        #20;

        color = 2'b01;
        #20;

        color = 2'b10;
        #20;

        color = 2'b11;
        #20;

        color = 2'b00;
        #20;

        $finish;
    end

endmodule