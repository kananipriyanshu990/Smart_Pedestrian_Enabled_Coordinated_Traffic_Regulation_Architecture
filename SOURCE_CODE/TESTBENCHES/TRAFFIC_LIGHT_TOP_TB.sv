`timescale 1ns/1ps

module TRAFFIC_LIGHT_TOP_TB;

    reg CLOCK_50;
    reg [9:0] SW;
    reg [3:0] KEY;

    wire RED_NORTH, YELLOW_NORTH, GREEN_NORTH;
    wire RED_EAST, YELLOW_EAST,  GREEN_EAST;
    wire RED_SOUTH, YELLOW_SOUTH, GREEN_SOUTH;
    wire RED_WEST, YELLOW_WEST,  GREEN_WEST;

    wire WALK_NORTH, DONT_WALK_NORTH;
    wire WALK_EAST, DONT_WALK_EAST;
    wire WALK_SOUTH, DONT_WALK_SOUTH;
    wire WALK_WEST, DONT_WALK_WEST;

    wire [6:0] HEX0, HEX1;

    TRAFFIC_LIGHT_TOP #(.CLK_FREQ_HZ(100),
                        .DEBOUNCE_MS(2),
                        .GREEN_SECONDS(8),
                        .YELLOW_SECONDS(3),
                        .ALL_RED_SECONDS(1),
                        .PED_WALK_SECONDS(4),
                        .PED_CLEAR_SECONDS(2),
                        .GREEN_EXTENSION_SEC(2))
    TRF_LT_TOP(.CLOCK_50(CLOCK_50),
               .SW(SW),
               .KEY(KEY),

               .RED_NORTH(RED_NORTH),
               .YELLOW_NORTH(YELLOW_NORTH),
               .GREEN_NORTH(GREEN_NORTH),

               .RED_EAST(RED_EAST),
               .YELLOW_EAST(YELLOW_EAST),
               .GREEN_EAST(GREEN_EAST),

               .RED_SOUTH(RED_SOUTH),
               .YELLOW_SOUTH(YELLOW_SOUTH),
               .GREEN_SOUTH(GREEN_SOUTH),

               .RED_WEST(RED_WEST),
               .YELLOW_WEST(YELLOW_WEST),
               .GREEN_WEST(GREEN_WEST),

               .WALK_NORTH(WALK_NORTH),
               .DONT_WALK_NORTH(DONT_WALK_NORTH),

               .WALK_EAST(WALK_EAST),
               .DONT_WALK_EAST(DONT_WALK_EAST),

               .WALK_SOUTH(WALK_SOUTH),
               .DONT_WALK_SOUTH(DONT_WALK_SOUTH),

               .WALK_WEST(WALK_WEST),
               .DONT_WALK_WEST(DONT_WALK_WEST),

               .HEX0(HEX0),
               .HEX1(HEX1));

    always #10 CLOCK_50 = ~CLOCK_50;

    initial begin
        CLOCK_50 = 1'b0;
        SW = 10'b0;
        KEY = 4'b1111;

        SW[0] = 1'b1;
        repeat (5) @(negedge CLOCK_50);
        SW[0] = 1'b0;

        repeat (300) @(negedge CLOCK_50);

        KEY[1] = 1'b0;
        repeat (5) @(negedge CLOCK_50);
        KEY[1] = 1'b1;

        repeat (100) @(negedge CLOCK_50);

        KEY[3] = 1'b0;
        repeat (5) @(negedge CLOCK_50);
        KEY[3] = 1'b1;

        repeat (100) @(negedge CLOCK_50);

        KEY[0] = 1'b0;
        KEY[2] = 1'b0;
        repeat (5) @(negedge CLOCK_50);
        KEY[0] = 1'b1;
        KEY[2] = 1'b1;

        repeat (1000) @(negedge CLOCK_50);

        $finish;
    end
endmodule