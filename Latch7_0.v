module Latch7_0(
    input[7:0] in,
    input clk,
    output reg [7:0] ou
);
    always @(posedge clk ) begin
        ou <= in;
    end
endmodule