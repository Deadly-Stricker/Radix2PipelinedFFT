module test;
    reg [7:0] in1, in2, in3, in4, in5, in6, in7, in8;
    wire [7:0] out1, out2, out3, out4, out5, out6, out7, out8;

    // Instantiate the design module
    FourtoTwo DUT (in1, in2, in3, in4, in5, in6, in7, in8, out1, out2, out3, out4, out5, out6, out7, out8);

    initial begin
        // Assign values to inputs
        {in1, in2, in3, in4, in5, in6, in7, in8} = {8'b1, 8'b10, 8'b11, 8'b100, 8'b101, 8'b110, 8'b111, 8'b1000};

        // Wait for a short delay before displaying outputs
        #2 $display("Inputs: %b %b %b %b %b %b %b %b", in1, in2, in3, in4, in5, in6, in7, in8);
        #2 $display("Outputs: %b %b %b %b %b %b %b %b", out1, out2, out3, out4, out5, out6, out7, out8);

        #5 $finish; // Terminate simulation after some time
    end
endmodule
