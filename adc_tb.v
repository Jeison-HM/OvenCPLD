`timescale 1ns / 1ps

module adc_tb;

    reg clk = 0;

    // input declaration of module adc
    reg [11:0] data;

    // output declaration of module adc
    wire [7:0] temp;
    wire [15:0] digit_adc;

    adc u_adc(
            .clk       	(clk        ),
            .data      	(data       ),
            .temp      	(temp       ),
            .digit_adc 	(digit_adc  )
        );


    always #20 clk = ~clk; // 50Mhz Clock
    initial
    begin
        $dumpfile("adc.vcd");
        $dumpvars(0, adc_tb);
        #10 data <= 12'd2500;
        #50 data <= 12'd500;
        #400;
        $finish;
    end
endmodule
