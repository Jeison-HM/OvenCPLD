`timescale 1ns / 1ps

module timer_tb;

    reg clk = 0;
    reg [3:0] set_timer = 0;

    // output declaration of module timer
    // reg timeout;
    reg [7:0] digit_time;

    timer u_timer(
              .clk        	(clk         ),
              .set_timer  	(set_timer   ),
              .digit_time 	(digit_time  )
          );


    always #20 clk = ~clk; // 50Mhz Clock
    initial
    begin
        $dumpfile("timer.vcd");
        $dumpvars(0, timer_tb);
        #100 set_timer = 13;
        #1000;
        #1000;
        $finish;
    end
endmodule
