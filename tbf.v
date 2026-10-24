module testingdatapath;
    reg clk;
    reg reset;
    reg valid_in;
    reg signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7;
    wire valid_out;
    wire signed [7:0] y0, y1, y2, y3, y4, y5, y6, y7;
    integer i;

    radix2_pipelined_fft dut(
        .clk(clk), .reset(reset), .valid_in(valid_in),
        .in0(x0), .in1(x1), .in2(x2), .in3(x3),
        .in4(x4), .in5(x5), .in6(x6), .in7(x7),
        .valid_out(valid_out),
        .out0(y0), .out1(y1), .out2(y2), .out3(y3),
        .out4(y4), .out5(y5), .out6(y6), .out7(y7)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        valid_in = 1'b0;
        {x0, x1, x2, x3, x4, x5, x6, x7} = 64'b0;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        // Impulse input: every 8-point FFT output must be 1 + 0i (8'h10).
        x0 = 8'h10;
        valid_in = 1'b1;
        @(posedge clk);
        @(negedge clk);
        valid_in = 1'b0;
        repeat (2) @(posedge clk);
        #1;
        if (!valid_out)
            $fatal(1, "valid_out was not asserted after three pipeline stages");
        if ({y0, y1, y2, y3, y4, y5, y6, y7} !==
            {8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10})
            $fatal(1, "impulse response failed: %h %h %h %h %h %h %h %h",
                   y0, y1, y2, y3, y4, y5, y6, y7);

        $display("8-point radix-2 pipelined FFT test passed");
        $finish;
    end
endmodule
