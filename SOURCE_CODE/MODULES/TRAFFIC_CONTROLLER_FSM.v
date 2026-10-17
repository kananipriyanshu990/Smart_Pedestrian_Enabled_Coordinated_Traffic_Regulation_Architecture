
module TRAFFIC_CONTROLLER_FSM #(parameter GREEN_SECONDS = 10,
                                parameter YELLOW_SECONDS = 3,
                                parameter ALL_RED_SECONDS = 1,
                                parameter PED_WALK_SECONDS = 5,
                                parameter PED_CLEAR_SECONDS = 2,
                                parameter GREEN_EXTENSION_SEC = 3) 
                               (input wire clk,
                                input wire reset,
                                input wire one_sec_tick,

                                input wire request_n,
                                input wire request_e,
                                input wire request_s,
                                input wire request_w,

                                output reg [1:0] north_color,
                                output reg [1:0] east_color,
                                output reg [1:0] south_color,
                                output reg [1:0] west_color,

                                output reg [3:0] pedestrian_walk,
                                output reg [7:0] remaining_seconds,
                                output wire [3:0] state_debug,
                                output reg ped_quota_used);

    localparam RED = 2'b00;
    localparam YELLOW = 2'b01;
    localparam GREEN = 2'b10;

    localparam ALL_RED_INIT = 4'd0;
    localparam NORTH_GREEN = 4'd1;
    localparam NORTH_YELLOW = 4'd2;
    localparam ALL_RED_N = 4'd3;
    localparam EAST_GREEN = 4'd4;
    localparam EAST_YELLOW  = 4'd5;
    localparam ALL_RED_E = 4'd6;
    localparam SOUTH_GREEN = 4'd7;
    localparam SOUTH_YELLOW = 4'd8;
    localparam ALL_RED_S = 4'd9;
    localparam WEST_GREEN = 4'd10;
    localparam WEST_YELLOW = 4'd11;
    localparam ALL_RED_W = 4'd12;
    localparam PED_WALK = 4'd13;
    localparam PED_CLEAR = 4'd14;

    reg [3:0] state;
    reg [3:0] saved_state;
    reg [3:0] pending_requests;
    reg [3:0] selected_pedestrian;

    reg [7:0] timer;
    reg [7:0] saved_remaining_time;

    wire [3:0] request_vector;

    assign request_vector = {request_w, request_s, request_e, request_n};

    assign state_debug = state;

    // Maintain all pending requests in one sequential block.
    always @(posedge clk) begin
        if (reset) begin
            pending_requests <= 4'b0000;
        end
        else begin
            if (state == PED_WALK)
                pending_requests <= (pending_requests & ~selected_pedestrian) | request_vector;
            else
                pending_requests <= pending_requests | request_vector;
        end
    end

    // Main traffic FSM and pedestrian interrupt control.
    always @(posedge clk) begin
        if (reset) begin
            state  <= ALL_RED_INIT;
            saved_state <= NORTH_GREEN;
            timer <= ALL_RED_SECONDS;
            saved_remaining_time <= 0;
            selected_pedestrian <= 4'b0000;
            ped_quota_used <= 1'b0;
        end
        else begin
            case (state)

                ALL_RED_INIT: begin
                    if (one_sec_tick) begin
                        if (timer <= 1) begin
                            state <= NORTH_GREEN;
                            timer <= GREEN_SECONDS;
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                NORTH_GREEN, EAST_GREEN,
                SOUTH_GREEN, WEST_GREEN: begin
                    if (!ped_quota_used &&
                        pending_requests != 4'b0000) begin

                        saved_state <= state;
                        saved_remaining_time <= timer;

                        if (pending_requests[0])
                            selected_pedestrian <= 4'b0001;
                        else if (pending_requests[1])
                            selected_pedestrian <= 4'b0010;
                        else if (pending_requests[2])
                            selected_pedestrian <= 4'b0100;
                        else
                            selected_pedestrian <= 4'b1000;

                        ped_quota_used <= 1'b1;
                        state <= PED_WALK;
                        timer <= PED_WALK_SECONDS;
                    end
                    else if (one_sec_tick) begin
                        if (timer <= 1) begin
                            case (state)
                                NORTH_GREEN: begin
                                    state <= NORTH_YELLOW;
                                    timer <= YELLOW_SECONDS;
                                end
                                EAST_GREEN: begin
                                    state <= EAST_YELLOW;
                                    timer <= YELLOW_SECONDS;
                                end
                                SOUTH_GREEN: begin
                                    state <= SOUTH_YELLOW;
                                    timer <= YELLOW_SECONDS;
                                end
                                WEST_GREEN: begin
                                    state <= WEST_YELLOW;
                                    timer <= YELLOW_SECONDS;
                                end
                            endcase
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                NORTH_YELLOW, EAST_YELLOW,
                SOUTH_YELLOW, WEST_YELLOW: begin
                    if (one_sec_tick) begin
                        if (timer <= 1) begin
                            case (state)
                                NORTH_YELLOW: begin
                                    state <= ALL_RED_N;
                                    timer <= ALL_RED_SECONDS;
                                end
                                EAST_YELLOW: begin
                                    state <= ALL_RED_E;
                                    timer <= ALL_RED_SECONDS;
                                end
                                SOUTH_YELLOW: begin
                                    state <= ALL_RED_S;
                                    timer <= ALL_RED_SECONDS;
                                end
                                WEST_YELLOW: begin
                                    state <= ALL_RED_W;
                                    timer <= ALL_RED_SECONDS;
                                end
                            endcase
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                ALL_RED_N: begin
                    if (one_sec_tick) begin
                        if (timer <= 1) begin
                            state <= EAST_GREEN;
                            timer <= GREEN_SECONDS;
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                ALL_RED_E: begin
                    if (one_sec_tick) begin
                        if (timer <= 1) begin
                            state <= SOUTH_GREEN;
                            timer <= GREEN_SECONDS;
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                ALL_RED_S: begin
                    if (one_sec_tick) begin
                        if (timer <= 1) begin
                            state <= WEST_GREEN;
                            timer <= GREEN_SECONDS;
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                ALL_RED_W: begin
                    if (one_sec_tick) begin
                        if (timer <= 1) begin
                            state <= NORTH_GREEN;
                            timer <= GREEN_SECONDS;
                            ped_quota_used <= 1'b0;
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                PED_WALK: begin
                    if (one_sec_tick) begin
                        if (timer <= 1) begin
                            state <= PED_CLEAR;
                            timer <= PED_CLEAR_SECONDS;
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                PED_CLEAR: begin
                    if (one_sec_tick) begin
                        if (timer <= 1) begin
                            state <= saved_state;
                            timer <= saved_remaining_time + GREEN_EXTENSION_SEC;
                        end
                        else
                            timer <= timer - 1'b1;
                    end
                end

                default: begin
                    state <= ALL_RED_INIT;
                    timer <= ALL_RED_SECONDS;
                    selected_pedestrian <= 4'b0000;
                    ped_quota_used <= 1'b0;
                end

            endcase
        end
    end

    // Decode vehicle and pedestrian outputs from the current state.
    always @(*) begin
        north_color = RED;
        east_color = RED;
        south_color = RED;
        west_color = RED;

        pedestrian_walk = 4'b0000;
        remaining_seconds = timer;

        case (state)
            NORTH_GREEN: north_color = GREEN;
            NORTH_YELLOW: north_color = YELLOW;

            EAST_GREEN: east_color = GREEN;
            EAST_YELLOW: east_color = YELLOW;

            SOUTH_GREEN: south_color = GREEN;
            SOUTH_YELLOW: south_color = YELLOW;

            WEST_GREEN: west_color = GREEN;
            WEST_YELLOW: west_color = YELLOW;

            PED_WALK: pedestrian_walk = selected_pedestrian;

            default: begin
                north_color = RED;
                east_color = RED;
                south_color = RED;
                west_color = RED;
            end
        endcase
    end

endmodule