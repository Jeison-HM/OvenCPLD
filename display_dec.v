`include "macros.v"

module display_dec(
        input wire clk,
        input wire [3:0] digit,
        output reg [7:0] word
    );

    always @(posedge clk)
    begin
        case (digit)
            4'd0:
                word <= `n0;
            4'd1:
                word <= `n1;
            4'd2:
                word <= `n2;
            4'd3:
                word <= `n3;
            4'd4:
                word <= `n4;
            4'd5:
                word <= `n5;
            4'd6:
                word <= `n6;
            4'd7:
                word <= `n7;
            4'd8:
                word <= `n8;
            4'd9:
                word <= `n9;
            default:
                word <= `n0;
        endcase
    end

endmodule //display_dec
