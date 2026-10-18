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

    TRAFFIC_CONTROLLER_FSM #(.GREEN_SECONDS(8),
                             .YELLOW_SECONDS(3),
                             .ALL_RED_SECONDS(1),
                             .PED_WALK_SECONDS(4),
                             .PED_CLEAR_SECONDS(2),
                             .GREEN_EXTENSION_SEC(2)) 
    TRF_CNTLR_FSM(.clk(clk),
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
                  .ped_quota_used(ped_quota_used));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        one_sec_tick = 0;

        request_n = 0;
        request_e = 0;
        request_s = 0;
        request_w = 0;

        repeat (4) @(negedge clk);
        reset = 0;

        forever begin
            repeat (10) @(negedge clk);
            one_sec_tick = 1;
            @(negedge clk);
            one_sec_tick = 0;
        end
    end

    initial begin

        repeat (1000000) @(negedge clk);
        $finish;
    end

endmodule