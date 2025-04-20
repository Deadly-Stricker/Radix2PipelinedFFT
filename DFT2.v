module DFT2(
    input [7:0]in1,
    input [7:0]in2,
    output reg [7:0] real_out1,
    // output reg [7:0]imag_out1,
    output reg [7:0] real_out2
    // output reg [7:0]imag_out2
);
    always @(*) begin
        real_out1<=in1+in2;
        real_out2<=in1-in2; 
    end
endmodule