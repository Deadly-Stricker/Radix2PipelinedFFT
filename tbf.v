module testingdatapath;
    reg clk, reset, valid_in;
    reg signed [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
    wire valid_out;
    wire signed [31:0] y0, y1, y2, y3, y4, y5, y6, y7;
    integer frame_number, output_number, i;

    radix2_pipelined_fft dut(
        .clk(clk), .reset(reset), .valid_in(valid_in),
        .in0(x0), .in1(x1), .in2(x2), .in3(x3),
        .in4(x4), .in5(x5), .in6(x6), .in7(x7),
        .valid_out(valid_out),
        .out0(y0), .out1(y1), .out2(y2), .out3(y3),
        .out4(y4), .out5(y5), .out6(y6), .out7(y7)
    );

    always #5 clk = ~clk;

    function [31:0] make_complex;
        input integer real_part, imag_part;
        begin
            make_complex = {real_part[15:0], imag_part[15:0]};
        end
    endfunction

    task send_random_frame;
        integer r, im;
        begin
            x0 = make_complex($urandom_range(4000, 0)-2000, $urandom_range(4000, 0)-2000);
            x1 = make_complex($urandom_range(4000, 0)-2000, $urandom_range(4000, 0)-2000);
            x2 = make_complex($urandom_range(4000, 0)-2000, $urandom_range(4000, 0)-2000);
            x3 = make_complex($urandom_range(4000, 0)-2000, $urandom_range(4000, 0)-2000);
            x4 = make_complex($urandom_range(4000, 0)-2000, $urandom_range(4000, 0)-2000);
            x5 = make_complex($urandom_range(4000, 0)-2000, $urandom_range(4000, 0)-2000);
            x6 = make_complex($urandom_range(4000, 0)-2000, $urandom_range(4000, 0)-2000);
            x7 = make_complex($urandom_range(4000, 0)-2000, $urandom_range(4000, 0)-2000);
            frame_number = frame_number + 1;
            $display("Frame %0d inputs:", frame_number);
            $display("  %h %h %h %h %h %h %h %h", x0,x1,x2,x3,x4,x5,x6,x7);
            valid_in = 1'b1;
            @(posedge clk);
            #1 valid_in = 1'b0;
        end
    endtask

    always @(posedge clk) begin
        #1;
        if (valid_out) begin
            output_number = output_number + 1;
            $display("Output for frame %0d:", output_number);
            $display("  X0=%h X1=%h X2=%h X3=%h", y0,y1,y2,y3);
            $display("  X4=%h X5=%h X6=%h X7=%h", y4,y5,y6,y7);
        end
    end

    initial begin
        clk = 0;
        reset = 1;
        valid_in = 0;
        frame_number = 0;
        output_number = 0;
        {x0,x1,x2,x3,x4,x5,x6,x7} = 256'b0;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 0;
        for (i = 0; i < 5; i = i + 1) begin
            send_random_frame();
            @(posedge clk);
            #1;
        end
        repeat (3) @(posedge clk);
        #1 $display("32-bit random-vector simulation complete.");
        $finish;
    end
endmodule
