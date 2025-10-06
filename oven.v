`define stop 3'd0
`define high 3'd1
`define set 3'd2
`define low 3'd3

`define interval 8'd10
`define upper_limit (set_temp + `interval)
`define lower_limit (set_temp - `interval)

module oven(
        input  clk,
        input  stop,
        input start,
        input [7:0] temp,
        input [7:0] set_temp,
        input [3:0] timer,
        input [3:0] set_timer,
        output led_stop,
        output led_start,
        output led_high,
        output led_set,
        output led_low,
        output horno
    );


    reg [2:0] state = `stop;
    reg [2:0] nextstate = `stop;

    // state register
    always @(posedge clk, posedge stop, posedge start)
        if (stop)
            state <= `stop;
        else if (timer >= set_timer)
            state <= `stop;
        else if (set_temp < `interval)
            state <= `stop;
        else if (start)
            state <= nextstate;
    // next state logic
    always @(posedge clk)
    case (state)
        `stop:
            if (stop)
                nextstate = `stop;
            else
                nextstate = `low;
        `high:
            if (temp >= `upper_limit)
                nextstate = `high;
            else
                nextstate <= `set;
        `set:
            if (temp >= `upper_limit)
                nextstate <= `high;
            else if (temp <= `lower_limit)
                nextstate = `low;
            else
                nextstate = `set;
        `low:
            if (temp <= `lower_limit)
                nextstate = `low;
            else
                nextstate = `set;
        default:
            nextstate = `stop;
    endcase
    // output logic
    // Mealy FSM
    assign led_stop = (state == `stop);
    assign led_start = (state == `high | state == `set | state == `low);
    assign led_high = (temp >= `upper_limit & state == `high);
    assign led_set = (~(temp >= `upper_limit) & ~(temp <= `lower_limit) & state == `set);
    assign led_low = (temp <= `lower_limit & state == `low);
    assign horno = (temp <= `lower_limit & state == `low);

endmodule
