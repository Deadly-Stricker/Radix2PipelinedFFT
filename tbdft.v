module testindft;
    reg [7:0] in1,in2;
    wire signed[7:0] out1,out2;
    DFT2 DUT (in1,in2,3'd3,out1,out2);
    initial begin
        // {in1,in2}={8'd3,8'b2};
        in1<=8'd2;
        in2<=8'd6;
        #2 $display("Inputs: %b %b", in1, in2);
        #2 $display("Outputs: %b %b", out1, DUT.outTemp2);

        #5 $finish; // Terminate simulation after some time
    end
endmodule