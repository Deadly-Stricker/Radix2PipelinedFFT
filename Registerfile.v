module Registerfile(
    input [2:0] in,
    output [7:0] out
);
    assign out = {5'b0, in};
endmodule