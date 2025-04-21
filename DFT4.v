module DFT4(
    input [7:0]in1,  // E0 
    input [7:0]in2,  // E1
    input [7:0]in3,  // O0
    input [7:0]in4,  // O1
    //output reg [7:0] real_out1,
    // output reg [7:0]imag_out1,
    //output reg [7:0] real_out2
    // output reg [7:0]imag_out2
    // input [2:0]index,            // index of input we are looking at
    output reg signed[7:0]out1,     
    output reg signed [7:0]out2,     // output are divided into two parts i.e. real part | imaginary part
    output reg signed[7:0]out3,     
    output reg signed [7:0]out4     // output are divided into two parts i.e. real part | imaginary part
);
    reg signed [7:0] Wr [3:0];
    reg signed [7:0] Wi [3:0];
    initial begin
// twiddle factors
    Wr[0] = 4'sd1;            // Twiddle factors are these 
    Wr[1] = 4'sd0;
    Wr[2] = -4'sd1;
    Wr[3] = 4'sd0;
    Wi[0] = 4'sd0;
    Wi[1] = -4'sd1;
    Wi[2] = 4'sd0;
    Wi[3] = 4'sd1;
    end
// temporary variable to debug
    reg signed [7:0]outTemp1,outTemp2;
    always @(*) begin
        // E0 = x0 + x2   E1 = x0-x2
        // O0 = x1 + x3   O2 = x1 - x3
        // out1 = E1 + W O1 ...
        out1[7:4]<=in1 + Wr[0]*(in3);    
        out1[3:0]<=in1 + Wi[0]*(in3);
        out2[7:4]<=in2 + Wr[1]*(in4);
        out2[3:0]<=in2 + Wi[1]*(in4);
        out3[7:4]<=in1 + Wr[2]*(in3);    
        out3[3:0]<=in1 + Wi[2]*(in3);
        out4[7:4]<=in2 + Wr[3]*(in4);
        out4[3:0]<=in2 + Wi[3]*(in4);
        // outTemp2<=(in1-in2);
    end
endmodule