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

    function [7:0] cadd;
        input signed [7:0] a;
        input signed [7:0] b;
        reg signed [4:0] ar, ai, br, bi;
        reg signed [5:0] rr, ri;
        begin
            ar = $signed(a[7:4]); ai = $signed(a[3:0]);
            br = $signed(b[7:4]); bi = $signed(b[3:0]);
            rr = ar + br; ri = ai + bi;
            cadd = {rr[3:0], ri[3:0]};
        end
    endfunction

    function [7:0] csub;
        input signed [7:0] a;
        input signed [7:0] b;
        reg signed [4:0] ar, ai, br, bi;
        reg signed [5:0] rr, ri;
        begin
            ar = $signed(a[7:4]); ai = $signed(a[3:0]);
            br = $signed(b[7:4]); bi = $signed(b[3:0]);
            rr = ar - br; ri = ai - bi;
            csub = {rr[3:0], ri[3:0]};
        end
    endfunction

    function [7:0] w1;
        input signed [7:0] a;
        reg signed [4:0] ar, ai;
        reg signed [13:0] rr, ri;
        begin
            ar = $signed(a[7:4]); ai = $signed(a[3:0]);
            rr = 181 * ar + 181 * ai;
            ri = 181 * ai - 181 * ar;
            w1 = {(rr >>> 8), (ri >>> 8)};
        end
    endfunction

    function [7:0] w2;
        input signed [7:0] a;
        reg signed [4:0] ar, ai;
        reg signed [4:0] nr;
        begin
            ar = $signed(a[7:4]); ai = $signed(a[3:0]);
            nr = -ar;
            w2 = {ai[3:0], nr[3:0]};
        end
    endfunction

    function [7:0] w3;
        input signed [7:0] a;
        reg signed [4:0] ar, ai;
        reg signed [13:0] rr, ri;
        begin
            ar = $signed(a[7:4]); ai = $signed(a[3:0]);
            rr = -181 * ar + 181 * ai;
            ri = -181 * ar - 181 * ai;
            w3 = {(rr >>> 8), (ri >>> 8)};
        end
    endfunction

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
            s1[0] <= cadd(in0, in4);
            s1[1] <= csub(in0, in4);
            s1[2] <= cadd(in2, in6);
            s1[3] <= csub(in2, in6);
            s1[4] <= cadd(in1, in5);
            s1[5] <= csub(in1, in5);
            s1[6] <= cadd(in3, in7);
            s1[7] <= csub(in3, in7);

            // Stage 2: twiddles W8^0 and W8^2.
            s2[0] <= cadd(s1[0], s1[2]);
            s2[2] <= csub(s1[0], s1[2]);
            s2[1] <= cadd(s1[1], w2(s1[3]));
            s2[3] <= csub(s1[1], w2(s1[3]));
            s2[4] <= cadd(s1[4], s1[6]);
            s2[6] <= csub(s1[4], s1[6]);
            s2[5] <= cadd(s1[5], w2(s1[7]));
            s2[7] <= csub(s1[5], w2(s1[7]));

            // Stage 3: twiddles W8^0, W8^1, W8^2, and W8^3.
            s3[0] <= cadd(s2[0], s2[4]);
            s3[4] <= csub(s2[0], s2[4]);
            s3[1] <= cadd(s2[1], w1(s2[5]));
            s3[5] <= csub(s2[1], w1(s2[5]));
            s3[2] <= cadd(s2[2], w2(s2[6]));
            s3[6] <= csub(s2[2], w2(s2[6]));
            s3[3] <= cadd(s2[3], w3(s2[7]));
            s3[7] <= csub(s2[3], w3(s2[7]));

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
