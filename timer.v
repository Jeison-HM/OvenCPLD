`include "macros.v"

module timer(
        input wire clk,
        input wire rst,
        input wire stop,
        input wire start_timer,
        input wire [3:0] set_time,
        output reg [7:0] digit_time,
        output reg [3:0] current_time
    );

    always @(posedge clk or posedge rst or posedge stop)
    begin
        if (rst | stop)
        begin
            current_time <= set_time;
            if (set_time >= 4'd10)
            begin
                `M_0 <= 4'd1;
                `M_1 <= set_time - 4'd10;
            end
            else
                `M_1 <= set_time;
        end
        else
        begin
            if (start_timer)
            begin
                if (`M_1 > 4'd0)
                    `M_1 <= `M_1 - 4'b1;
                else if (`M_0 > 4'd0)
                begin
                    `M_0 <= `M_0 - 4'b1;
                    `M_1 <= 4'd9;
                end
                current_time <= current_time - 4'b1;
            end
        end
    end

endmodule //timer
