module twiddle_w3 #(
    parameter COMPONENT_WIDTH = 19
)(
    input signed [(2*COMPONENT_WIDTH)-1:0] a,
    output signed [(2*COMPONENT_WIDTH)-1:0] y
);
    reg signed [COMPONENT_WIDTH-1:0] ar, ai;
    reg signed [COMPONENT_WIDTH+8:0] rr, ri;
    reg signed [COMPONENT_WIDTH-1:0] qr, qi;

    always @* begin
        ar = $signed(a[(2*COMPONENT_WIDTH)-1:COMPONENT_WIDTH]);
        ai = $signed(a[COMPONENT_WIDTH-1:0]);
        rr = -181 * ar + 181 * ai;
        ri = -181 * ar - 181 * ai;
        qr = rr >>> 8;
        qi = ri >>> 8;
    end

    assign y = {qr, qi};
endmodule
