module DFT4(
    input  [7:0] in1,
    input  [7:0] in2,
    input  [7:0] in3,
    input  [7:0] in4,
    output reg signed [7:0] out1,
    output reg signed [7:0] out2,
    output reg signed [7:0] out3,
    output reg signed [7:0] out4
);
    reg signed [8:0] r1, i1, r2, i2, r3, i3, r4, i4;
    reg signed [8:0] e0r, e0i, e1r, e1i;
    reg signed [8:0] o0r, o0i, o1r, o1i;
    reg signed [9:0] rr, ii;

    always @* begin
        r1 = $signed(in1[7:4]); i1 = $signed(in1[3:0]);
        r2 = $signed(in2[7:4]); i2 = $signed(in2[3:0]);
        r3 = $signed(in3[7:4]); i3 = $signed(in3[3:0]);
        r4 = $signed(in4[7:4]); i4 = $signed(in4[3:0]);

        e0r = r1 + r3; e0i = i1 + i3;
        e1r = r1 - r3; e1i = i1 - i3;
        o0r = r2 + r4; o0i = i2 + i4;
        o1r = r2 - r4; o1i = i2 - i4;

        rr = e0r + o0r; ii = e0i + o0i;
        out1 = {rr[3:0], ii[3:0]};
        rr = e1r + o1i; ii = e1i - o1r;
        out2 = {rr[3:0], ii[3:0]};
        rr = e0r - o0r; ii = e0i - o0i;
        out3 = {rr[3:0], ii[3:0]};
        rr = e1r - o1i; ii = e1i + o1r;
        out4 = {rr[3:0], ii[3:0]};
    end
endmodule
