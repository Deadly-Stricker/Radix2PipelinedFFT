module twiddle_w2(
    input  signed [7:0] a,
    output signed [7:0] y
);
    reg signed [4:0] ar, ai, nr;

    always @* begin
        ar = $signed(a[7:4]);
        ai = $signed(a[3:0]);
        nr = -ar;
    end

    assign y = {ai[3:0], nr[3:0]};
endmodule
