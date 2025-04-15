module multiply(input [31:0] in1,in2,output reg [31:0] out);
    reg s1,s2,s_out;
    reg [7:0] E1,E2,E_out;
    reg [23:0] m1,m2;
    reg [47:0] m_out;

    always@(*) begin
        s1=in1[31];
        s2=in2[31];
        E1=in1[30:23];
        E2=in2[30:23];
        m1={1'b1,in1[22:0]};
        m2={1'b1,in2[22:0]};
        
        s_out=s1^s2;
        E_out=E1+E2 - 8'd127;
        m_out=m1*m2;

//HOW??
        if(m_out[47]==1) begin
            m_out=m_out>>1;
            E_out=E_out + 1;
    end

    out={s_out,E_out,m_out[46:24]};
    end
    endmodule

// module test_mul;
//  reg [31:0] in1,in2;
//     wire [31:0] out;
    
//     multiply A(in1,in2,out);

//     initial begin 
//         $dumpfile("mul.vcd");
//       $dumpvars(0,test_mul);
//       $monitor($time,"in1=%b,in2=%b,out=%b",in1,in2,out);
//             //in1=0.5625   ,   in2=9.75  ==>  5.484375  ={ 0  10000001   10101111100000... }
//     #5 in1={12'b001111110001,20'd0} ;in2={14'b01000001000111,18'd0};
//     // #5 in1=32'd1002;in2=32'd7881;
//     #20 $finish;
//     end
//     endmodule