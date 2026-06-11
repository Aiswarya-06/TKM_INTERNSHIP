# Edge-Triggered D Flip-Flop with Asynchronous Clear

## 📋 System Architecture
This module implements a fundamental synchronous 1-bit data storage unit (D Flip-Flop). Unlike a level-sensitive latch, this sequential cell samples the state of the data input line (`d`) precisely at the positive edge of the clock signal (`posedge clk`). 

To guarantee deterministic initialization, the module incorporates an active-high **asynchronous reset** line (`rst`). When `rst` is driven high, the output clears immediately, completely independent of the current system clock state.

```text
               ┌───────┐
      d ───────┤D     Q├─────── q
               │       │
    clk ───►───┤►      │
               │       │
    rst ───────┤CLR    │
               └───────┘
```

---

## 💻 Hardware Port Mapping

| Port Name | Direction | Bit Width | Functional Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Master synchronization clock line |
| `rst` | Input | 1 | Asynchronous active-high system clear line |
| `d` | Input | 1 | Synchronous input data stream line |
| `q` | Output | 1 | Latched data output storage state |

---

## 🔍 Simulation & Waveform Verification
The functional test suite (`d_fftb.v`) checks cell behavior inside Xilinx Vivado across key functional areas:
*   **Asynchronous Reset Ingestion:** Asserts the reset flag midway through a clock phase to confirm the output clears instantly without waiting for a clock edge.
*   **Edge Latching Stability:** Inputs clean data transitions right before clock edges to verify normal tracking behavior.
*   **Hold State Interrogation:** Holds input signals steady over multiple clock cycles to ensure output levels remain unchanged.
