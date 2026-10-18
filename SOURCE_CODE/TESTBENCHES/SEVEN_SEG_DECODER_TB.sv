`timescale 1ns/1ps

module SEVEN_SEG_DECODER_TB;

    reg [7:0] seconds;
    wire [6:0] HEX0;
    wire [6:0] HEX1;

    SEVEN_SEG_DECODER SV_SG_DC (.seconds(seconds),
                                .HEX0(HEX0),
                                .HEX1(HEX1));

    initial begin
        seconds = 8'd0;
        #20;

        seconds = 8'd7;
        #20;

        seconds = 8'd12;
        #20;

        seconds = 8'd25;
        #20;

        seconds = 8'd49;
        #20;

        seconds = 8'd60;
        #20;

        seconds = 8'd99;
        #20;

        $finish;
    end

endmodule