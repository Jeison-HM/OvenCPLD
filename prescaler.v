module prescaler(
        input wire clk,
        output reg [2:0] clk_out
    );

    initial
    begin
        clk_out = 3'b0;
    end

    reg [15:0] c_0 = 16'd0;     // 1mS
    reg [7:0] c_1 = 8'd0;       // 250mS
    reg  c_2 = 1'd0;       // 1S

    always @(posedge clk)
    begin
        c_0 <= c_0 + 1'd1;
        if (c_0 == 16'd49_999)
        begin
            c_0 <= 16'd0;
            clk_out[0] <= ~clk_out[0];
        end
    end

    always @(posedge clk_out[0])
    begin
        c_1 <= c_1 + 1'd1;
        if (c_1 == 8'd83)
        begin
            c_1 <= 8'd0;
            clk_out[1] <= ~(clk_out[1]);
        end
    end

    always @(posedge clk_out[1])
    begin
        c_2 <= c_2 + 1'd1;
        if (c_2 == 1'd1)
        begin
            c_2 <= 1'd0;
            clk_out[2] <= ~(clk_out[2]);
        end
    end

endmodule
