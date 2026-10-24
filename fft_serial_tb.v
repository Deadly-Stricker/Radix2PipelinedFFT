module fft_serial_tb;
    reg clk = 1'b0;
    reg reset = 1'b1;
    reg in_valid = 1'b0;
    reg out_ready = 1'b1;
    reg [31:0] in_data;
    wire in_ready;
    wire out_valid;
    wire [31:0] out_data;
    wire frame_ready;
    integer i;

    fft_serial dut(
        .clk(clk), .reset(reset),
        .in_valid(in_valid), .in_ready(in_ready), .in_data(in_data),
        .out_valid(out_valid), .out_ready(out_ready), .out_data(out_data),
        .frame_ready(frame_ready)
    );

    always #5 clk = ~clk;

    initial begin
        in_data = 32'd0;
        repeat (2) @(posedge clk);
        #1 reset = 1'b0;

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            while (!in_ready) @(negedge clk);
            in_data = (i == 0) ? 32'h0001_0000 : 32'd0;
            in_valid = 1'b1;
            @(posedge clk);
            #1 in_valid = 1'b0;
        end

        wait (out_valid);
        for (i = 0; i < 8; i = i + 1) begin
            #1;
            if (out_data !== 32'h0001_0000)
                $fatal(1, "serial output %0d was %h", i, out_data);
            @(posedge clk);
        end

        $display("Serial FFT wrapper test passed");
        $finish;
    end
endmodule
