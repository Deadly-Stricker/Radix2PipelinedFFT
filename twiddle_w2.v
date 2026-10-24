module twiddle_w2 #(
    parameter COMPONENT_WIDTH = 19
)(
    input signed [(2*COMPONENT_WIDTH)-1:0] a,
    output signed [(2*COMPONENT_WIDTH)-1:0] y
);
    reg signed [COMPONENT_WIDTH-1:0] ar, ai;
    reg signed [COMPONENT_WIDTH-1:0] nr;

    always @* begin
        ar = $signed(a[(2*COMPONENT_WIDTH)-1:COMPONENT_WIDTH]);
        ai = $signed(a[COMPONENT_WIDTH-1:0]);
        nr = -ar;
    end

    assign y = {ai, nr};
endmodule
