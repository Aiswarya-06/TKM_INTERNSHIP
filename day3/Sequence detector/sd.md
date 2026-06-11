# Non-Overlapping 1110 Finite State Machine (FSM)

## 📋 Design Architecture
This module implements a synchronous Finite State Machine (FSM) tailored to scan a continuous 1-bit input stream (`serial_in`) for the specific pattern **1110**. 

Because this architecture enforces **non-overlapping** behavior, once the target sequence `1110` is successfully tracked and the output assertions are made, the entire tracking mechanism clears its historical memory state. The logic completely resets to the initial idle condition (`ST_IDLE`) on the subsequent clock edge to start monitoring for an entirely new, independent pattern string.

```text
               1            1            1            0
  [ST_IDLE]  ────>  [ST_1] ────> [ST_11] ────> [ST_111] ────> [ST_MATCH]
     ▲                                                            │
     └────────────────────────────────────────────────────────────┘
                    (Resets immediately on next clock)
```

---

## 🎛️ State Machine Definitions

The state transition logic is divided into five distinct behavioral phases:
*   `ST_IDLE`: Default structural state waiting for the initial structural bit (`1`).
*   `ST_1`: Tracks a single leading bit (`1`).
*   `ST_11`: Tracks two consecutive valid bits (`11`).
*   `ST_111`: Tracks three consecutive valid bits (`111`).
*   `ST_MATCH`: Pattern complete state reached upon ingesting the terminating bit (`0`). Asserts `pattern_found = 1` for exactly one clock cycle before jumping back to `ST_IDLE`.

---

## 💻 Hardware Port Mapping

| Port Name | Direction | Bit Width | Functional Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Global operational clock line |
| `reset` | Input | 1 | Synchronous active-high master reset path |
| `serial_in` | Input | 1 | Incoming sequential bit under evaluation |
| `pattern_found`| Output | 1 | Output pulse indicating pattern verification |

---

## 🔍 Verification Strategy
The associated simulation environment (`sequence_tb.v`) evaluates behavioral edge cases inside Xilinx Vivado:
*   **Target Hit Verification:** Confirms clean output pulses when presented with an ideal `1110` sequence.
*   **Non-Overlapping Guard Validation:** Feeds input streams like `11101110` to guarantee that separate matches are asserted cleanly without relying on historical sequence bits.
*   **False Stream Injection:** Floods the data paths with non-standard fragments (e.g., `111110`) to confirm that standard state routing recovers accurately.
