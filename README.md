# Radix2PipelinedFFT

This project implements an 8-point radix-2 pipelined FFT in Verilog.

## Data format

Each 8-bit sample is a packed complex value:

- bits `[7:4]`: signed 4-bit real component
- bits `[3:0]`: signed 4-bit imaginary component

The [`radix2_pipelined_fft`](./DataPath.v) module contains three registered
radix-2 butterfly stages. It accepts one 8-point frame per clock when
`valid_in` is asserted and produces the corresponding frame three clocks later
with `valid_out` asserted. The transform uses decimation-in-time bit-reversed
input ordering internally and natural-order output bins.

