# 15-Day Digital Design Internship | TKMCE

This repository contains the digital hardware architectures, simulation testbenches, and verification logs developed during the 15-day industrial internship program hosted by the TKM College of Engineering. 

---

## 🧑‍💻 Student Profile

*   **Name:** Aiswarya S
*   **Major:** Electronics and Communication Engineering
*   **Affiliation:** TKM College of Engineering (TKMCE)
*   **Toolchain:** Xilinx Vivado Design Suite
*   **Hardware Description Language:** Verilog HDL

---

## 📅 Chronological Module Registry

### 📂 Day 01: Combinational Arithmetic Engines
*   **BCD Adder Unit**
    *   [`day1/bcd.v`](day1/bcd.v) — RTL logic for decimal-corrected binary addition.
    *   [`day1/bcd_tb.v`](day1/bcd_tb.v) — Stimulus block validating arithmetic boundaries.
    *   [`day1/bcd.md`](day1/bcd.md) — Behavioral rules and block documentation.
*   **Ripple Carry Adder (RCA)**
    *   [`day1/fulladd.v`](day1/fulladd.v) — 1-bit full adder building block.
    *   [`day1/RCA.v`](day1/RCA.v) — Multi-bit cascaded adder fabric.
    *   [`day1/rca_tb.v`](day1/rca_tb.v) — Comprehensive functional validation file.
    *   [`day1/rca.md`](day1/rca.md) — Propagation delay and bit-carry analysis.

### 📂 Day 02: Synchronous Memory Cells & Data Routing
*   **SR Flip-Flop**
    *   [`day2/sr_ff.v`](day2/sr_ff.v) — Logic model for set-reset state behavior.
    *   [`day2/sr_ff_tb.v`](day2/sr_ff_tb.v) — Test suite handling normal and invalid state transitions.
*   **D Flip-Flop**
    *   [`day2/d_ff.v`](day2/d_ff.v) — Edge-triggered data latching circuit.
    *   [`day2/d_fftb.v`](day2/d_fftb.v) — Signal injection verification script.
*   **Encoder Subsystem**
    *   [`day2/enc.v`](day2/enc.v) — Multi-input encoding prioritization logic.
    *   [`day2/enc_tb.v`](day2/enc_tb.v) — Functional test cases for line encoding.
*   **Universal Shift Register (USR)**
    *   [`day2/usr.v`](day2/usr.v) — Multi-mode register handling bi-directional shifting and parallel operations.
    *   [`day2/usr_tb.v`](day2/usr_tb.v) — Verification script covering all internal operational modes.

### 📂 Day 03: Sequential State Machines & Stream Processing
*   **Face Scanning System Infrastructure**
    *   [`day3/top.v`](day3/top.v) — Top-level structural wrapper integrating the system components.
    *   [`day3/face_mod.v`](day3/face_mod.v) — Sensor stream processing engine.
    *   [`day3/fifo.v`](day3/fifo.v) — Asynchronous queue buffer managing internal data rates.
    *   [`day3/mod_out.v`](day3/mod_out.v) — Output formatting interface manager.
    *   [`day3/fss_tb.v`](day3/fss_tb.v) — System-level validation setup with active video/data inputs.
*   **Pattern Sequence Detector**
    *   [`day3/sequence.v`](day3/sequence.v) — Finite State Machine (FSM) capturing custom serial data sequences.
    *   [`day3/sequence_tb.v`](day3/sequence_tb.v) — Serial stream bit injection simulation.

### 📂 Day 04: Parameterized Logic Automation
*   **Block Generator 88 Project**
    *   [`day4/block_gen88/block_generator.v`](day4/block_gen88/block_generator.v) — Structural code exploiting looping structures for block expansion.
    *   [`day4/block_gen88/tb.v`](day4/block_gen88/tb.v) — Array boundary verification block.

## ⚙️ Development & Verification Workflow

The entire design library is constructed and simulated within the **Xilinx Vivado** native environment.

1. **Source Integration:** Design assets (`.v`) are tracked as design sources.
2. **Verification Loop:** Associated testbenches (`_tb.v`) are executed to trace functional correctness.
3. **Waveform Inspection:** Timing behaviors and logic maps are audited via the built-in Vivado logic simulator.
