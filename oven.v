`define high 3'd0
`define set 3'd1
`define low 3'd2
`define idle 3'd3

`define interval 8'd10
`define upper_limit (set_temp + `interval)
`define lower_limit (set_temp - `interval)

module oven(
        input  clk,
        input  stop,
        input start,
        input [7:0] current_temp,
        input [7:0] set_temp,
        input [3:0] current_time,
        input [3:0] set_time,
        output led_stop,
        output led_start,
        output led_high,
        output led_set,
        output led_low,
        output horno
    );


    // == States ==

    reg [2:0] state = `idle;
    wire rst_timer;
    assign rst_timer = ~(state == `high | state == `set);
    // | ~(current_time < set_time & state == `low);

    // == Main System ==

    // state register
    always @(posedge clk)
    begin
        if (stop)
            state = `idle;
        // else if (set_temp < `interval)
        //     state <= `stop;
        else if (current_time == 4'd0)
            state = `idle;
        else if (start)
            state = `low;
        // state machine
        case (state)
            `high:
            begin
                if (current_temp <= `upper_limit)
                    state = `set;
            end
            `set:
            begin
                if (current_temp >= `upper_limit)
                    state = `high;
                else if (current_temp <= `lower_limit)
                    state = `low;
            end
            `low:
            begin
                if (current_temp >= `lower_limit)
                    state = `set;
            end
            default:
                state = `idle;
        endcase
    end
    // output logic
    // Mealy FSM
    assign led_stop = (stop);
    assign led_start = (state == `high | state == `set | state == `low);
    assign led_high = (current_temp >= `upper_limit & state == `high);
    assign led_set = (~(current_temp >= `upper_limit) & ~(current_temp <= `lower_limit) & state == `set);
    assign led_low = (current_temp <= `lower_limit & state == `low);
    assign horno = (current_temp <= `lower_limit & state == `low);

endmodule
