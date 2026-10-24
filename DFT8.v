module DFT8(
    input  [7:0] in1,
    input  [7:0] in2,
    input  [7:0] in3,
    input  [7:0] in4,
    input  [7:0] in5,
    input  [7:0] in6,
    input  [7:0] in7,
    input  [7:0] in8,
    output reg signed [7:0] out1,
    output reg signed [7:0] out2,
    output reg signed [7:0] out3,
    output reg signed [7:0] out4,
    output reg signed [7:0] out5,
    output reg signed [7:0] out6,
    output reg signed [7:0] out7,
    output reg signed [7:0] out8
);
    // Inputs and outputs are packed signed 4-bit real/imaginary values.
    // The radix-2 stages use sqrt(2)/2 ~= 181/256 for the odd twiddles.
    reg signed [8:0] xr [0:7];
    reg signed [8:0] xi [0:7];
    reg signed [17:0] sr [0:7];
    reg signed [17:0] si [0:7];
    reg signed [17:0] wr;
    reg signed [17:0] wi;
    reg signed [17:0] mr;
    reg signed [17:0] mi;
    integer k;
    integer n;
    integer phase;

    always @* begin
        xr[0] = $signed(in1[7:4]); xi[0] = $signed(in1[3:0]);
        xr[1] = $signed(in2[7:4]); xi[1] = $signed(in2[3:0]);
        xr[2] = $signed(in3[7:4]); xi[2] = $signed(in3[3:0]);
        xr[3] = $signed(in4[7:4]); xi[3] = $signed(in4[3:0]);
        xr[4] = $signed(in5[7:4]); xi[4] = $signed(in5[3:0]);
        xr[5] = $signed(in6[7:4]); xi[5] = $signed(in6[3:0]);
        xr[6] = $signed(in7[7:4]); xi[6] = $signed(in7[3:0]);
        xr[7] = $signed(in8[7:4]); xi[7] = $signed(in8[3:0]);

        for (k = 0; k < 8; k = k + 1) begin
            sr[k] = 0;
            si[k] = 0;
            for (n = 0; n < 8; n = n + 1) begin
                phase = (k * n) % 8;
                case (phase)
                    0: begin wr = 256; wi = 0; end
                    1: begin wr = 181; wi = -181; end
                    2: begin wr = 0; wi = -256; end
                    3: begin wr = -181; wi = -181; end
                    4: begin wr = -256; wi = 0; end
                    5: begin wr = -181; wi = 181; end
                    6: begin wr = 0; wi = 256; end
                    default: begin wr = 181; wi = 181; end
                endcase
                mr = wr * xr[n] - wi * xi[n];
                mi = wr * xi[n] + wi * xr[n];
                sr[k] = sr[k] + (mr >>> 8);
                si[k] = si[k] + (mi >>> 8);
            end
        end

        out1 = {sr[0][3:0], si[0][3:0]};
        out2 = {sr[1][3:0], si[1][3:0]};
        out3 = {sr[2][3:0], si[2][3:0]};
        out4 = {sr[3][3:0], si[3][3:0]};
        out5 = {sr[4][3:0], si[4][3:0]};
        out6 = {sr[5][3:0], si[5][3:0]};
        out7 = {sr[6][3:0], si[6][3:0]};
        out8 = {sr[7][3:0], si[7][3:0]};
    end
endmodule
