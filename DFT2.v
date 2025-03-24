module DFT2(
    input [7:0]in1,
    input [7:0]in2,
    output reg [7:0]out1,
    output reg [7:0]out2
);
    always @(*) begin
        out1<=in1+in2;
        out2<=in1-in2;
    end
endmodule