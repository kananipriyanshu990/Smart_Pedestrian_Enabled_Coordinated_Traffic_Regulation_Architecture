`timescale 1ns/1ps

module PEDESTRIAN_SIGNAL_TB;

    reg walk_enable;
    wire walk;
    wire dont_walk;

    PEDESTRIAN_SIGNAL PDST_SIG (.walk_enable(walk_enable),
                                .walk(walk),
                                .dont_walk(dont_walk));

    initial begin
        walk_enable = 1'b0;
        #30;

        walk_enable = 1'b1;
        #50;

        walk_enable = 1'b0;
        #30;

        walk_enable = 1'b1;
        #20;

        walk_enable = 1'b0;
        #30;

        $finish;
    end

endmodule