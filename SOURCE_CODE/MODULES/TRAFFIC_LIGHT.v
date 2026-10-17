module TRAFFIC_LIGHT (input  wire [1:0] color,
                      output reg red,
                      output reg yellow,
                      output reg green);

    always @(*) begin
        red = 1'b0;
        yellow = 1'b0;
        green = 1'b0;

        case (color)
            2'b00: red = 1'b1;
            2'b01: yellow = 1'b1;
            2'b10: green = 1'b1;
            default: red = 1'b1;
        endcase
    end

endmodule