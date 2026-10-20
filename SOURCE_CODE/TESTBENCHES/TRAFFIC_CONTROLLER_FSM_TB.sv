`timescale 1ns/1ps

module TRAFFIC_CONTROLLER_FSM_TB;

    reg clk;
    reg reset;
    reg one_sec_tick;

    reg request_n;
    reg request_e;
    reg request_s;
    reg request_w;

    wire [1:0] north_color;
    wire [1:0] east_color;
    wire [1:0] south_color;
    wire [1:0] west_color;

    wire [3:0] pedestrian_walk;
    wire [7:0] remaining_seconds;
    wire [3:0] state_debug;
    wire ped_quota_used;

    TRAFFIC_CONTROLLER_FSM #(
        .GREEN_SECONDS(8),
        .YELLOW_SECONDS(3),
        .ALL_RED_SECONDS(1),
        .PED_WALK_SECONDS(4),
        .PED_CLEAR_SECONDS(2),
        .GREEN_EXTENSION_SEC(2)
    ) TRF_CNTLR_FSM (
        .clk(clk),
        .reset(reset),
        .one_sec_tick(one_sec_tick),
        .request_n(request_n),
        .request_e(request_e),
        .request_s(request_s),
        .request_w(request_w),
        .north_color(north_color),
        .east_color(east_color),
        .south_color(south_color),
        .west_color(west_color),
        .pedestrian_walk(pedestrian_walk),
        .remaining_seconds(remaining_seconds),
        .state_debug(state_debug),
        .ped_quota_used(ped_quota_used)
    );

    always #5 clk = ~clk;

    // Generate a one-clock-wide tick every 100 ns (one simulated second).
    initial begin
        one_sec_tick = 1'b0;
        forever begin
            #90 one_sec_tick = 1'b1;
            #10 one_sec_tick = 1'b0;
        end
    end

    // Keep requests inactive to observe one uninterrupted vehicle cycle.
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        request_n = 1'b0;
        request_e = 1'b0;
        request_s = 1'b0;
        request_w = 1'b0;

        #40 reset = 1'b0;
        
        #5960 $finish;
    end

endmodule
