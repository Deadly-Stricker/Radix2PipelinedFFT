module EighttoFour(
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input [7:0] in5,
    input [7:0] in6,
    input [7:0] in7,
    input [7:0] in8,
    output reg [7:0] out1,
    output reg [7:0] out2,
    output reg [7:0] out3,
    output reg [7:0] out4,
    output reg [7:0] out5,
    output reg [7:0] out6,
    output reg [7:0] out7,
    output reg [7:0] out8
);
always @(*) begin
    
    out1<=in1;
    out2<=in3;
    out3<=in5;
    out4<=in7;
    out5<=in2;
    out6<=in4;
    out7<=in6;
    out8<=in8;

end
endmodule

module FourtoTwo(
    input [7:0]in1,
    input [7:0]in2,
    input [7:0]in3,
    input [7:0]in4,
    output reg [7:0]out1,
    output reg [7:0]out2,
    output reg [7:0]out3,
    output reg [7:0]out4
);
    always @(*) begin
        out1 <= in1;
        out2<=in3;
        out3<=in2;
        out4<=in4;
    end

endmodule