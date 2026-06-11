# TKM Industrial Internship: Verilog HDL & Digital Design

This repository serves as a structured archive of Verilog HDL hardware designs, verification testbenches, and simulation results compiled during the 15-day industrial internship program hosted by TKM College of Engineering.

---

## 👤 Trainee Profile

*   **Name:** Aiswarya S
*   **Discipline:** Electronics and Communication Engineering
*   **Institution:** TKM College of Engineering (TKMCE)
*   **Development Environment:** Xilinx Vivado Design Suite
*   **Target Language:** Verilog HDL

---

## 📅 Daily Progress & Project Structure

### 📂 Day 1: Basic Arithmetic Circuits
Comprehensive design and verification of core combinatorial arithmetic modules.

*   **Binary Coded Decimal (BCD) Adder**
    *   `day1/bcd.v` — Core BCD design architecture.
    *   `day1/bcd_tb.v` — Testbench module verifying correct decimal summation.
    *   `day1/bcd.md` — Technical notes and design specifications.
*   **Ripple Carry Adder (RCA)**
    *   `day1/fulladd.v` — Full adder structural cell.
    *   `day1/RCA.v` — Chain of full adders forming the ripple architecture.
    *   `day1/rca_tb.v` — Verification environment for multi-bit addition.
    *   `day1/rca.md` — Arithmetic timing and propagation delay analysis.
    *   `day1/rca.png.png` — Schematic/Waveform visualization.

---

### 📂 Day 2: Sequential Elements & Combinational Logic
Exploration of synchronous circuits, data storage cells, and input prioritization.

*   **SR Flip-Flop**
    *   `day2/sr_ff.v` — Gate-level or behavioral SR flip-flop design.
    *   `day2/sr_ff_tb.v` — Simulation testing for set, reset, and invalid states.
*   **D Flip-Flop**
    *   `day2/d_ff.v` — Storage element catching data at the clock edge.
    *   `day2/d_fftb.v` — Input stimulation testbench.
    *   `day2/Schematic_d_ff.png` — Synthesized hardware schematic.
*   **Priority/Binary Encoder**
    *   `day2/enc.v` — Combinational encoder logic implementation.
    *   `day2/enc_tb.v` — Verification of prioritized input routing.
    *   `day2/Schematic.png` & `day2/encoder4x2.png` — Visual hardware schematics.
*   **Universal Shift Register (USR)**
    *   `day2/usr.v` — Bidirectional shift and parallel load register design.
    *   `day2/usr_tb.v` — Comprehensive shift mode simulation sequence.

---

### 📂 Day 3: Advanced Systems & Sequence Tracking
Complex state tracking and modular system grouping.

*   **Face Scan System**
    *   `day3/top.v` — Structural top-level module linking components.
    *   `day3/face_mod.v` — Sensory scanning processing unit.
    *   `day3/fifo.v` — First-In, First-Out memory buffer managing data synchronization.
    *   `day3/mod_out.v` — Output formatting state controller.
    *   `day3/fss_tb.v` — Testbench simulating dynamic input data streams.
*   **Sequence Detector**
    *   `day3/sequence.v` — Finite State Machine (FSM) capturing a dedicated bitstream.
    *   `day3/sequence_tb.v` — Multi-pattern sequential verification block.
    *   `day3/Sequence_detector.png` — FSM state transition diagram or waveform.

---

### 📂 Day 4: Scalable Block Generation
Parameterized logic generation and structured code layout.

*   **Block Generator 88**
    *   `day4/block_gen88/block_generator.v` — Core module implementing conditional `generate` blocks.
    *   `day4/block_gen88/tb.v` — Array stimulation environment.
    *   `day4/block_gen88/bg88.png` — Multi-block execution waveforms.

---

## 🛠️ Simulation & Synthesis Flow

All modules have been developed, synthesized, and verified using **Xilinx Vivado**.

1. **Create Project:** Open Vivado and load the source design files (`.v`).
2. **Add Testbench:** Attach the associated testbench (`_tb.v`) file as a simulation source.
3. **Run Behavioral Simulation:** Analyze the output waveforms inside Vivado Simulator to ensure timing and logic align perfectly.
