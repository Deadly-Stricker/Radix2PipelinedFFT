module complex_add(
    input  signed [7:0] a,
    input  signed [7:0] b,
    output signed [7:0] y
);
    reg signed [4:0] ar, ai, br, bi;
    reg signed [5:0] rr, ri;

    always @* begin
        ar = $signed(a[7:4]);
        ai = $signed(a[3:0]);
        br = $signed(b[7:4]);
        bi = $signed(b[3:0]);
        rr = ar + br;
        ri = ai + bi;
    end

    assign y = {rr[3:0], ri[3:0]};
endmodule
