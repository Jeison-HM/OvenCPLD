`include "macros.v"

module adc_slave(
        input wire rst,
        input wire adc_int,
        input wire [3:0] data,
        output reg [7:0] digit_adc,
        output reg [7:0] current_temp,
        output reg [7:0] set_temp,
        output reg [3:0] set_time
    );

    // data sequence register
    reg [2:0] data_sequence = 3'd0;

    // data sequence logic
    always @(posedge adc_int, posedge rst)
    begin
        if (rst)
            data_sequence <= 3'd0;
        else
        begin
            case (data_sequence)
                3'd0:
                    `D_0 <= data;
                3'd1:
                    `D_1 <= data;
                3'd2:
                    `current_temp_0 <= data;
                3'd3:
                    `current_temp_1 <= data;
                3'd4:
                    `set_temp_0 <= data;
                3'd5:
                    `set_temp_1 <= data;
                3'd6:
                    set_time <= data;
            endcase
            if (data_sequence == 3'd6)
                data_sequence = 3'd0;
            else
                data_sequence = data_sequence + 3'd1;
        end
    end

endmodule //adc
