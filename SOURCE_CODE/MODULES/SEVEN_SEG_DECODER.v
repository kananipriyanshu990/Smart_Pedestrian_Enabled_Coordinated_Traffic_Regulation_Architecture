module SEVEN_SEG_DECODER (input  wire [7:0] seconds,
                          output reg [6:0] HEX0,
                          output reg [6:0] HEX1);

    reg [3:0] ones;
    reg [3:0] tens;

    always @(*) begin
        ones = seconds % 10;
        tens = (seconds / 10) % 10;

        case (ones)
            4'd0: HEX0 = 7'b1000000;
            4'd1: HEX0 = 7'b1111001;
            4'd2: HEX0 = 7'b0100100;
            4'd3: HEX0 = 7'b0110000;
            4'd4: HEX0 = 7'b0011001;
            4'd5: HEX0 = 7'b0010010;
            4'd6: HEX0 = 7'b0000010;
            4'd7: HEX0 = 7'b1111000;
            4'd8: HEX0 = 7'b0000000;
            4'd9: HEX0 = 7'b0010000;
            default: HEX0 = 7'b1111111;
        endcase

        case (tens)
            4'd0: HEX1 = 7'b1000000;
            4'd1: HEX1 = 7'b1111001;
            4'd2: HEX1 = 7'b0100100;
            4'd3: HEX1 = 7'b0110000;
            4'd4: HEX1 = 7'b0011001;
            4'd5: HEX1 = 7'b0010010;
            4'd6: HEX1 = 7'b0000010;
            4'd7: HEX1 = 7'b1111000;
            4'd8: HEX1 = 7'b0000000;
            4'd9: HEX1 = 7'b0010000;
            default: HEX1 = 7'b1111111;
        endcase
    end

endmodule