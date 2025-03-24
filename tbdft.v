module testindft;
    reg [7:0] in1,in2;
    wire [7:0] out1,out2;
    DFT2 DUT (in1,in2,out1,out2);
    initial begin
        // {in1,in2}={8'b1,8'b2};
        in1<=8'b1;
        in2<=8'b11;
        #2 $display("Inputs: %b %b", in1, in2);
        #2 $display("Outputs: %b %b", out1, out2);

        #5 $finish; // Terminate simulation after some time
    end
endmodule