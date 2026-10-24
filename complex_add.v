module complex_add #(
    parameter COMPONENT_WIDTH = 19
)(
    input signed [(2*COMPONENT_WIDTH)-1:0] a,
    input signed [(2*COMPONENT_WIDTH)-1:0] b,
    output signed [(2*COMPONENT_WIDTH)-1:0] y
);
    reg signed [COMPONENT_WIDTH-1:0] ar, ai, br, bi;
    reg signed [COMPONENT_WIDTH:0] rr, ri;

    always @* begin
        ar = $signed(a[(2*COMPONENT_WIDTH)-1:COMPONENT_WIDTH]);
        ai = $signed(a[COMPONENT_WIDTH-1:0]);
        br = $signed(b[(2*COMPONENT_WIDTH)-1:COMPONENT_WIDTH]);
        bi = $signed(b[COMPONENT_WIDTH-1:0]);
        rr = ar + br;
        ri = ai + bi;
    end

    assign y = {rr[COMPONENT_WIDTH-1:0], ri[COMPONENT_WIDTH-1:0]};
endmodule
