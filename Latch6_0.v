module Latch6_0(
    input[6:0] in,
    input clk,
    output reg [6:0] ou
);
    always @(posedge clk ) begin
        ou <= in;
    end
endmodule