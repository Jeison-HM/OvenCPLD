//  == Anodo Comun ==

// Alphabet

`define A 8'b10001000
`define b 8'b10000011
`define c 8'b11000110
`define d 8'b10100001
`define E 8'b10000110
`define F 8'b10001110
`define G 8'b11000010
`define H 8'b10001001
`define i 8'b11111011
`define J 8'b11100001
`define L 8'b11000111
`define n 8'b10101011
`define o 8'b10100011
`define P 8'b10001100
`define q 8'b10011000
`define r 8'b10101111
`define S 8'b10010010
`define t 8'b10000111
`define U 8'b11000001
`define v 8'b11100011
`define y 8'b10010001

// Numbers

`define n0 8'b11000000
`define n1 8'b11111001
`define n2 8'b10100100
`define n3 8'b10110000
`define n4 8'b10011001
`define n5 8'b10010010
`define n6 8'b10000010
`define n7 8'b11111000
`define n8 8'b10000000
`define n9 8'b10010000

// Symbols

`define space 8'b11111111
`define dash  8'b10111111
`define equal 8'b10110111

// LEDs

// `define led_stop    led[0]
`define led_start   led[0]
`define led_high    led[1]
`define led_set     led[2]
`define led_low     led[3]

// Temperature

`define current_temp_0 current_temp[3:0]
`define current_temp_1 current_temp[7:4]
`define set_temp_0 set_temp[3:0]
`define set_temp_1 set_temp[7:4]

// Digits in ADC

`define D_0 digit_adc[3:0]
`define D_1 digit_adc[7:4]

// Digits in Timer

`define M_0 digit_time[3:0]
`define M_1 digit_time[7:4]

// Clocks

`define clk_1 clk_out[0]
`define clk_250 clk_out[1]
`define clk_1000 clk_out[2]

// State Machine

`define idle 2'd0
`define low 2'd1
`define set 2'd2
`define high 2'd3

// Constants

`define interval 8'd10
`define upper_limit (set_temp + `interval)
`define lower_limit (set_temp - `interval)

// Display decimal numbers

`define display_dec(digit) \
                    case (digit)\
                        4'd0:\
                            D_out <= `n0;\
                        4'd1:\
                            D_out <= `n1;\
                        4'd2:\
                            D_out <= `n2;\
                        4'd3:\
                            D_out <= `n3;\
                        4'd4:\
                            D_out <= `n4;\
                        4'd5:\
                            D_out <= `n5;\
                        4'd6:\
                            D_out <= `n6;\
                        4'd7:\
                            D_out <= `n7;\
                        4'd8:\
                            D_out <= `n8;\
                        4'd9:\
                            D_out <= `n9;\
                        default:\
                            D_out <= `n0;\
                    endcase\
