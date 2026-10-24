module fft_serial(
    input  wire        clk,
    input  wire        reset,
    input  wire        in_valid,
    output wire        in_ready,
    input  wire [31:0] in_data,
    output reg         out_valid,
    input  wire        out_ready,
    output reg  [31:0] out_data,
    output reg         frame_ready
);
    reg [31:0] frame [0:7];
    reg [2:0] input_count;
    reg collecting;
    reg launch_pending;
    reg core_valid;
    reg [2:0] output_count;

    wire core_valid_out;
    wire signed [31:0] fft_out0, fft_out1, fft_out2, fft_out3;
    wire signed [31:0] fft_out4, fft_out5, fft_out6, fft_out7;

    assign in_ready = collecting && !launch_pending;

    radix2_pipelined_fft core(
        .clk(clk),
        .reset(reset),
        .valid_in(core_valid),
        .in0(frame[0]),
        .in1(frame[1]),
        .in2(frame[2]),
        .in3(frame[3]),
        .in4(frame[4]),
        .in5(frame[5]),
        .in6(frame[6]),
        .in7(frame[7]),
        .valid_out(core_valid_out),
        .out0(fft_out0),
        .out1(fft_out1),
        .out2(fft_out2),
        .out3(fft_out3),
        .out4(fft_out4),
        .out5(fft_out5),
        .out6(fft_out6),
        .out7(fft_out7)
    );

    always @(posedge clk) begin
        if (reset) begin
            input_count <= 3'd0;
            collecting <= 1'b1;
            launch_pending <= 1'b0;
            core_valid <= 1'b0;
            frame_ready <= 1'b0;
            out_valid <= 1'b0;
            out_data <= 32'd0;
            output_count <= 3'd0;
        end else begin
            core_valid <= launch_pending;
            launch_pending <= 1'b0;
            frame_ready <= 1'b0;

            if (in_valid && in_ready) begin
                frame[input_count] <= in_data;
                if (input_count == 3'd7) begin
                    input_count <= 3'd0;
                    collecting <= 1'b0;
                    launch_pending <= 1'b1;
                    frame_ready <= 1'b1;
                end else begin
                    input_count <= input_count + 3'd1;
                end
            end

            if (core_valid_out) begin
                out_valid <= 1'b1;
                output_count <= 3'd0;
                out_data <= fft_out0;
            end else if (out_valid && out_ready) begin
                if (output_count == 3'd7) begin
                    out_valid <= 1'b0;
                    collecting <= 1'b1;
                end else begin
                    output_count <= output_count + 3'd1;
                    case (output_count + 3'd1)
                        3'd1: out_data <= fft_out1;
                        3'd2: out_data <= fft_out2;
                        3'd3: out_data <= fft_out3;
                        3'd4: out_data <= fft_out4;
                        3'd5: out_data <= fft_out5;
                        3'd6: out_data <= fft_out6;
                        default: out_data <= fft_out7;
                    endcase
                end
            end
        end
    end
endmodule
