module PEDESTRIAN_SIGNAL (input wire walk_enable,
                          output wire walk,
                          output wire dont_walk);

    assign walk = walk_enable;
    assign dont_walk = ~walk_enable;

endmodule