// module DFT8(
//     input [7:0]in1,
//     input [7:0]in2,
//     input [7:0]in3,
//     input [7:0]in4,
//     input [7:0]in5,
//     input [7:0]in6,
//     input [7:0]in7,
//     input [7:0]in8,
//     output signed reg [7:0] out1,
//     output signed reg [7:0] out2,
//     output signed reg [7:0] out3,
//     output signed reg [7:0] out4,
//     output signed reg [7:0] out5,
//     output signed reg [7:0] out6,
//     output signed reg [7:0] out7,
//     output signed reg [7:0] out8
// );
// reg signed [3:0] Wr [7:0];
// reg signed [3:0] Wi [7:0];
// initial begin
//     Wr[0] <= 4'sd16;
//     Wi[0] <= 4'sd0;
//     Wr[1] <= 4'sd11;
//     Wi[1] <= 4'sd-11;
//     Wr[2] <= 4'sd0;
//     Wi[2] <= 4'sd-1;
//     Wr[3] <= 4'sd-11;
//     Wi[3] <= 4'sd-11;
//     Wr[4] <= 4'sd-1;
//     Wi[4] <= 4'sd0;
//     Wr[5] <= 4'sd-11;
//     Wi[5] <= 4'sd11;
//     Wr[6] <= 4'sd0;
//     Wi[6] <= 4'sd1;
//     Wr[7] <= 4'sd11;
//     Wi[7] <= 4'sd11;
// end
//     // input = a + bi then outreal = Wr * a - Wi *b outimag = Wr * b + Wi * a
//     reg [3:0]Wxo1r,Wxo1i,Wxo2r,Wxo2i,Wxo3r,Wxo3i,Wxo4r,Wxo4i,Wxo5r,Wxo5i,Wxo6r,Wxo6i,Wxo7r,Wxo7i,Wxo8r,Wxo8i;
//     always @(*) begin
//        Wxo1r = Wr[0]*in1[7:4] - Wi[0] * in1[3:0]; 
//        Wxo1i = Wr[0]*in1[3:0] + Wi[0] * in1[7:4]; 
//        Wxo2r = Wr[1]*in3[7:4] - Wi[1] * in3[3:0];
//        Wxo2i = Wr[1]*in3[3:0] + Wi[1] * in3[7:4]; 
//        Wxo3r = Wr[2]*in5[7:4] - Wi[2] * in5[3:0];
//        Wxo3i = Wr[2]*in5[3:0] + Wi[2] * in5[7:4]; 
//        Wxo4r = Wr[3]*in7[7:4] - Wi[3] * in7[3:0];
//        Wxo4i = Wr[3]*in7[3:0] + Wi[3] * in7[7:4];
//        out1[7:4] = Wxo1r + in2[7:4];
//        out5[7:4] = Wxo1r - in2[7:4];
//        out2[7:4] = Wxo2r + in4[7:4];
//        out6[7:4] = Wxo2r - in4[7:4];
//        out3[7:4] = Wxo3r + in6[7:4];
//        out7[7:4] = Wxo3r - in6[7:4];
//        out4[7:4] = Wxo4r + in8[7:4];
//        out8[7:4] = Wxo4r - in8[7:4];


//        out1[3:0] = Wxo1i + in2[3:0];
//        out5[3:0] = Wxo1i - in2[3:0];
//        out2[3:0] = Wxo2i + in4[3:0];
//        out6[3:0] = Wxo2i - in4[3:0];
//        out3[3:0] = Wxo3i + in6[3:0];
//        out7[3:0] = Wxo3i - in6[3:0];
//        out4[3:0] = Wxo4i + in8[3:0];
//        out8[3:0] = Wxo4i - in8[3:0];
//     end
// endmodule





//chatgpt's code 

module DFT8(
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input [7:0] in5,
    input [7:0] in6,
    input [7:0] in7,
    input [7:0] in8,
    output reg signed [7:0] out1,
    output reg signed [7:0] out2,
    output reg signed [7:0] out3,
    output reg signed [7:0] out4,
    output reg signed [7:0] out5,
    output reg signed [7:0] out6,
    output reg signed [7:0] out7,
    output reg signed [7:0] out8
);

    reg signed [7:0] Wr [0:7];
    reg signed [7:0] Wi [0:7];

    initial begin
        Wr[0] <= 8'sd16; Wi[0] <= 8'sd0;
        Wr[1] <= 8'sd11; Wi[1] <= -8'sd11;
        Wr[2] <= 8'sd0;  Wi[2] <= -8'sd16;
        Wr[3] <= -8'sd11; Wi[3] <= -8'sd11;
        Wr[4] <= -8'sd16; Wi[4] <= 8'sd0;
        Wr[5] <= -8'sd11; Wi[5] <= 8'sd11;
        Wr[6] <= 8'sd0;  Wi[6] <= 8'sd16;
        Wr[7] <= 8'sd11; Wi[7] <= 8'sd11;
    end

    reg signed [7:0] a1r, a1i, a2r, a2i, a3r, a3i, a4r, a4i;
    reg signed [15:0] Wxo1r, Wxo1i, Wxo2r, Wxo2i, Wxo3r, Wxo3i, Wxo4r, Wxo4i;

    always @(*) begin
        // Split inputs into signed 4-bit real/imaginary parts and sign-extend to 8 bits
        a1r = $signed({{4{in1[7]}}, in1[7:4]});
        a1i = $signed({{4{in1[3]}}, in1[3:0]});
        a2r = $signed({{4{in3[7]}}, in3[7:4]});
        a2i = $signed({{4{in3[3]}}, in3[3:0]});
        a3r = $signed({{4{in5[7]}}, in5[7:4]});
        a3i = $signed({{4{in5[3]}}, in5[3:0]});
        a4r = $signed({{4{in7[7]}}, in7[7:4]});
        a4i = $signed({{4{in7[3]}}, in7[3:0]});

        // Perform complex multiply: Wr*Re - Wi*Im for real, Wr*Im + Wi*Re for imag
        Wxo1r = Wr[0]*a1r - Wi[0]*a1i;
        Wxo1i = Wr[0]*a1i + Wi[0]*a1r;

        Wxo2r = Wr[1]*a2r - Wi[1]*a2i;
        Wxo2i = Wr[1]*a2i + Wi[1]*a2r;

        Wxo3r = Wr[2]*a3r - Wi[2]*a3i;
        Wxo3i = Wr[2]*a3i + Wi[2]*a3r;

        Wxo4r = Wr[3]*a4r - Wi[3]*a4i;
        Wxo4i = Wr[3]*a4i + Wi[3]*a4r;

        // Combine with paired inputs (assumed same packing)
        out1 = { (Wxo1r[11:8] + in2[7:4]), (Wxo1i[11:8] + in2[3:0]) };
        out5 = { (Wxo1r[11:8] - in2[7:4]), (Wxo1i[11:8] - in2[3:0]) };

        out2 = { (Wxo2r[11:8] + in4[7:4]), (Wxo2i[11:8] + in4[3:0]) };
        out6 = { (Wxo2r[11:8] - in4[7:4]), (Wxo2i[11:8] - in4[3:0]) };

        out3 = { (Wxo3r[11:8] + in6[7:4]), (Wxo3i[11:8] + in6[3:0]) };
        out7 = { (Wxo3r[11:8] - in6[7:4]), (Wxo3i[11:8] - in6[3:0]) };

        out4 = { (Wxo4r[11:8] + in8[7:4]), (Wxo4i[11:8] + in8[3:0]) };
        out8 = { (Wxo4r[11:8] - in8[7:4]), (Wxo4i[11:8] - in8[3:0]) };
    end
endmodule
