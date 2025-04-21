module filter(
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input [7:0] in5,
    input [7:0] in6,
    input [7:0] in7,
    input [7:0] in8,
    input [3:0] ind,
    output reg [7:0] o1,
    output reg [7:0] o2,
    output reg [7:0] o3,
    output reg [7:0] o4,
    output reg [7:0] o5,
    output reg [7:0] o6,
    output reg [7:0] o7,
    output reg [7:0] o8
);

reg [7:0] in [7:0]; 
reg [7:0] op [7:0]; 

integer i;


always @* begin
    in[0] = in1;
    in[1] = in2;
    in[2] = in3;
    in[3] = in4;
    in[4] = in5;
    in[5] = in6;
    in[6] = in7;
    in[7] = in8;
end

always @* begin
    
    for (i = 0; i < 8; i = i + 1) begin
        op[i] = 8'b0;
    end
    
    
    for (i = 0; i < ind; i = i + 1) begin
        op[i] = in[i];
    end

    o1 = op[0];
    o2 = op[1];
    o3 = op[2];
    o4 = op[3];
    o5 = op[4];
    o6 = op[5];
    o7 = op[6];
    o8 = op[7];
end

endmodule
