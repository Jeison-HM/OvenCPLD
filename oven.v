// == Main System ==

always @(posedge clk or posedge stop or posedge start)
begin
    if (stop)
    begin
        horno <= 1'b0;
        led[4:1] <= 4'b0;
    end
    else if (start)
    begin
        // SHOULD LEDS BE CONNECTED WITH STATE START OR STOP? In that case both leds could be on.
        `led_start <= 1'b1;

        if (current_time >= set_timer)
        begin
            // Timeout
            horno <= 1'b0;
            `led_high <= 1'b0;
            `led_set <= 1'b0;
            `led_low <= 1'b0;
        end
        else
        begin
            // State Machine

            case (state)
                `state_high:
                begin
                    if (`temp >= (set_temp + 8'd10))
                    begin
                        horno <= 1'b0;
                        `led_high <= 1'b1;
                        `led_set <= 1'b0;
                        `led_low <= 1'b0;
                    end
                    else
                        state <= `state_set;
                end
                `state_set:
                begin
                    if (`temp >= set_temp)
                    begin
                        horno <= 1'b0;
                        `led_high <= 1'b0;
                        `led_set <= 1'b1;
                        `led_low <= 1'b0;
                        state <= `state_high;
                    end
                    else
                        state <= `state_low;
                end
                `state_low:
                    if (`temp <= (set_temp - 8'd10))
                    begin
                        horno <= 1'b1;
                        `led_high <= 1'b0;
                        `led_set <= 1'b0;
                        `led_low <= 1'b1;
                    end
                    else
                        state <= `state_set;
                default:
                    state <= `state_high;
            endcase
        end
    end
end
