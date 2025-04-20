module DFT2(
    input [7:0]in1,
    input [7:0]in2,
    //output reg [7:0] real_out1,
    // output reg [7:0]imag_out1,
    //output reg [7:0] real_out2
    // output reg [7:0]imag_out2
    input [2:0]index,            // index of input we are looking at
    output reg signed[7:0]out1,     
    output reg signed [7:0]out2     // real part | imaginary part
);
    reg signed [7:0] Wr [3:0];
    reg signed [7:0] Wi [3:0];
    initial begin
        
    Wr[0] = 4'd1;
    Wr[1] = 4'd0;
    Wr[2] = -4'd1;
    Wr[3] = 4'd0;
    Wi[0] = 4'd0;
    Wi[1] = -4'd1;
    Wi[2] = 4'd0;
    Wi[3] = 4'd1;
    end
    reg signed [7:0]outTemp1,outTemp2;
    always @(*) begin
        out1[7:4]<=in1+Wr[index]*(in2);
        out1[3:0]<=in1+Wi[index]*(in2);
        out2[7:4]<=in1-Wr[index]*(in2);
        out2[3:0]<=in1-Wi[index]*(in2);
        outTemp2<=(in1-in2);
    end
endmodule