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
    output reg [7:0] out1,
    output reg [7:0] out2,
    output reg [7:0] out3,
    output reg [7:0] out4,
    output reg [7:0] out5,
    output reg [7:0] out6,
    output reg [7:0] out7,
    output reg [7:0] out8
);
    reg [7:0] L10_ou1,L10_ou2,L10_ou3,L10_ou4,L10_ou5,L10_ou6,L10_ou7,L10_ou8;
    reg [7:0] L10_in1,L10_in2,L10_in3,L10_in4,L10_in5,L10_in6,L10_in7,L10_in8;
    Latch7_0 L10 (in1,clk_1,L10_in1);
    Latch7_0 L20 (in2,clk_1,L10_in2);
    Latch7_0 L30 (in3,clk_1,L10_in3);
    Latch7_0 L40 (in4,clk_1,L10_in4);
    Latch7_0 L50 (in5,clk_1,L10_in5);
    Latch7_0 L60 (in6,clk_1,L10_in6);
    Latch7_0 L70 (in7,clk_1,L10_in7);
    Latch7_0 L80 (in8,clk_1,L10_in8);
    EighttoFour M1 (L10_in1,L10_in2,L10_in3,L10_in4,L10_in5,L10_in6,L10_in7,L10_in8,L10_ou1,L10_ou2,L10_ou3,L10_ou4,L10_ou5,L10_ou6,L10_ou7,L10_ou8);

    reg [7:0] L11_ou1,L11_ou2,L11_ou3,L11_ou4,L11_ou5,L11_ou6,L11_ou7,L11_ou8;
    reg [7:0] L11_in1,L11_in2,L11_in3,L11_in4,L11_in5,L11_in6,L11_in7,L11_in8;

    Latch7_0 L11(L10_ou1,clk_2,L11_in1);
    Latch7_0 L21(L10_ou2,clk_2,L11_in2);
    Latch7_0 L31(L10_ou3,clk_2,L11_in3);
    Latch7_0 L41(L10_ou4,clk_2,L11_in4);
    Latch7_0 L51(L10_ou5,clk_2,L11_in5);
    Latch7_0 L61(L10_ou6,clk_2,L11_in6);
    Latch7_0 L71(L10_ou7,clk_2,L11_in7);
    Latch7_0 L81(L10_ou8,clk_2,L11_in8);
    // Latch7_0 L11(L10_ou1,clk_2,L11_ou1);
    FourtoTwo M2 (L11_in1,L11_in2,L11_in3,L11_in4,L11_in5,L11_in6,L11_in7,L11_in8,L11_ou1,L11_ou2,L11_ou3,L11_ou4,L11_ou5,L11_ou6,L11_ou7,L11_ou8);
    
    reg [7:0] L12_ou1,L12_ou2,L12_ou3,L12_ou4,L12_ou5,L12_ou6,L12_ou7,L12_ou8;
    reg [7:0] L12_in1,L12_in2,L12_in3,L12_in4,L12_in5,L12_in6,L12_in7,L12_in8;

    Latch7_0 L12(L11_ou1,clk_1,L12_in1);
    Latch7_0 L21(L11_ou2,clk_1,L12_in2);
    Latch7_0 L31(L11_ou3,clk_1,L12_in3);
    Latch7_0 L41(L11_ou3,clk_1,L12_in3);
    Latch7_0 L51(L11_ou4,clk_1,L12_in4);
    Latch7_0 L61(L11_ou5,clk_1,L12_in5);
    Latch7_0 L71(L11_ou6,clk_1,L12_in6);
    Latch7_0 L81(L11_ou7,clk_1,L12_in7);


    DFT2 M3 ()
endmodule