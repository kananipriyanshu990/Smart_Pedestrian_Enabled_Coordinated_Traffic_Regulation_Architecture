`timescale 1ns/1ps

module TRAFFIC_LIGHT_TOP_TB;

    reg CLOCK_50;
    reg [9:0] SW;
    reg [3:0] KEY;

    wire RED_NORTH, YELLOW_NORTH, GREEN_NORTH;
    wire RED_EAST, YELLOW_EAST, GREEN_EAST;
    wire RED_SOUTH, YELLOW_SOUTH, GREEN_SOUTH;
    wire RED_WEST, YELLOW_WEST, GREEN_WEST;

    wire WALK_NORTH, DONT_WALK_NORTH;
    wire WALK_EAST, DONT_WALK_EAST;
    wire WALK_SOUTH, DONT_WALK_SOUTH;
    wire WALK_WEST, DONT_WALK_WEST;

    wire [6:0] HEX0, HEX1, HEX2, HEX3;

    // Use a 1 kHz parameterized clock rate for manageable simulation time.
    // The test keeps all push buttons released to show a complete,
    // uninterrupted vehicle sequence in the integrated top-level design.
    TRAFFIC_LIGHT_TOP #(
        .CLK_FREQ_HZ(1000),
        .DEBOUNCE_MS(20),
        .GREEN_SECONDS(8),
        .YELLOW_SECONDS(3),
        .ALL_RED_SECONDS(1),
        .PED_WALK_SECONDS(4),
        .PED_CLEAR_SECONDS(2),
        .GREEN_EXTENSION_SEC(2)
    ) TRF_LT_TOP (
        .CLOCK_50(CLOCK_50),
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
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    always #10 CLOCK_50 = ~CLOCK_50;

    initial begin
        CLOCK_50 = 1'b0;
        SW = 10'b0;
        KEY = 4'b1111;       // Active-low buttons: all released
        SW[0] = 1'b1;        // Assert active-high reset
        #100 SW[0] = 1'b0;   // Release reset after five clock cycles

        // 48 phase-seconds x 1000 clocks/second x 20 ns/clock
        // = 960,000 ns. Run slightly longer to show the next phase start.
        #1_000_000 $finish;
    end

endmodule
