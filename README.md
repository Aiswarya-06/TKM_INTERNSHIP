# 15-Day Industrial Internship Portfolio: Verilog HDL & RTL Architecture

This repository forms a structured, verified portfolio of synthesizable Verilog HDL hardware designs, verification testbenches, and physical layout diagnostics compiled during the 15-day Industrial Training Program hosted by the **TKM College of Engineering (TKMCE)**. 

All modules are designed for deterministic hardware execution and fully verified via behavioral and timing simulation.

---

## 👤 Trainee Engineering Profile

*   **Name:** Aiswarya S
*   **Specialization:** Electronics and Communication Engineering
*   **Institution:** TKM College of Engineering (TKMCE)
*   **EDA Environment:** Xilinx Vivado Design Suite
*   **Target Language:** Verilog HDL (IEEE 1364-2001)

---

## 📋 Comprehensive Directory Architecture Map

```text
TKM_INTERNSHIP/
├── day1/
│   ├── BCD_Adder/
│   │   ├── design/ [bcd.v]
│   │   ├── tb/     [bcd_tb.v]
│   │   └── bcd.md
│   └── Ripple_Carry_Adder/
│       ├── design/ [RCA.v, fulladd.v]
│       ├── tb/     [rca_tb.v]
│       ├── rca.md
│       └── rca.png.png
├── day2/
│   ├── SR_flipflop/
│   │   ├── design/ [sr_ff.v]
│   │   ├── tb/     [sr_ff_tb.v]
│   │   └── sequence.png
│   ├── d_flipflop/
│   │   ├── design/ [d_ff.v]
│   │   ├── tb/     [d_fftb.v]
│   │   ├── Schematic_d_ff.png
│   │   └── dflipflop.md
│   ├── encoder/
│   │   ├── design/ [enc.v]
│   │   ├── tb/     [enc_tb.v]
│   │   ├── Schematic.png
│   │   ├── encoder.md
│   │   └── encoder4x2.png
│   └── usr/
│       ├── design/ [usr.v]
│       ├── tb/     [usr_tb.v]
│       ├── usr.md
│       └── usr.png
├── day3/
│   ├── Face_Scan_system/
│   │   ├── design/ [face_mod.v, fifo.v, mod_out.v, top.v]
│   │   ├── tb/     [fss_tb.v]
│   │   └── fss.md
│   └── Sequence detector/
│       ├── design/ [sequence.v]
│       ├── tb/     [sequence_tb.v]
│       ├── Sequence_detector.png
│       └── sd.md
└── day4/
    └── block_gen88/
        ├── design/ [block_generator.v]
        ├── tb/     [tb.v]
        ├── bg88.png
        └── block_gen.md
```

---

## 📅 Chronological Core Design Registry

### 📂 Day 01: Combinational Arithmetic Optimization
Focuses on mapping mathematical operations down into primitive combinational logic, emphasizing boundary correction and linear propagation analysis.

*   **Decimal Boundary Corrected (BCD) Adder Unit**
    *   [`day1/BCD_Adder/design/bcd.v`](day1/BCD_Adder/design/bcd.v) — RTL architecture deploying raw summation evaluation and active $+6$ vector adjustments.
    *   [`day1/BCD_Adder/tb/bcd_tb.v`](day1/BCD_Adder/tb/bcd_tb.v) — Exhaustive case verification script profiling mathematical thresholds.
    *   [`day1/BCD_Adder/bcd.md`](day1/BCD_Adder/bcd.md) — Comprehensive logic adjustment and architectural specification rules.
*   **Structural Multi-Bit Ripple Carry Adder (RCA)**
    *   [`day1/Ripple_Carry_Adder/design/RCA.v`](day1/Ripple_Carry_Adder/design/RCA.v) — Cascaded top-level fabric grouping structural 1-bit full adders.
    *   [`day1/Ripple_Carry_Adder/design/fulladd.v`](day1/Ripple_Carry_Adder/design/fulladd.v) — Primitive 1-bit full adder hardware building block.
    *   [`day1/Ripple_Carry_Adder/tb/rca_tb.v`](day1/Ripple_Carry_Adder/tb/rca_tb.v) — Testbench for boundary overflow timing tracing ($O(N)$ delay path).
    *   [`day1/Ripple_Carry_Adder/rca.md`](day1/Ripple_Carry_Adder/rca.md) — Technical notes charting critical propagation delay properties.
    *   ![RCA RTL Structural Layout](day1/Ripple_Carry_Adder/rca.png.png)

---

### 📂 Day 02: Synchronous Memory Elements & Prioritization Networks
Explores clock-edge synchronization, state-holding properties, hazard mitigation, and complex parallel data manipulation matrices.

*   **Bistable State-Retention SR Flip-Flop**
    *   [`day2/SR_flipflop/design/sr_ff.v`](day2/SR_flipflop/design/sr_ff.v) — Pure behavioral logic model detailing truth table boundaries.
    *   [`day2/SR_flipflop/tb/sr_ff_tb.v`](day2/SR_flipflop/tb/sr_ff_tb.v) — Simulator sequence checking setup actions and isolating the indeterminate state.
    *   ![SR Flip-Flop Verification Trace](day2/SR_flipflop/sequence.png)
*   **Asynchronous-Clear Edge-Triggered D Flip-Flop**
    *   [`day2/d_flipflop/design/d_ff.v`](day2/d_flipflop/design/d_ff.v) — Sequentially deterministic storage module featuring clock-independent clear control overrides.
    *   [`day2/d_flipflop/tb/d_fftb.v`](day2/d_flipflop/tb/d_fftb.v) — Simulation setup injecting clock-asynchronous control violations.
    *   [`day2/d_flipflop/dflipflop.md`](day2/d_flipflop/dflipflop.md) — Timing profiles for setup, hold, and reset recovery.
    *   ![D Flip-Flop Gate-Level Synthesized Schematic](day2/d_flipflop/Schematic_d_ff.png)
*   **4-to-2 Priority Combinational Encoder**
    *   [`day2/encoder/design/enc.v`](day2/encoder/design/enc.v) — Hardware design featuring overlapping multi-input prioritization masking.
    *   [`day2/encoder/tb/enc_tb.v`](day2/encoder/tb/enc_tb.v) — Functional verification script tracing overlapping line assertions.
    *   [`day2/encoder/encoder.md`](day2/encoder/encoder.md) — Architectural notes detailing Boolean priority mapping parameters.
    *   ![Encoder Gate Synthesized Grid](day2/encoder/Schematic.png)
    *   ![4x2 Encoder Boundary Pin Layout](day2/encoder/encoder4x2.png)
*   **Multi-Mode Universal Shift Register (USR)**
    *   [`day2/usr/design/usr.v`](day2/usr/design/usr.v) — Multi-purpose storage element handling parallel loading and directional bit shifting.
    *   [`day2/usr/tb/usr_tb.v`](day2/usr/tb/usr_tb.v) — Timing stimulus file precisely mapping the 250ns Vivado verification run.
    *   [`day2/usr/usr.md`](day2/usr/usr.md) — Operational control routing logic breakdown.
    *   ![USR Vivado Execution Trace Output](day2/usr/usr.png)

---

### 📂 Day 03: System Integration & Finite State Automata
Advances into multi-module structural architecture, cross-domain data synchronization, and pattern-tracking state pipelines.

*   **Modular Face Scanning System Wrapper**
    *   [`day3/Face_Scan_system/design/top.v`](day3/Face_Scan_system/design/top.v) — Structural system wrapper coordinating memory cores and processing components.
    *   [`day3/Face_Scan_system/design/face_mod.v`](day3/Face_Scan_system/design/face_mod.v) — Sensor input matrix interface decoder state.
    *   [`day3/Face_Scan_system/design/fifo.v`](day3/Face_Scan_system/design/fifo.v) — Elastic circular queue memory structure buffering disparate processing rates.
    *   [`day3/Face_Scan_system/design/mod_out.v`](day3/Face_Scan_system/design/mod_out.v) — Parallel-to-serial protocol interface manager.
    *   [`day3/Face_Scan_system/tb/fss_tb.v`](day3/Face_Scan_system/tb/fss_tb.v) — System-level validation module auditing handshake signals.
    *   [`day3/Face_Scan_system/fss.md`](day3/Face_Scan_system/fss.md) — Queue flow control architecture specifications document.
*   **Non-Overlapping Sequence Detector (1110 Binary Stream)**
    *   [`day3/Sequence detector/design/sequence.v`](day3/Sequence detector/design/sequence.v) — Two-always-block Finite State Machine (FSM) resetting immediately post-match.
    *   [`day3/Sequence detector/tb/sequence_tb.v`](day3/Sequence detector/tb/sequence_tb.v) — Serial data driver ensuring structural non-overlapping validation.
    *   [`day3/Sequence detector/sd.md`](day3/Sequence detector/sd.md) — State transition matrix mapping documentation.
    *   ![FSM State Diagram Graph](day3/Sequence detector/Sequence_detector.png)

---

### 📂 Day 04: Parameterized Macro-Logic Layout Elaboration
Examines hardware scalability, automated module replication, and compiler-driven structural expansion layouts.

*   **Parameterized Block Generator 88 Scheme**
    *   [`day4/block_gen88/design/block_generator.v`](day4/block_gen88/design/block_generator.v) — RTL implementation employing `generate` structures to automate structural block expansion.
    *   [`day4/block_gen88/tb/tb.v`](day4/block_gen88/tb/tb.v) — Parallel channel stimulus suite assessing vector routing spaces.
    *   [`day4/block_gen88/block_gen.md`](day4/block_gen88/block_gen.md) — Scaling parameters specification sheet ($N$-bit array adjustments).
    *   ![Block Generator Waveform Diagram Capture](day4/block_gen88/bg88.png)

---

## ⚙️ Engineering Simulation & Verification Flow

All IP blocks in this library are developed, synthesized, and rigorously tested inside the **Xilinx Vivado Design Suite** native logic simulation interface.

1.  **RTL Source Ingestion:** Hardware modules under the respective `/design/` trees are tracked as primary logic targets.
2.  **Verification Phase:** Matching simulation setups under the `/tb/` subfolders act as active stimulus benches, running clock-synchronized test profiles.
3.  **Waveform Analysis:** Output timing charts are carefully audited using the Vivado Logic Analyzer to confirm total logical and architectural consistency before saving.
