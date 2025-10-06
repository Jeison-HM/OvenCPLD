`timescale 1ns / 1ps

module oven_tb;

    reg clk = 0;

    // input declaration of module oven
    reg stop = 0;
    reg start = 0;
    reg [7:0] current_temp = 5;
    reg [7:0] set_temp = 0;
    reg [3:0] current_time = 4'd5;
    reg [3:0] set_time = 0;

    // output declaration of module oven
    wire led_stop;
    wire led_start;
    wire led_high;
    wire led_set;
    wire led_low;
    wire horno;

    oven u_oven(
             .clk       	(clk        ),
             .stop     	    (stop       ),
             .start         (start      ),
             .current_temp  (current_temp       ),
             .set_temp  	(set_temp   ),
             .current_time  (current_time      ),
             .set_time 	    (set_time  ),
             .led_stop  	(led_stop   ),
             .led_start 	(led_start  ),
             .led_high  	(led_high   ),
             .led_set   	(led_set    ),
             .led_low   	(led_low    ),
             .horno     	(horno      )
         );


    always #20 clk = ~clk; // 50Mhz Clock
    initial
    begin
        $dumpfile("oven.vcd");
        $dumpvars(0, oven_tb);
        #10 start = ~start;
        #10 set_temp = 8'd35;
        #10 set_time = 4'd8;
        #50 start = ~start;
        #100 current_temp = 8'd10;
        #100 current_temp = 8'd20;
        #50 start = ~start;
        #50 start = ~start;
        #100 current_temp = 8'd5;
        #100 current_temp = 8'd7;
        #100 current_temp = 8'd8;
        #100 current_temp = 8'd9;
        #100 current_temp = 8'd1;
        #100 current_temp = 8'd15;
        #100 current_temp = 8'd0;
        #100 current_temp = 8'd1;
        #100 current_temp = 8'd3;
        #100 current_temp = 8'd59;
        #100 current_temp = 8'd61;
        #100 current_temp = 8'd62;
        #100 current_temp = 8'd70;
        #100 current_temp = 8'd40;
        #100 current_temp = 8'd0;
        #100 current_temp = 8'd55;
        #100 current_temp = 8'd40;
        #100 stop = ~stop;
        #100 start = ~start;
        #50 start = ~start;
        #100 stop = ~stop;
        #50 stop = ~stop;
        #100 start = ~start;
        #50 stop = ~stop;
        #400;
        $finish;
    end
endmodule
