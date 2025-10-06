`include "macros.v"

module horno(
        input wire clk,
        input wire start,
        input wire stop,
        input wire [3:0] adc_data,
        input wire adc_int,
        output wire [7:0] D_enable,
        output wire [7:0] D_out,
        output wire [3:0] led,
        output reg led_stop,
        output wire horno,
        output wire adc_enable
    );

    initial
    begin
        led_stop = 1'b0;
    end

    // == Clocks ==

    // output declaration of module prescaler
    wire [2:0] clk_out;

    prescaler u_prescaler(
                  .clk     	(clk      ),
                  .clk_out 	(clk_out  )
              );

    // == Intances ==

    segmentos u_segmentos(
                  .clk      	(`clk_1      ),
                  .rst          (stop        ),
                  .digit_adc    (digit_adc   ),
                  .digit_time   (digit_time  ),
                  .D_enable 	(D_enable    ),
                  .D_out    	(D_out       )
              );

    // output declaration of module adc_slave
    assign adc_enable = (`clk_250 & (state == `high | state == `set | state == `low));
    wire [15:0] digit_adc;
    wire [7:0] current_temp;
    wire [7:0] set_temp;
    wire [3:0] set_time;

    adc_slave u_adc_slave(
                  .rst          	(stop          ),
                  .data         	(adc_data      ),
                  .adc_int      	(adc_int       ),
                  .digit_adc    	(digit_adc     ),
                  .current_temp 	(current_temp  ),
                  .set_temp     	(set_temp      ),
                  .set_time    	    (set_time      )
              );

    // output declaration of module timer
    wire [7:0] digit_time;
    wire [3:0] current_time;

    timer u_timer(
              .clk          	(`clk_1000     ),
              .rst          	(rst_timer     ),
              .set_time     	(set_time      ),
              .digit_time   	(digit_time    ),
              .current_time 	(current_time  )
          );

    // == States ==

    reg [2:0] state = `stop;
    reg [2:0] nextstate = `stop;
    reg rst_timer = 1'b1;

    // == Main System ==

    // state register
    always @(posedge clk, posedge stop, posedge start)
        if (stop)
            state <= `stop;
    // else if (current_time >= set_time)
    //     state <= `stop;
    // else if (set_temp < `interval)
    //     state <= `stop;
        else
            state <= nextstate;
    // next state logic
    always @(posedge clk)
    begin
        case (state)
            `stop:
            begin
                rst_timer = 1'b1;
                // if (stop)
                //     nextstate = `stop;
                // if (!start)
                //     nextstate = `stop;
                if (start)
                begin
                    rst_timer = 1'b0;
                    nextstate = `low;
                end
            end
            `high:
                if (current_time >= set_time)
                    nextstate = `timeout;
                else if (current_temp >= `upper_limit)
                    nextstate = `high;
                else
                    nextstate = `set;
            `set:
                if (current_time >= set_time)
                    nextstate = `timeout;
                else if (current_temp >= `upper_limit)
                    nextstate = `high;
                else if (current_temp <= `lower_limit)
                    nextstate = `low;
                else
                    nextstate = `set;
            `low:
                if (current_time >= set_time)
                    nextstate = `timeout;
                else if (current_temp <= `lower_limit)
                    nextstate = `low;
                else
                    nextstate = `set;
            `idle:
                rst_timer = 1'b1;
            default:
                nextstate = `stop;
        endcase
    end
    // output logic
    // Mealy FSM
    // assign `led_stop = (state == `stop);
    assign `led_start = (state == `high | state == `set | state == `low);
    assign `led_high = (current_temp >= `upper_limit & state == `high);
    assign `led_set = (~(current_temp >= `upper_limit) & ~(current_temp <= `lower_limit) & state == `set);
    assign `led_low = (current_temp <= `lower_limit & state == `low);
    assign horno = (current_temp <= `lower_limit & state == `low);

    // == Stop Blink ==

    always @(posedge `clk_250)
    begin
        if (stop)
            led_stop <= ~led_stop;
        else
            led_stop <= 1'b0;
    end


endmodule //horno
