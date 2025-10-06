`timescale 1ns / 1ps

module oven_tb;

    reg clk = 0;

    // input declaration of module oven
    reg start = 0;
    reg stop = 0;
    reg [11:0] adc = 12'd2025;
    reg [7:0] set_temp = 8'd150;
    reg [3:0] set_timer = 4'd13;


    // output declaration of module oven
    wire [4:0] led;
    wire [7:0] D_enable;
    wire [7:0] D_out;
    wire oven;

    oven u_oven(
             .clk       	(clk        ),
             .start 	(start  ),
             .stop  	(stop   ),
             .adc       	(adc        ),
             .set_temp  	(set_temp   ),
             .set_timer 	(set_timer  ),
             .led       	(led        ),
             .D_enable  	(D_enable   ),
             .D_out     	(D_out      ),
             .oven     	(oven      )
         );


    always #20 clk = ~clk; // 50Mhz Clock

    initial
    begin
        $dumpfile("oven.vcd");
        $dumpvars(0, oven_tb);
        #10 start = ~start;
        #1000;
        #10 stop = ~stop;
        $finish;
    end
endmodule
