module testingdatapath;
    reg[7:0] in1,in2,in3,in4,in5,in6,in7,in8;
    wire [7:0]ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8;
    reg clk1,clk2;

    datapath DUT(.in1(in1),.in2(in2),.in3(in3),.in4(in4),.in5(in5),.in6(in6),.in7(in7),.in8(in8),.clk_1(clk1),.clk_2(clk2),.out1(ou1),.out2(ou2),.out3(ou3),.out4(ou4),.out5(ou5),.out6(ou6),.out7(ou7),.out8(ou8));
    always  begin
        #2 clk1 =1; #2 clk1 = 0;
        #2 clk2 =1; #2 clk2 = 0;
    end
    initial begin
        $monitor("Time : ",$time,"  input :  %d %d %d %d %d %d %d %d|output : %b %b %b %b %b %b %b %b ",in1,in2,in3,in4,in5,in6,in7,in8,ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8);
        // $monitor("Time : ",$time,"  output : %d %d %d %d %d %d %d %d ",ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8);
        // $monitor("%d",testingdatapath.DFT2.out6);
        #2 {in1,in2,in3,in4,in5,in6,in7,in8}={8'b0,8'b1,8'b10,8'b11,8'b100,8'b101,8'b110,8'b111};
        // #20 {in1,in2,in3,in4,in5,in6,in7,in8}={8'b11,8'b10,8'b1,8'b1000,8'b111,8'b100,8'b110,8'b101};
        // #20 {in1,in2,in3,in4,in5,in6,in7,in8}={8'b111,8'b110,8'b101,8'b100,8'b11,8'b10,8'b1,8'b0};
        #1000 $finish;
    end
endmodule