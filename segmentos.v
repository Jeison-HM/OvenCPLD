`include "macros.v"

module segmentos(
        input wire clk,
        input wire rst,
        input wire [7:0] digit_adc,
        input wire [7:0] digit_time,
        output reg [7:0] D_enable,
        output reg [7:0] D_out
    );

    reg [2:0] c = 3'd1;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            D_enable <= 8'b0;
            D_out <= 8'b0;
        end
        else
        begin
            D_enable = 8'b10000000 >> c;
            case (D_enable)
                8'b10000000:
                    D_out <= `c;
                8'b01000000:
                    D_out <= `equal;
                8'b00100000:
                begin
                    `display_dec(`D_0);
                end
                8'b00010000:
                begin
                    `display_dec(`D_1);
                end
                8'b00001000:
                    D_out <= `t;
                8'b00000100:
                    D_out <= `equal;
                8'b00000010:
                begin
                    `display_dec(`M_0);
                end
                8'b00000001:
                begin
                    `display_dec(`M_1);
                end
                default:
                    D_enable <= 8'b0;
            endcase
            c <= c + 3'd1;
            if (c == 3'd7)
                c <= 0;
        end
    end

endmodule
