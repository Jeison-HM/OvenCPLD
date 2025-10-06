`include "macros.v"

module adc(
        input wire clk,
        input wire rst,
        input wire [11:0] adc,
        output reg [15:0] digit_adc
    );

    initial
    begin
        digit_adc = 16'b0;
    end

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            digit_adc <= 16'b0;
        end
        else
        begin
            // Aprox. 16mV per degree

            // Temperature
            // Using "=" to follow order sequence
            `D_0 = `temp >> 10;
            `D_1 = (`temp - (`D_0 << 10)) >> 7;
            `D_2 = (`temp - (`D_0 << 10) - (`D_1 << 7)) >> 3;
            `D_3 = (`temp - (`D_0 << 10) - (`D_1 << 7) - (`D_2 << 3)) >> 1;
        end
    end

endmodule //adc
