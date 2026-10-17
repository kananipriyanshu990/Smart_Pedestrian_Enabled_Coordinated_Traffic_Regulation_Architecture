module BUTTON_SYNC_DEBOUNCE #(parameter CLK_FREQ_HZ = 50000000,
                              parameter DEBOUNCE_MS = 20) 
                             (input wire clk,
                              input wire reset,
                              input wire button_n,
                              input wire button_e,
                              input wire button_s,
                              input wire button_w,
                              output reg request_n,
                              output reg request_e,
                              output reg request_s,
                              output reg request_w);

    localparam integer DEBOUNCE_COUNT =
        (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;

    reg [3:0] button_meta;
    reg [3:0] button_sync;
    reg [3:0] button_state;
    reg [3:0] button_previous;

    reg [31:0] debounce_count [0:3];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            button_meta <= 4'b1111;
            button_sync <= 4'b1111;
        end
        else begin
            button_meta <= {button_w, button_s, button_e, button_n};
            button_sync <= button_meta;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            button_state    <= 4'b1111;
            button_previous <= 4'b1111;

            request_n <= 1'b0;
            request_e <= 1'b0;
            request_s <= 1'b0;
            request_w <= 1'b0;

            for (i = 0; i < 4; i = i + 1)
                debounce_count[i] <= 0;
        end
        else begin
            request_n <= 1'b0;
            request_e <= 1'b0;
            request_s <= 1'b0;
            request_w <= 1'b0;

            for (i = 0; i < 4; i = i + 1) begin
                if (button_sync[i] == button_state[i]) begin
                    debounce_count[i] <= 0;
                end
                else if (debounce_count[i] >= DEBOUNCE_COUNT - 1) begin
                    button_state[i] <= button_sync[i];
                    debounce_count[i] <= 0;
                end
                else begin
                    debounce_count[i] <= debounce_count[i] + 1;
                end
            end

            button_previous <= button_state;

            request_n <= button_previous[0] & ~button_state[0];
            request_e <= button_previous[1] & ~button_state[1];
            request_s <= button_previous[2] & ~button_state[2];
            request_w <= button_previous[3] & ~button_state[3];
        end
    end

endmodule