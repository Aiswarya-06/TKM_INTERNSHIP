# Binary Coded Decimal (BCD) Adder Unit

## 📋 Architectural Overview
This module implements a 4-bit BCD (Binary Coded Decimal) Adder in Verilog HDL. Unlike standard binary adders, a BCD adder ensures that the output remains within valid decimal boundaries ($0$ to $9$). When the raw binary summation exceeds $9$ (or when a carry-out is generated), correction logic is applied to restore valid BCD formatting.

### 📐 Correction Mechanism
1. Compute raw binary sum: $S_{raw} = A + B + C_{in}$
2. Evaluate condition for correction: $\text{Adjust} = (C_{raw} == 1) \lor (S_{raw} > 4'b1001)$
3. Perform adjustment:
   * If $\text{Adjust} == 1$: Add $+6$ ($4'b0110$) to the raw sum and set $C_{out} = 1$.
   * If $\text{Adjust} == 0$: Keep the raw sum as the final value and set $C_{out} = 0$.

---

## 💻 Port Mapping Specifications

| Port Name | Direction | Bit Width | Functional Description |
| :--- | :---: | :---: | :--- |
| `A` | Input | 4 | First BCD digit input ($0-9$) |
| `B` | Input | 4 | Second BCD digit input ($0-9$) |
| `cin` | Input | 1 | Incoming carry bit |
| `sum` | Output | 4 | Corrected BCD summation output ($0-9$) |
| `cout` | Output | 1 | Outgoing decimal carry status |

---

## 🔍 Verification Setup
The testbench environment (`bcd_tb.v`) runs dynamic input sweeps to thoroughly validate boundary performance:
* Valid inputs spanning combinations from $0+0$ to $9+9$.
* Verification of critical carry-out trigger points (e.g., $5+5$, $9+1$).
* Evaluation of invalid or illegal BCD inputs to audit exception handling.
