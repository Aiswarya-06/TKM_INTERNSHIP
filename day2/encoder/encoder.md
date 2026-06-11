# 4-to-2 Priority Encoder Module

## 📋 Architectural Overview
This module implements a combinational 4-to-2 Priority Encoder in Verilog HDL. In standard binary encoders, multiple active inputs simultaneously produce corrupted or undefined outputs. This priority encoder configuration handles multi-asserted input vectors systematically by evaluating and prioritizing the highest active bit index.

Whenever higher-order bits are driven high, lower-order inputs are masked automatically out of the output resolution logic.

---

## 🖼️ Synthesized Hardware Diagrams

### Structural Model Schematic
The image below displays the synthesized logic gate network mapping input pins directly down into minimized Boolean sum-of-products layers.

![Hardware Functional Schematic](../encoder/Schematic.png)

### 4x2 Module Block Diagram
This high-level functional diagram shows interface connectivity, mapping incoming parallel control request lines down to simplified binary vectors.

![4x2 Block Diagram Overview](../encoder/encoder4x2.png)

---

## 💻 Hardware Port Mapping

| Port Name | Direction | Bit Width | Functional Description |
| :--- | :---: | :---: | :--- |
| `in` | Input | 4 | Parallel request lines vector (`in[3]` has top priority) |
| `out` | Output | 2 | Resolved prioritized binary representation index |
| `valid` | Output | 1 | Status line tracking if any input lines are asserted |

### 📊 Behavioral Truth Table

| `in[3]` | `in[2]` | `in[1]` | `in[0]` | `out[1]` | `out[0]` | `valid` |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
|   0   |   0   |   0   |   0   |   X    |   X    |   0   |
|   0   |   0   |   0   |   1   |   0    |   0   |   1   |
|   0   |   0   |   1   |   X   |   0    |   1   |   1   |
|   0   |   1   |   X   |   X   |   1    |   0   |   1   |
|   1   |   X   |   X   |   X   |   1    |   1   |   1   |

---

## 🔍 Simulation Verification Strategy
The active validation environment (`enc_tb.v`) loops through input combinations within Xilinx Vivado to confirm that:
*   **Idle Isolation:** Zero active inputs drive the `valid` status flag low while masking the data outputs.
*   **Prioritization Overriding:** Overlapping inputs (e.g., `4'b1100` and `4'b0111`) are handled perfectly, asserting correct binary configurations based strictly on the highest active bit position.
