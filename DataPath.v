module radix2_pipelined_fft(
    input  wire              clk,
    input  wire              reset,
    input  wire              valid_in,
    input  wire signed [7:0] in0,
    input  wire signed [7:0] in1,
    input  wire signed [7:0] in2,
    input  wire signed [7:0] in3,
    input  wire signed [7:0] in4,
    input  wire signed [7:0] in5,
    input  wire signed [7:0] in6,
    input  wire signed [7:0] in7,
    output reg               valid_out,
    output wire signed [7:0] out0,
    output wire signed [7:0] out1,
    output wire signed [7:0] out2,
    output wire signed [7:0] out3,
    output wire signed [7:0] out4,
    output wire signed [7:0] out5,
    output wire signed [7:0] out6,
    output wire signed [7:0] out7
);
    reg signed [7:0] s1 [0:7];
    reg signed [7:0] s2 [0:7];
    reg signed [7:0] s3 [0:7];
    reg v1, v2;
    integer i;

    assign out0 = s3[0];
    assign out1 = s3[1];
    assign out2 = s3[2];
    assign out3 = s3[3];
    assign out4 = s3[4];
    assign out5 = s3[5];
    assign out6 = s3[6];
    assign out7 = s3[7];

    wire signed [7:0] s1_add0, s1_sub0, s1_add2, s1_sub2;
    wire signed [7:0] s1_add1, s1_sub1, s1_add3, s1_sub3;
    wire signed [7:0] s2_add0, s2_sub0, s2_add1, s2_sub1;
    wire signed [7:0] s2_add2, s2_sub2, s2_add3, s2_sub3;
    wire signed [7:0] s3_add0, s3_sub0, s3_add1, s3_sub1;
    wire signed [7:0] s3_add2, s3_sub2, s3_add3, s3_sub3;
    wire signed [7:0] s2_twiddle1, s2_twiddle3;
    wire signed [7:0] s3_twiddle1, s3_twiddle2, s3_twiddle3;

    complex_add add_s1_0(in0, in4, s1_add0);
    complex_sub sub_s1_0(in0, in4, s1_sub0);
    complex_add add_s1_1(in2, in6, s1_add1);
    complex_sub sub_s1_1(in2, in6, s1_sub1);
    complex_add add_s1_2(in1, in5, s1_add2);
    complex_sub sub_s1_2(in1, in5, s1_sub2);
    complex_add add_s1_3(in3, in7, s1_add3);
    complex_sub sub_s1_3(in3, in7, s1_sub3);

    twiddle_w2 tw_s2_1(s1[3], s2_twiddle1);
    twiddle_w2 tw_s2_3(s1[7], s2_twiddle3);
    complex_add add_s2_0(s1[0], s1[2], s2_add0);
    complex_sub sub_s2_0(s1[0], s1[2], s2_sub0);
    complex_add add_s2_1(s1[1], s2_twiddle1, s2_add1);
    complex_sub sub_s2_1(s1[1], s2_twiddle1, s2_sub1);
    complex_add add_s2_2(s1[4], s1[6], s2_add2);
    complex_sub sub_s2_2(s1[4], s1[6], s2_sub2);
    complex_add add_s2_3(s1[5], s2_twiddle3, s2_add3);
    complex_sub sub_s2_3(s1[5], s2_twiddle3, s2_sub3);

    twiddle_w1 tw_s3_1(s2[5], s3_twiddle1);
    twiddle_w2 tw_s3_2(s2[6], s3_twiddle2);
    twiddle_w3 tw_s3_3(s2[7], s3_twiddle3);
    complex_add add_s3_0(s2[0], s2[4], s3_add0);
    complex_sub sub_s3_0(s2[0], s2[4], s3_sub0);
    complex_add add_s3_1(s2[1], s3_twiddle1, s3_add1);
    complex_sub sub_s3_1(s2[1], s3_twiddle1, s3_sub1);
    complex_add add_s3_2(s2[2], s3_twiddle2, s3_add2);
    complex_sub sub_s3_2(s2[2], s3_twiddle2, s3_sub2);
    complex_add add_s3_3(s2[3], s3_twiddle3, s3_add3);
    complex_sub sub_s3_3(s2[3], s3_twiddle3, s3_sub3);

    always @(posedge clk) begin
        if (reset) begin
            valid_out <= 1'b0;
            v1 <= 1'b0;
            v2 <= 1'b0;
            for (i = 0; i < 8; i = i + 1) begin
                s1[i] <= 8'b0;
                s2[i] <= 8'b0;
                s3[i] <= 8'b0;
            end
        end else begin
            v1 <= valid_in;
            v2 <= v1;
            valid_out <= v2;

            // Stage 1: radix-2 butterflies after bit-reversed input order.
            s1[0] <= s1_add0;
            s1[1] <= s1_sub0;
            s1[2] <= s1_add1;
            s1[3] <= s1_sub1;
            s1[4] <= s1_add2;
            s1[5] <= s1_sub2;
            s1[6] <= s1_add3;
            s1[7] <= s1_sub3;

            // Stage 2: twiddles W8^0 and W8^2.
            s2[0] <= s2_add0;
            s2[2] <= s2_sub0;
            s2[1] <= s2_add1;
            s2[3] <= s2_sub1;
            s2[4] <= s2_add2;
            s2[6] <= s2_sub2;
            s2[5] <= s2_add3;
            s2[7] <= s2_sub3;

            // Stage 3: twiddles W8^0, W8^1, W8^2, and W8^3.
            s3[0] <= s3_add0;
            s3[4] <= s3_sub0;
            s3[1] <= s3_add1;
            s3[5] <= s3_sub1;
            s3[2] <= s3_add2;
            s3[6] <= s3_sub2;
            s3[3] <= s3_add3;
            s3[7] <= s3_sub3;

        end
    end
endmodule

// Compatibility wrapper for the original two-clock project interface.
module datapath(
    input [7:0] in1, input [7:0] in2, input [7:0] in3, input [7:0] in4,
    input [7:0] in5, input [7:0] in6, input [7:0] in7, input [7:0] in8,
    input clk_1, input clk_2,
    output signed [7:0] out1, output signed [7:0] out2,
    output signed [7:0] out3, output signed [7:0] out4,
    output signed [7:0] out5, output signed [7:0] out6,
    output signed [7:0] out7, output signed [7:0] out8
);
    wire unused_clk = clk_2;
    wire unused_reset = 1'b0;
    wire unused_valid;

    radix2_pipelined_fft core(
        .clk(clk_1), .reset(unused_reset), .valid_in(1'b1),
        .in0(in1), .in1(in2), .in2(in3), .in3(in4),
        .in4(in5), .in5(in6), .in6(in7), .in7(in8),
        .valid_out(unused_valid),
        .out0(out1), .out1(out2), .out2(out3), .out3(out4),
        .out4(out5), .out5(out6), .out6(out7), .out7(out8)
    );
endmodule
