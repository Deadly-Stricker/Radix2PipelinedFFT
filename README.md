# Radix2PipelinedFFT

This project implements an 8-point radix-2 pipelined FFT in Verilog.

## Data format

Each 32-bit sample is a packed complex value:

- bits `[31:16]`: signed 16-bit real component
- bits `[15:0]`: signed 16-bit imaginary component

The pipeline keeps 19 bits per component internally to accommodate butterfly
growth. The final outputs are packed back to 16-bit real and imaginary
components.

The [`radix2_pipelined_fft`](./DataPath.v) module contains three registered
radix-2 butterfly stages. It accepts one 8-point frame per clock when
`valid_in` is asserted and produces the corresponding frame three clocks later
with `valid_out` asserted. The transform uses decimation-in-time bit-reversed
input ordering internally and natural-order output bins.

## Simulation

With Icarus Verilog installed, compile and run the structural testbench from
the repository directory:

```text
iverilog -g2012 -s testingdatapath -o fft.vvp DataPath.v complex_add.v complex_sub.v twiddle_w1.v twiddle_w2.v twiddle_w3.v tbf.v
vvp fft.vvp
```