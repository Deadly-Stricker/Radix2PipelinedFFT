module DFT2(
    input  [7:0] in1,
    input  [7:0] in2,
    output reg signed [7:0] out1,
    output reg signed [7:0] out2
);
    reg signed [4:0] r1;
    reg signed [4:0] i1;
    reg signed [4:0] r2;
    reg signed [4:0] i2;
    reg signed [5:0] rr;
    reg signed [5:0] ii;

    always @* begin
        r1 = $signed(in1[7:4]);
        i1 = $signed(in1[3:0]);
        r2 = $signed(in2[7:4]);
        i2 = $signed(in2[3:0]);

        rr = r1 + r2;
        ii = i1 + i2;
        out1 = {rr[3:0], ii[3:0]};
        rr = r1 - r2;
        ii = i1 - i2;
        out2 = {rr[3:0], ii[3:0]};
    end
endmodule
