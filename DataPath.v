module radix2_pipelined_fft(
    input  wire               clk,
    input  wire               reset,
    input  wire               valid_in,
    input  wire signed [31:0] in0, in1, in2, in3,
    input  wire signed [31:0] in4, in5, in6, in7,
    output reg                valid_out,
    output wire signed [31:0] out0, out1, out2, out3,
    output wire signed [31:0] out4, out5, out6, out7
);
    localparam INTERNAL_COMPONENT_WIDTH = 19;
    localparam INTERNAL_WIDTH = 2 * INTERNAL_COMPONENT_WIDTH;

    reg signed [INTERNAL_WIDTH-1:0] s1 [0:7];
    reg signed [INTERNAL_WIDTH-1:0] s2 [0:7];
    reg signed [INTERNAL_WIDTH-1:0] s3 [0:7];
    reg v1, v2;
    integer i;

    wire signed [INTERNAL_WIDTH-1:0] input0 = {{3{in0[31]}}, in0[31:16],
                                               {3{in0[15]}}, in0[15:0]};
    wire signed [INTERNAL_WIDTH-1:0] input1 = {{3{in1[31]}}, in1[31:16],
                                               {3{in1[15]}}, in1[15:0]};
    wire signed [INTERNAL_WIDTH-1:0] input2 = {{3{in2[31]}}, in2[31:16],
                                               {3{in2[15]}}, in2[15:0]};
    wire signed [INTERNAL_WIDTH-1:0] input3 = {{3{in3[31]}}, in3[31:16],
                                               {3{in3[15]}}, in3[15:0]};
    wire signed [INTERNAL_WIDTH-1:0] input4 = {{3{in4[31]}}, in4[31:16],
                                               {3{in4[15]}}, in4[15:0]};
    wire signed [INTERNAL_WIDTH-1:0] input5 = {{3{in5[31]}}, in5[31:16],
                                               {3{in5[15]}}, in5[15:0]};
    wire signed [INTERNAL_WIDTH-1:0] input6 = {{3{in6[31]}}, in6[31:16],
                                               {3{in6[15]}}, in6[15:0]};
    wire signed [INTERNAL_WIDTH-1:0] input7 = {{3{in7[31]}}, in7[31:16],
                                               {3{in7[15]}}, in7[15:0]};

    assign out0 = {s3[0][34:19], s3[0][15:0]};
    assign out1 = {s3[1][34:19], s3[1][15:0]};
    assign out2 = {s3[2][34:19], s3[2][15:0]};
    assign out3 = {s3[3][34:19], s3[3][15:0]};
    assign out4 = {s3[4][34:19], s3[4][15:0]};
    assign out5 = {s3[5][34:19], s3[5][15:0]};
    assign out6 = {s3[6][34:19], s3[6][15:0]};
    assign out7 = {s3[7][34:19], s3[7][15:0]};

    wire signed [INTERNAL_WIDTH-1:0] a1[0:7], a2[0:7], a3[0:7];
    wire signed [INTERNAL_WIDTH-1:0] b1[0:7], b2[0:7], b3[0:7];
    wire signed [INTERNAL_WIDTH-1:0] tw2_1, tw2_2, tw1, tw2_3, tw3;

    complex_add add_s1_0(input0, input4, a1[0]);
    complex_sub sub_s1_0(input0, input4, b1[0]);
    complex_add add_s1_1(input2, input6, a1[2]);
    complex_sub sub_s1_1(input2, input6, b1[2]);
    complex_add add_s1_2(input1, input5, a1[4]);
    complex_sub sub_s1_2(input1, input5, b1[4]);
    complex_add add_s1_3(input3, input7, a1[6]);
    complex_sub sub_s1_3(input3, input7, b1[6]);
    assign a1[1] = b1[0];
    assign a1[3] = b1[2];
    assign a1[5] = b1[4];
    assign a1[7] = b1[6];

    twiddle_w2 tw_s2_1(s1[3], tw2_1);
    twiddle_w2 tw_s2_2(s1[7], tw2_2);
    complex_add add_s2_0(s1[0], s1[2], a2[0]);
    complex_sub sub_s2_0(s1[0], s1[2], b2[0]);
    complex_add add_s2_1(s1[1], tw2_1, a2[1]);
    complex_sub sub_s2_1(s1[1], tw2_1, b2[1]);
    complex_add add_s2_2(s1[4], s1[6], a2[4]);
    complex_sub sub_s2_2(s1[4], s1[6], b2[4]);
    complex_add add_s2_3(s1[5], tw2_2, a2[5]);
    complex_sub sub_s2_3(s1[5], tw2_2, b2[5]);
    assign a2[2] = b2[0];
    assign a2[3] = b2[1];
    assign a2[6] = b2[4];
    assign a2[7] = b2[5];

    twiddle_w1 tw_s3_1(s2[5], tw1);
    twiddle_w2 tw_s3_2(s2[6], tw2_3);
    twiddle_w3 tw_s3_3(s2[7], tw3);
    complex_add add_s3_0(s2[0], s2[4], a3[0]);
    complex_sub sub_s3_0(s2[0], s2[4], b3[0]);
    complex_add add_s3_1(s2[1], tw1, a3[1]);
    complex_sub sub_s3_1(s2[1], tw1, b3[1]);
    complex_add add_s3_2(s2[2], tw2_3, a3[2]);
    complex_sub sub_s3_2(s2[2], tw2_3, b3[2]);
    complex_add add_s3_3(s2[3], tw3, a3[3]);
    complex_sub sub_s3_3(s2[3], tw3, b3[3]);
    assign a3[4] = b3[0];
    assign a3[5] = b3[1];
    assign a3[6] = b3[2];
    assign a3[7] = b3[3];

    always @(posedge clk) begin
        if (reset) begin
            valid_out <= 1'b0;
            v1 <= 1'b0;
            v2 <= 1'b0;
            for (i = 0; i < 8; i = i + 1) begin
                s1[i] <= 0;
                s2[i] <= 0;
                s3[i] <= 0;
            end
        end else begin
            v1 <= valid_in;
            v2 <= v1;
            valid_out <= v2;

            s1[0] <= a1[0]; s1[1] <= b1[0];
            s1[2] <= a1[2]; s1[3] <= b1[2];
            s1[4] <= a1[4]; s1[5] <= b1[4];
            s1[6] <= a1[6]; s1[7] <= b1[6];

            s2[0] <= a2[0]; s2[2] <= b2[0];
            s2[1] <= a2[1]; s2[3] <= b2[1];
            s2[4] <= a2[4]; s2[6] <= b2[4];
            s2[5] <= a2[5]; s2[7] <= b2[5];

            s3[0] <= a3[0]; s3[4] <= b3[0];
            s3[1] <= a3[1]; s3[5] <= b3[1];
            s3[2] <= a3[2]; s3[6] <= b3[2];
            s3[3] <= a3[3]; s3[7] <= b3[3];
        end
    end
endmodule
