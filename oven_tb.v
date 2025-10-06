`timescale 1ns / 1ps

module horno_tb;

    reg clk = 0;

    // input declaration of module horno
    reg start = 0;
    reg stop = 0;
    reg [11:0] adc = 12'd2025;
    reg [7:0] set_temp = 8'd150;
    reg [3:0] set_timer = 4'd13;


    // output declaration of module horno
    wire [4:0] led;
    wire [7:0] D_enable;
    wire [7:0] D_out;
    wire horno;

    horno u_horno(
              .clk       	(clk        ),
              .start 	(start  ),
              .stop  	(stop   ),
              .adc       	(adc        ),
              .set_temp  	(set_temp   ),
              .set_timer 	(set_timer  ),
              .led       	(led        ),
              .D_enable  	(D_enable   ),
              .D_out     	(D_out      ),
              .horno     	(horno      )
          );


    always #20 clk = ~clk; // 50Mhz Clock

    initial
    begin
        $dumpfile("horno.vcd");
        $dumpvars(0, horno_tb);
        #10 start = ~start;
        #1000;
        #10 stop = ~stop;
        $finish;
    end
endmodule
