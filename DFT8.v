// // module DFT8(
// //     input [7:0]in1,
// //     input [7:0]in2,
// //     input [7:0]in3,
// //     input [7:0]in4,
// //     input [7:0]in5,
// //     input [7:0]in6,
// //     input [7:0]in7,
// //     input [7:0]in8,
// //     output signed reg [7:0] out1,
// //     output signed reg [7:0] out2,
// //     output signed reg [7:0] out3,
// //     output signed reg [7:0] out4,
// //     output signed reg [7:0] out5,
// //     output signed reg [7:0] out6,
// //     output signed reg [7:0] out7,
// //     output signed reg [7:0] out8
// // );
// // reg signed [3:0] Wr [7:0];
// // reg signed [3:0] Wi [7:0];
// // initial begin
// //     Wr[0] <= 4'sd16;
// //     Wi[0] <= 4'sd0;
// //     Wr[1] <= 4'sd11;
// //     Wi[1] <= 4'sd-11;
// //     Wr[2] <= 4'sd0;
// //     Wi[2] <= 4'sd-1;
// //     Wr[3] <= 4'sd-11;
// //     Wi[3] <= 4'sd-11;
// //     Wr[4] <= 4'sd-1;
// //     Wi[4] <= 4'sd0;
// //     Wr[5] <= 4'sd-11;
// //     Wi[5] <= 4'sd11;
// //     Wr[6] <= 4'sd0;
// //     Wi[6] <= 4'sd1;
// //     Wr[7] <= 4'sd11;
// //     Wi[7] <= 4'sd11;
// // end
// //     // input = a + bi then outreal = Wr * a - Wi *b outimag = Wr * b + Wi * a
// //     reg [3:0]Wxo1r,Wxo1i,Wxo2r,Wxo2i,Wxo3r,Wxo3i,Wxo4r,Wxo4i,Wxo5r,Wxo5i,Wxo6r,Wxo6i,Wxo7r,Wxo7i,Wxo8r,Wxo8i;
// //     always @(*) begin
// //        Wxo1r = Wr[0]*in1[7:4] - Wi[0] * in1[3:0]; 
// //        Wxo1i = Wr[0]*in1[3:0] + Wi[0] * in1[7:4]; 
// //        Wxo2r = Wr[1]*in3[7:4] - Wi[1] * in3[3:0];
// //        Wxo2i = Wr[1]*in3[3:0] + Wi[1] * in3[7:4]; 
// //        Wxo3r = Wr[2]*in5[7:4] - Wi[2] * in5[3:0];
// //        Wxo3i = Wr[2]*in5[3:0] + Wi[2] * in5[7:4]; 
// //        Wxo4r = Wr[3]*in7[7:4] - Wi[3] * in7[3:0];
// //        Wxo4i = Wr[3]*in7[3:0] + Wi[3] * in7[7:4];
// //        out1[7:4] = Wxo1r + in2[7:4];
// //        out5[7:4] = Wxo1r - in2[7:4];
// //        out2[7:4] = Wxo2r + in4[7:4];
// //        out6[7:4] = Wxo2r - in4[7:4];
// //        out3[7:4] = Wxo3r + in6[7:4];
// //        out7[7:4] = Wxo3r - in6[7:4];
// //        out4[7:4] = Wxo4r + in8[7:4];
// //        out8[7:4] = Wxo4r - in8[7:4];


// //        out1[3:0] = Wxo1i + in2[3:0];
// //        out5[3:0] = Wxo1i - in2[3:0];
// //        out2[3:0] = Wxo2i + in4[3:0];
// //        out6[3:0] = Wxo2i - in4[3:0];
// //        out3[3:0] = Wxo3i + in6[3:0];
// //        out7[3:0] = Wxo3i - in6[3:0];
// //        out4[3:0] = Wxo4i + in8[3:0];
// //        out8[3:0] = Wxo4i - in8[3:0];
// //     end
// // endmodule





// //chatgpt's code 

// module DFT8(
//     input [7:0] in1,
//     input [7:0] in2,
//     input [7:0] in3,
//     input [7:0] in4,
//     input [7:0] in5,
//     input [7:0] in6,
//     input [7:0] in7,
//     input [7:0] in8,
//     output reg signed [7:0] out1,
//     output reg signed [7:0] out2,
//     output reg signed [7:0] out3,
//     output reg signed [7:0] out4,
//     output reg signed [7:0] out5,
//     output reg signed [7:0] out6,
//     output reg signed [7:0] out7,
//     output reg signed [7:0] out8
// );

//     reg signed [7:0] Wr [0:7];
//     reg signed [7:0] Wi [0:7];

//     initial begin
//         Wr[0] <= 8'sd16; Wi[0] <= 8'sd0;
//         Wr[1] <= 8'sd11; Wi[1] <= -8'sd11;
//         Wr[2] <= 8'sd0;  Wi[2] <= -8'sd16;
//         Wr[3] <= -8'sd11; Wi[3] <= -8'sd11;
//         Wr[4] <= -8'sd16; Wi[4] <= 8'sd0;
//         Wr[5] <= -8'sd11; Wi[5] <= 8'sd11;
//         Wr[6] <= 8'sd0;  Wi[6] <= 8'sd16;
//         Wr[7] <= 8'sd11; Wi[7] <= 8'sd11;
//     end

//     reg signed [7:0] a1r, a1i, a2r, a2i, a3r, a3i, a4r, a4i;
//     reg signed [15:0] Wxo1r, Wxo1i, Wxo2r, Wxo2i, Wxo3r, Wxo3i, Wxo4r, Wxo4i;

//     always @(*) begin
//         // Split inputs into signed 4-bit real/imaginary parts and sign-extend to 8 bits
//         a1r = $signed({{4{in1[7]}}, in1[7:4]});
//         a1i = $signed({{4{in1[3]}}, in1[3:0]});
//         a2r = $signed({{4{in3[7]}}, in3[7:4]});
//         a2i = $signed({{4{in3[3]}}, in3[3:0]});
//         a3r = $signed({{4{in5[7]}}, in5[7:4]});
//         a3i = $signed({{4{in5[3]}}, in5[3:0]});
//         a4r = $signed({{4{in7[7]}}, in7[7:4]});
//         a4i = $signed({{4{in7[3]}}, in7[3:0]});

//         // Perform complex multiply: Wr*Re - Wi*Im for real, Wr*Im + Wi*Re for imag
//         Wxo1r = Wr[0]*a1r - Wi[0]*a1i;
//         Wxo1i = Wr[0]*a1i + Wi[0]*a1r;

//         Wxo2r = Wr[1]*a2r - Wi[1]*a2i;
//         Wxo2i = Wr[1]*a2i + Wi[1]*a2r;

//         Wxo3r = Wr[2]*a3r - Wi[2]*a3i;
//         Wxo3i = Wr[2]*a3i + Wi[2]*a3r;

//         Wxo4r = Wr[3]*a4r - Wi[3]*a4i;
//         Wxo4i = Wr[3]*a4i + Wi[3]*a4r;

//         // Combine with paired inputs (assumed same packing)
//         out1 = { (Wxo1r[11:8] + in2[7:4]), (Wxo1i[11:8] + in2[3:0]) };
//         out5 = { (Wxo1r[11:8] - in2[7:4]), (Wxo1i[11:8] - in2[3:0]) };

//         out2 = { (Wxo2r[11:8] + in4[7:4]), (Wxo2i[11:8] + in4[3:0]) };
//         out6 = { (Wxo2r[11:8] - in4[7:4]), (Wxo2i[11:8] - in4[3:0]) };

//         out3 = { (Wxo3r[11:8] + in6[7:4]), (Wxo3i[11:8] + in6[3:0]) };
//         out7 = { (Wxo3r[11:8] - in6[7:4]), (Wxo3i[11:8] - in6[3:0]) };

//         out4 = { (Wxo4r[11:8] + in8[7:4]), (Wxo4i[11:8] + in8[3:0]) };
//         out8 = { (Wxo4r[11:8] - in8[7:4]), (Wxo4i[11:8] - in8[3:0]) };
//     end
// endmodule


//chatgpt code 2: 

// module DFT8(
//     input  [7:0] in1,
//     input  [7:0] in2,
//     input  [7:0] in3,
//     input  [7:0] in4,
//     input  [7:0] in5,
//     input  [7:0] in6,
//     input  [7:0] in7,
//     input  [7:0] in8,
//     output reg [7:0] out1,
//     output reg [7:0] out2,
//     output reg [7:0] out3,
//     output reg [7:0] out4,
//     output reg [7:0] out5,
//     output reg [7:0] out6,
//     output reg [7:0] out7,
//     output reg [7:0] out8
// );

//     // Internal variables
//     reg signed [3:0] xr[7:0], xi[7:0]; // input real/imag parts
//     reg signed [9:0] sum_r, sum_i;
//     reg signed [4:0] Wr, Wi;
//     integer k, n;

//     // Twiddle factors cos/sin scaled by 8 (approximate)
//     function [4:0] twr(input integer k, input integer n);
//         case ((k*n)%8)
//             0:  twr = 5'sd8;
//             1:  twr = 5'sd6;
//             2:  twr = 5'sd0;
//             3:  twr = -5'sd6;
//             4:  twr = -5'sd8;
//             5:  twr = -5'sd6;
//             6:  twr = 5'sd0;
//             7:  twr = 5'sd6;
//         endcase
//     endfunction

//     function [4:0] twi(input integer k, input integer n);
//         case ((k*n)%8)
//             0:  twi = 5'sd0;
//             1:  twi = -5'sd6;
//             2:  twi = -5'sd8;
//             3:  twi = -5'sd6;
//             4:  twi = 5'sd0;
//             5:  twi = 5'sd6;
//             6:  twi = 5'sd8;
//             7:  twi = 5'sd6;
//         endcase
//     endfunction

//     always @(*) begin
//         // Split input real and imag parts
//         xr[0] = in1[7:4]; xi[0] = in1[3:0];
//         xr[1] = in2[7:4]; xi[1] = in2[3:0];
//         xr[2] = in3[7:4]; xi[2] = in3[3:0];
//         xr[3] = in4[7:4]; xi[3] = in4[3:0];
//         xr[4] = in5[7:4]; xi[4] = in5[3:0];
//         xr[5] = in6[7:4]; xi[5] = in6[3:0];
//         xr[6] = in7[7:4]; xi[6] = in7[3:0];
//         xr[7] = in8[7:4]; xi[7] = in8[3:0];

//         // Loop over 8 outputs
//         for (k = 0; k < 8; k = k + 1) begin
//             sum_r = 0;
//             sum_i = 0;

//             for (n = 0; n < 8; n = n + 1) begin
//                 Wr = twr(k, n);
//                 Wi = twi(k, n);

//                 // Complex multiply and accumulate
//                 sum_r = sum_r + (Wr * xr[n] - Wi * xi[n]);
//                 sum_i = sum_i + (Wr * xi[n] + Wi * xr[n]);
//             end

//             // Pack result: truncate to 4 MSBs (no rounding)
//             case (k)
//                 0: out1 = {sum_r[9:6], sum_i[9:6]};
//                 1: out2 = {sum_r[9:6], sum_i[9:6]};
//                 2: out3 = {sum_r[9:6], sum_i[9:6]};
//                 3: out4 = {sum_r[9:6], sum_i[9:6]};
//                 4: out5 = {sum_r[9:6], sum_i[9:6]};
//                 5: out6 = {sum_r[9:6], sum_i[9:6]};
//                 6: out7 = {sum_r[9:6], sum_i[9:6]};
//                 7: out8 = {sum_r[9:6], sum_i[9:6]};
//             endcase
//         end
//     end
// endmodule


//chatgpt code 3 : 

module DFT8(
    input [7:0] in1, in2, in3, in4, in5, in6, in7, in8,
    output reg signed [7:0] out1, out2, out3, out4, out5, out6, out7, out8
);

    reg signed [7:0] Wr [0:7];  // Real part of twiddle factors
    reg signed [7:0] Wi [0:7];  // Imaginary part of twiddle factors

    // Initialize twiddle factors
    initial begin
        Wr[0] = 8'sd16; Wi[0] = 8'sd0;
        Wr[1] = 8'sd11; Wi[1] = -8'sd11;
        Wr[2] = 8'sd0;  Wi[2] = -8'sd16;
        Wr[3] = -8'sd11; Wi[3] = -8'sd11;
        Wr[4] = -8'sd16; Wi[4] = 8'sd0;
        Wr[5] = -8'sd11; Wi[5] = 8'sd11;
        Wr[6] = 8'sd0;  Wi[6] = 8'sd16;
        Wr[7] = 8'sd11; Wi[7] = 8'sd11;
    end

    reg signed [7:0] real_in [0:7];  // Real parts of inputs
    reg signed [7:0] imag_in [0:7];  // Imaginary parts of inputs
    reg signed [15:0] real_out [0:7]; // Accumulated real outputs
    reg signed [15:0] imag_out [0:7]; // Accumulated imaginary outputs

    integer i;

    always @(*) begin
        // Split inputs into real and imaginary parts
        for (i = 0; i < 8; i = i + 1) begin
            real_in[i] = (i % 2 == 0) ? in1[7:4] : in2[7:4];  // Example of splitting inputs
            imag_in[i] = (i % 2 == 0) ? in1[3:0] : in2[3:0];
        end

        // Initialize output accumulators
        for (i = 0; i < 8; i = i + 1) begin
            real_out[i] = 0;
            imag_out[i] = 0;
        end

        // Perform DFT computation (sum of complex multiplications)
        for (i = 0; i < 8; i = i + 1) begin
            real_out[i] = Wr[i]*real_in[i] - Wi[i]*imag_in[i];
            imag_out[i] = Wr[i]*imag_in[i] + Wi[i]*real_in[i];
        end

        // Output the real and imaginary parts (sum all contributions)
        out1 = real_out[0] + imag_out[0];
        out2 = real_out[1] + imag_out[1];
        out3 = real_out[2] + imag_out[2];
        out4 = real_out[3] + imag_out[3];
        out5 = real_out[4] + imag_out[4];
        out6 = real_out[5] + imag_out[5];
        out7 = real_out[6] + imag_out[6];
        out8 = real_out[7] + imag_out[7];
    end
endmodule


