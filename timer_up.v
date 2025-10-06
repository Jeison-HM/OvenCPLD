`include "macros.v"

module timer_up(
        input wire clk,
        input wire rst,
        input wire [3:0] set_time,
        output reg [7:0] digit_time,
        output reg [3:0] current_time
    );

    initial
    begin
        current_time = set_time;
        `M_0 = 4'b0;
        `M_1 = 4'b0;
    end

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            current_time = 4'b0;
            `M_0 = 4'b0;
            `M_1 = 4'b0;
        end
        else
        begin
            // if (current_time < 4'd15)
            current_time <= current_time + 1'b1;
            if (`M_1 < 4'd9)
                `M_1 <= `M_1 + 1'b1;
            else if (`M_0 < 4'd9)
            begin
                `M_0 <= `M_0 + 1'b1;
                `M_1 <= 4'b0;
            end
        end
    end

endmodule //timer
