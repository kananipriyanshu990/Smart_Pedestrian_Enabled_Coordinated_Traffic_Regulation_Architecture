
module TRAFFIC_LIGHT_TOP #(parameter CLK_FREQ_HZ = 50000000,
                           parameter DEBOUNCE_MS = 20,
                           parameter GREEN_SECONDS = 10,
                           parameter YELLOW_SECONDS = 3,
                           parameter ALL_RED_SECONDS = 1,
                           parameter PED_WALK_SECONDS = 5,
                           parameter PED_CLEAR_SECONDS = 2,
                           parameter GREEN_EXTENSION_SEC = 3) 
                           (input wire CLOCK_50,
                            input wire [9:0] SW,
                            input wire [3:0] KEY,

                            output wire RED_NORTH,
                            output wire YELLOW_NORTH,
                            output wire GREEN_NORTH,

                            output wire RED_EAST,
                            output wire YELLOW_EAST,
                            output wire GREEN_EAST,

                            output wire RED_SOUTH,
                            output wire YELLOW_SOUTH,
                            output wire GREEN_SOUTH,

                            output wire RED_WEST,
                            output wire YELLOW_WEST,
                            output wire GREEN_WEST,

                            output wire WALK_NORTH,
                            output wire DONT_WALK_NORTH,

                            output wire WALK_EAST,
                            output wire DONT_WALK_EAST,

                            output wire WALK_SOUTH,
                            output wire DONT_WALK_SOUTH,

                            output wire WALK_WEST,
                            output wire DONT_WALK_WEST,

                            output wire [6:0] HEX0,
                            output wire [6:0] HEX1);

    wire one_sec_tick;

    wire request_n;
    wire request_e;
    wire request_s;
    wire request_w;

    wire [1:0] north_color;
    wire [1:0] east_color;
    wire [1:0] south_color;
    wire [1:0] west_color;

    wire [3:0] pedestrian_walk;
    wire [7:0] remaining_seconds;
    wire [3:0] state_debug;
    wire ped_quota_used;

    CLOCK_ENABLE_GEN #(.CLK_FREQ_HZ(CLK_FREQ_HZ)) 
    CLOCK_GENERATOR (.clk(CLOCK_50),
                     .reset(SW[0]),
                     .one_sec_tick(one_sec_tick));

    BUTTON_SYNC_DEBOUNCE #(.CLK_FREQ_HZ(CLK_FREQ_HZ),
                           .DEBOUNCE_MS(DEBOUNCE_MS)) 
    BUTTON_HANDLER (.clk(CLOCK_50),
                    .reset(SW[0]),
                    .button_n(KEY[0]),
                    .button_e(KEY[1]),
                    .button_s(KEY[2]),
                    .button_w(KEY[3]),
                    .request_n(request_n),
                    .request_e(request_e),
                    .request_s(request_s),
                    .request_w(request_w));

    TRAFFIC_CONTROLLER_FSM #(.GREEN_SECONDS(GREEN_SECONDS),
                             .YELLOW_SECONDS(YELLOW_SECONDS),
                             .ALL_RED_SECONDS(ALL_RED_SECONDS),
                             .PED_WALK_SECONDS(PED_WALK_SECONDS),
                             .PED_CLEAR_SECONDS(PED_CLEAR_SECONDS),
                             .GREEN_EXTENSION_SEC(GREEN_EXTENSION_SEC)) 
    TRAFFIC_CONTROLLER (.clk(CLOCK_50),
                        .reset(SW[0]),
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

    TRAFFIC_LIGHT NORTH_LIGHT (.color(north_color),
                               .red(RED_NORTH),
                               .yellow(YELLOW_NORTH),
                               .green(GREEN_NORTH));

    TRAFFIC_LIGHT EAST_LIGHT (.color(east_color),
                              .red(RED_EAST),
                              .yellow(YELLOW_EAST),
                              .green(GREEN_EAST));

    TRAFFIC_LIGHT SOUTH_LIGHT (.color(south_color),
                               .red(RED_SOUTH),
                               .yellow(YELLOW_SOUTH),
                               .green(GREEN_SOUTH));

    TRAFFIC_LIGHT WEST_LIGHT (.color(west_color),
                              .red(RED_WEST),
                              .yellow(YELLOW_WEST),
                              .green(GREEN_WEST));

    PEDESTRIAN_SIGNAL NORTH_PEDESTRIAN (.walk_enable(pedestrian_walk[0]),
                                        .walk(WALK_NORTH),
                                        .dont_walk(DONT_WALK_NORTH));

    PEDESTRIAN_SIGNAL EAST_PEDESTRIAN (.walk_enable(pedestrian_walk[1]),
                                       .walk(WALK_EAST),
                                       .dont_walk(DONT_WALK_EAST));

    PEDESTRIAN_SIGNAL SOUTH_PEDESTRIAN (.walk_enable(pedestrian_walk[2]),
                                        .walk(WALK_SOUTH),
                                        .dont_walk(DONT_WALK_SOUTH));

    PEDESTRIAN_SIGNAL WEST_PEDESTRIAN (.walk_enable(pedestrian_walk[3]),
                                       .walk(WALK_WEST),
                                       .dont_walk(DONT_WALK_WEST));

    SEVEN_SEG_DECODER COUNTDOWN_DISPLAY (.seconds(remaining_seconds),
                                         .HEX0(HEX0),
                                         .HEX1(HEX1));
endmodule