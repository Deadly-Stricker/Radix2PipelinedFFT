module twiddle_w1(
    input  signed [7:0] a,
    output signed [7:0] y
);
    reg signed [4:0] ar, ai;
    reg signed [13:0] rr, ri, qr, qi;

    always @* begin
        ar = $signed(a[7:4]);
        ai = $signed(a[3:0]);
        rr = 181 * ar + 181 * ai;
        ri = 181 * ai - 181 * ar;
        qr = rr >>> 8;
        qi = ri >>> 8;
    end

    assign y = {qr[3:0], qi[3:0]};
endmodule
