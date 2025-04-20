module datapath(
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input [7:0] in5,
    input [7:0] in6,
    input [7:0] in7,
    input [7:0] in8,
    input clk_1,
    input clk_2,
    output signed[7:0] out1,
    output signed [7:0] out2,
    output signed [7:0] out3,
    output signed [7:0] out4,
    output signed [7:0] out5,
    output signed [7:0] out6,
    output signed [7:0] out7,
    output signed [7:0] out8
);
    wire signed[7:0] L10_ou1,L10_ou2,L10_ou3,L10_ou4,L10_ou5,L10_ou6,L10_ou7,L10_ou8;
    wire signed[7:0] L10_in1,L10_in2,L10_in3,L10_in4,L10_in5,L10_in6,L10_in7,L10_in8;
    Latch7_0 L10 (in1,clk_1,L10_in1);
    Latch7_0 L20 (in2,clk_1,L10_in2);
    Latch7_0 L30 (in3,clk_1,L10_in3);
    Latch7_0 L40 (in4,clk_1,L10_in4);
    Latch7_0 L50 (in5,clk_1,L10_in5);
    Latch7_0 L60 (in6,clk_1,L10_in6);
    Latch7_0 L70 (in7,clk_1,L10_in7);
    Latch7_0 L80 (in8,clk_1,L10_in8);
    EighttoFour M1 (L10_in1,L10_in2,L10_in3,L10_in4,L10_in5,L10_in6,L10_in7,L10_in8,L10_ou1,L10_ou2,L10_ou3,L10_ou4,L10_ou5,L10_ou6,L10_ou7,L10_ou8);

    wire signed[7:0] L11_ou1,L11_ou2,L11_ou3,L11_ou4,L11_ou5,L11_ou6,L11_ou7,L11_ou8;
    wire signed[7:0] L11_in1,L11_in2,L11_in3,L11_in4,L11_in5,L11_in6,L11_in7,L11_in8;

    Latch7_0 L11(L10_ou1,clk_2,L11_in1);
    Latch7_0 L21(L10_ou2,clk_2,L11_in2);
    Latch7_0 L31(L10_ou3,clk_2,L11_in3);
    Latch7_0 L41(L10_ou4,clk_2,L11_in4);
    Latch7_0 L51(L10_ou5,clk_2,L11_in5);
    Latch7_0 L61(L10_ou6,clk_2,L11_in6);
    Latch7_0 L71(L10_ou7,clk_2,L11_in7);
    Latch7_0 L81(L10_ou8,clk_2,L11_in8);
    // Latch7_0 L11(L10_ou1,clk_2,L11_ou1);
    FourtoTwo M2 (L11_in1,L11_in2,L11_in3,L11_in4,L11_ou1,L11_ou2,L11_ou3,L11_ou4);
    FourtoTwo M3 (L11_in5,L11_in6,L11_in7,L11_in8,L11_ou5,L11_ou6,L11_ou7,L11_ou8);
    
    wire signed[7:0] L12_ou1,L12_ou2,L12_ou3,L12_ou4,L12_ou5,L12_ou6,L12_ou7,L12_ou8;
    wire signed[7:0] L12_in1,L12_in2,L12_in3,L12_in4,L12_in5,L12_in6,L12_in7,L12_in8;

    Latch7_0 L12(L11_ou1,clk_1,L12_in1);
    Latch7_0 L22(L11_ou2,clk_1,L12_in2);
    Latch7_0 L32(L11_ou3,clk_1,L12_in3);
    // Latch7_0 L42(L11_ou3,clk_1,L12_in3);
    Latch7_0 L52(L11_ou4,clk_1,L12_in4);
    Latch7_0 L62(L11_ou5,clk_1,L12_in5);
    Latch7_0 L72(L11_ou6,clk_1,L12_in6);
    Latch7_0 L82(L11_ou7,clk_1,L12_in7);
    Latch7_0 L42(L11_ou8,clk_1,L12_in8);


    DFT2 M4 (L12_in1,L12_in2,3'd1,L12_ou1,L12_ou2);
    DFT2 M5 (L12_in3,L12_in4,3'd2,L12_ou3,L12_ou4);
    DFT2 M6 (L12_in5,L12_in6,3'd3,L12_ou5,L12_ou6);
    DFT2 M7 (L12_in7,L12_in8,3'd4,L12_ou7,L12_ou8);
    // DFT2 M3 (L12_in1,L12_in2,L12_ou1,L12_ou2);

    wire signed[7:0] L13_ou1,L13_ou2,L13_ou3,L13_ou4,L13_ou5,L13_ou6;
    // reg [7:0] out1,out2,out3,out4,out5,out6,out7,out8;

    Latch7_0 L13(L12_ou1,clk_2,out1);
    Latch7_0 L23(L12_ou2,clk_2,out2);
    Latch7_0 L33(L12_ou3,clk_2,out3);
    // Latch7_0 L43(L12_ou3,clk_2,out4);
    Latch7_0 L53(L12_ou4,clk_2,out4);
    Latch7_0 L63(L12_ou5,clk_2,out5);
    Latch7_0 L73(L12_ou6,clk_2,out6);
    Latch7_0 L83(L12_ou7,clk_2,out7);
    Latch7_0 L43(L12_ou8,clk_2,out8);
endmodule