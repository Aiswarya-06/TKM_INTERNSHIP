# Multi-Mode Universal Shift Register (USR)

## 📋 Architectural Overview
This module implements a dynamic Universal Shift Register (USR) capable of structural serial shifting and broadside parallel load operations. Mode control logic guides structural routing based on a 2-bit operations mode vector (`mod`), integrated with auxiliary execution qualifiers (`load` and `shift`).

The execution matrix operates on a clock-synchronized pipeline:
*   **`mod = 2'b00` / `2'b01`:** Serial data ingest via the `sin` pipeline with right-shift bit adjustments.
*   **`mod = 2'b10`:** Parallel input latching from vector lines (`pin`) when shift flags are unasserted, transitioning to a right-shift clear array when `shift` is driven active.
*   **`mod = 2'b11`:** High-speed parallel data broadside latching directly into internal memory blocks.

---

## 📊 Behavioral Simulation Waveform Trace

The screenshot below validates functional compliance within the Xilinx Vivado Behavioral Logic Simulator. It traces the operational transitions across all four `mod` register configurations, active clock phases, and reset thresholds up to a `250 ns` execution margin.

![Universal Shift Register Simulation Trace](../../day2/usr/usr_simulation.png)

---

## 💻 Hardware Port Mapping Specifications

| Port Name | Direction | Bit Width | Functional Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Primary synchronous timing clock line |
| `rst` | Input | 1 | Asynchronous master clear line |
| `sin` | Input | 1 | Serial data bit stream ingest line |
| `pin` | Input | 4 | Parallel baseline configuration load source vector |
| `mod` | Input | 2 | Mode configuration routing controls matrix (`mod[1:0]`) |
| `load` | Input | 1 | Output staging data gate control flag |
| `shift`| Input | 1 | Operational shifting mode assertion pulse |
| `sout` | Output | 1 | Serial shifted output bit stream line |
| `pout` | Output | 4 | Latched parallel multi-bit system output array |
