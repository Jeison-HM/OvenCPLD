`include "macros.v"

module oven(
        input wire clk,
        input wire start,
        input wire stop,
        input wire [3:0] adc_data,
        input wire adc_int,
        output wire [7:0] D_enable,
        output wire [7:0] D_out,
        output wire [3:0] led,
        output reg led_stop,
        output wire oven,
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
    assign adc_enable = (`clk_250);
    wire [7:0] digit_adc;
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

    // input declaration of module timer
    reg start_timer = 1'b0;

    // output declaration of module timer
    wire [7:0] digit_time;
    wire [3:0] current_time;

    timer u_timer(
              .clk          	(`clk_1000     ),
              .rst          	(start         ),
              .stop             (stop          ),
              .start_timer  	(start_timer   ),
              .set_time     	(set_time      ),
              .digit_time   	(digit_time    ),
              .current_time 	(current_time  )
          );

    // == States ==

    reg [1:0] state = `idle;
    reg [1:0] next_state = `idle;

    // == Main System ==

    always @(posedge clk or posedge stop)
    begin
        if (stop)
            state <= `idle;
        else
            state <= next_state;
    end

    // mealy FSM
    always @(posedge clk)
    begin
        case (state)
            `idle:
            begin
                start_timer = 1'b0;
                if (stop)
                    next_state = `idle;
                else if (start)
                    next_state = `low;
                else
                    next_state = `idle;
            end
            `low:
            begin
                if (current_temp >= `lower_limit)
                    next_state = `set;
                else
                    next_state = `low;
            end
            `set:
            begin
                start_timer = 1'b1;
                if (current_temp > `upper_limit)
                    next_state = `high;
                else if (current_temp < `lower_limit)
                    next_state = `low;
                else
                    next_state = `set;
            end
            `high:
            begin
                if (current_temp <= `upper_limit)
                    next_state = `set;
                else
                    next_state = `high;
            end
            default:
                next_state = `idle;
        endcase
        if (current_time == 4'd0)
            next_state = `idle;
    end
    // output logic
    assign `led_start = ~stop;
    assign `led_high = (current_temp >= `upper_limit & state == `high);
    assign `led_set = (~(current_temp > `upper_limit) & ~(current_temp < `lower_limit) & state == `set);
    assign `led_low = (current_temp <= `lower_limit & state == `low);
    assign oven = (current_temp <= `lower_limit & state == `low);

    // == Stop Blink ==

    always @(posedge `clk_250)
    begin
        if (stop)
            led_stop <= ~led_stop;
        else
            led_stop <= 1'b0;
    end

endmodule //oven
