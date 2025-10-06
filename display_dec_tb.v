`timescale 1ns / 1ps

module display_dec_tb;

    reg clk = 0;
    reg [3:0] digit = 0;

    // output declaration of module display_dec
    wire [7:0] word;

    display_dec u_display_dec(
                    .clk   	(clk    ),
                    .digit 	(digit  ),
                    .word  	(word   )
                );


    always #20 clk = ~clk; // 50Mhz Clock
    initial
    begin
        $dumpfile("display_dec.vcd");
        $dumpvars(0, display_dec_tb);
        #100 digit <= 3;
        #100 digit <= 9;
        #400;
        $finish;
    end
endmodule
