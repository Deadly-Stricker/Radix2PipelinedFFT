# 8-Point Radix-2 Pipelined FFT (Verilog, FPGA)

A synthesizable **8-point, radix-2, decimation-in-time FFT** in Verilog RTL with three registered butterfly stages and 32-bit packed complex samples. A ready/valid serial wrapper (`fft_serial`) reduces the interface from about 516 pins to 71, so the design fits and places on the **Nexys A7-100T** (Artix-7 `xc7a100tcsg324-1`).

| | |
|---|---|
| **Transform** | 8-point DFT, `X[k] = Σ x[n]·e^(-j2πnk/8)` |
| **Architecture** | 3 registered radix-2 butterfly stages, `valid_in` / `valid_out` pipeline control |
| **Sample format** | 32-bit packed complex: 16-bit signed real + 16-bit signed imaginary |
| **Internal precision** | 19 bits per component (3 guard bits for the log2(8) = 3 bits of FFT growth) |
| **Board interface** | `fft_serial`: one sample per transfer, ready/valid handshake, 71 I/O pins |
| **Target** | Artix-7 `xc7a100tcsg324-1` (Nexys A7-100T), Vivado 2026.1 |

---

## Contents

- [Data format](#data-format)
- [Architecture](#architecture)
- [Interfaces](#interfaces)
- [Repository layout](#repository-layout)
- [Simulation](#simulation)
- [FPGA implementation](#fpga-implementation)
- [Results](#results)
- [Numerical notes](#numerical-notes)
- [Future work](#future-work)
- [Author](#author)

---

## Data format

Each complex sample is packed into one 32-bit word:

```text
bits [31:16] = signed 16-bit real part
bits [15:0]  = signed 16-bit imaginary part
```

Example:

```text
32'h000A_FFF6   ->   real = 10,  imaginary = -10   (10 - 10j)
```

Inside the pipeline each component is widened to **19 bits**, which leaves room for the additions in three butterfly stages. The final bins are packed back into 16-bit real + 16-bit imaginary.

---

## Architecture

```text
 x0..x7                                                              X0..X7
 (8 × 32-bit)                                                     (8 × 32-bit)
    │                                                                  ▲
    ▼                                                                  │
┌──────────┐   ┌──────────────────┐   ┌──────────────────────┐   ┌──────────┐
│ Stage 1  │──▶│     Stage 2      │──▶│       Stage 3        │──▶│ output   │
│ radix-2  │   │ radix-2          │   │ radix-2              │   │ register │
│ butterfly│   │ W8^0, W8^2 (-j)  │   │ W8^0, W8^1, W8^2,    │   │          │
│ (no tw.) │   │                  │   │ W8^3                 │   │          │
└──────────┘   └──────────────────┘   └──────────────────────┘   └──────────┘
   reg            reg                    reg
valid_in ──▶ valid pipeline ──────────────────────────────────▶ valid_out
```

| Stage | Operation |
|---|---|
| 1 | Radix-2 butterflies (additions and subtractions) on the reordered inputs |
| 2 | Butterflies with twiddles `W8^0` and `W8^2` (`W8^2 = -j`, a swap and negate) |
| 3 | Final butterflies with twiddles `W8^0`, `W8^1`, `W8^2`, `W8^3` |

- Input ordering is bit-reversed internally (decimation in time); **outputs are in natural order** `X[0]..X[7]`.
- `W8^1` and `W8^3` are fixed-point rotations by 1/√2 combined with the ±j terms.
- A one-frame-per-clock datapath: each pipeline stage is registered, so a new 8-sample frame can be accepted while earlier frames are still in flight.

### Arithmetic modules

| File | Function |
|---|---|
| `complex_add.v` | Complex addition |
| `complex_sub.v` | Complex subtraction |
| `twiddle_w1.v` | Multiply by `W8^1` |
| `twiddle_w2.v` | Multiply by `W8^2 = -j` |
| `twiddle_w3.v` | Multiply by `W8^3` |

---

## Interfaces

### `radix2_pipelined_fft` (core, in `DataPath.v`)

Eight 32-bit inputs and eight 32-bit outputs, plus `clk`, `reset`, `valid_in` and `valid_out`. Asserting `valid_in` with a full frame on the inputs starts a transform; `valid_out` marks the cycle in which the matching frame appears on the outputs.

> The raw core exposes roughly **516 pins** (8 × 32 in + 8 × 32 out + control), far more than the board offers. Use `fft_serial` as the physical top level.

### `fft_serial` (board-friendly top level)

| Signal | Dir | Description |
|---|---|---|
| `clk`, `reset` | in | Clock and reset |
| `in_valid` | in | Input sample on `in_data` is valid |
| `in_ready` | out | Wrapper can accept a sample |
| `in_data[31:0]` | in | Packed complex input sample |
| `out_valid` | out | FFT bin on `out_data` is valid |
| `out_ready` | in | Consumer can accept a bin |
| `out_data[31:0]` | out | Packed complex FFT bin |

A transfer happens on a clock edge where `valid` and `ready` are both high.

Usage:

```text
1. Send 8 input samples  x[0] ... x[7]   (one per in_valid/in_ready handshake)
2. Wait for out_valid
3. Read 8 FFT bins        X[0] ... X[7]   (one per out_valid/out_ready handshake)
```

This cuts the external interface from about 516 pins to **71** (about 86% fewer).

### Quick sanity check

A unit impulse `x[0] = 1 + 0j`, all other samples zero, must produce `X[k] = 1 + 0j` for all eight bins.

---

## Repository layout

```text
.
├── DataPath.v         # radix2_pipelined_fft core
├── complex_add.v      # complex adder
├── complex_sub.v      # complex subtractor
├── twiddle_w1.v       # W8^1 rotation
├── twiddle_w2.v       # W8^2 = -j rotation
├── twiddle_w3.v       # W8^3 rotation
├── fft_serial.v       # ready/valid serial wrapper (FPGA top)
├── tbf.v              # random-frame testbench for the core
├── fft_serial_tb.v    # impulse testbench for the serial wrapper
└── README.md
```

Files needed for the FPGA build: `DataPath.v`, `complex_add.v`, `complex_sub.v`, `twiddle_w1.v`, `twiddle_w2.v`, `twiddle_w3.v`, `fft_serial.v`.

---

## Simulation

Requires [Icarus Verilog](https://steveicarus.github.io/iverilog/).

**Serial wrapper (self-checking impulse test):**

```powershell
iverilog -g2012 -Wall -s fft_serial_tb `
  -o serial.vvp `
  DataPath.v complex_add.v complex_sub.v `
  twiddle_w1.v twiddle_w2.v twiddle_w3.v `
  fft_serial.v fft_serial_tb.v

vvp serial.vvp
```

Expected output:

```text
Serial FFT wrapper test passed
```

**Core with random frames:** compile `tbf.v` in place of `fft_serial_tb.v` (top `testingdatapath`) to print random 32-bit complex input frames next to the FFT outputs.

| Testbench | Checks |
|---|---|
| `fft_serial_tb.v` | Sends an impulse through the serial wrapper and verifies all 8 output bins |
| `tbf.v` | Generates random packed complex frames and prints inputs and outputs for inspection |

---

## FPGA implementation

1. Create a Vivado project for part **`xc7a100tcsg324-1`** (Nexys A7-100T).
2. Add the seven RTL files listed above.
3. Set **`fft_serial`** as the top module. Do not use `radix2_pipelined_fft` as the physical top unless all 512 data pins are intended to be external.
4. Add a clock constraint so Vivado reports timing, for example (adjust the port name to match your top level):

   ```tcl
   create_clock -period 10.000 -name clk [get_ports clk]
   ```

5. Run synthesis, implementation, then `report_timing_summary` and `report_utilization`.

---

## Results

Post-placement utilization, `fft_serial`, Vivado 2026.1, `xc7a100tcsg324-1`:

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| Slice LUTs | 1001 | 63,400 | 1.58% |
| Slice registers (FFs) | 1009 | 126,800 | 0.80% |
| DSP48E1 | 6 | 240 | 2.50% |
| Block RAM | 0 | 135 | 0.00% |
| Bonded I/O | 71 | 210 | 33.81% |
| BUFG | 1 | 32 | 3.13% |

| Metric | Value |
|---|---|
| Post-implementation Fmax | _add after the timing run_ (`Fmax ≈ 1 / (period − WNS)`) |

---

## Numerical notes

- Output bins are narrowed from 19-bit internal values to 16-bit. To guarantee that no output overflows, keep `|real|` and `|imag|` of every input sample at or below **2896**: the worst-case output component is `8·√2·A`, which must stay within the signed 16-bit limit of 32767.
- The `W8^1` and `W8^3` twiddles are fixed-point approximations of 1/√2, so non-trivial inputs can differ from an ideal floating-point FFT by a small rounding error. Compare against a reference model with a tolerance of a few LSB, not exact equality.

---

## Future work

- Parameterize the transform size (16, 32, … points) and generate the stage structure with `generate` loops.
- Add a Python golden-model script and extend the testbench to compare many random frames automatically.
- Replace the serial wrapper's input buffering with BRAM for larger frame sizes.
- Add an AXI4-Stream interface in place of the custom ready/valid wrapper.

---

## Author

**Saksham Sinha**, B.Tech in Electronics and Communication Engineering, NIT Kurukshetra
GitHub: [Deadly-Stricker](https://github.com/Deadly-Stricker)
