# Multi-Bit Ripple Carry Adder (RCA)

## 📋 Architectural Overview
This design documents a multi-bit structural Ripple Carry Adder constructed by cascading primitive 1-bit Full Adder units. The carry-out bit (\(C_{out}\)) of each individual bit cell routes directly into the carry-in (\(C_{in}\)) port of the next significant bit cell. 

While structurally straightforward, the operational frequency of this adder topology is bounded by the linear propagation delay (O(N)) required for the carry signal to ripple through the hardware fabric from the LSB to the MSB.

---

## 🎛️ Design Hierarchy

```text
RCA (Top-Level Multi-Bit Fabric)
  ├── fulladd: bit_0 (Instance 1)
  ├── fulladd: bit_1 (Instance 2)
  ├── fulladd: bit_2 (Instance 3)
  └── fulladd: bit_3 (Instance 4)
```

---

## 💻 Port Mapping Specifications

### 1. Structural Cell (`fulladd.v`)

| Port Name | Direction | Bit Width | Functional Description |
| :--- | :---: | :---: | :--- |
| `a` | Input | 1 | Single-bit addend operand |
| `b` | Input | 1 | Single-bit augend operand |
| `cin` | Input | 1 | Incoming bit carry |
| `sum` | Output | 1 | Resolved bit summation |
| `cout` | Output | 1 | Generated bit carry |

### 2. Cascaded Top-Level (`RCA.v`)

| Port Name | Direction | Bit Width | Functional Description |
| :--- | :---: | :---: | :--- |
| `A` | Input | 4 | Multi-bit parallel input vector A |
| `B` | Input | 4 | Multi-bit parallel input vector B |
| `Cin` | Input | 1 | Primary system carry input |
| `Sum` | Output | 4 | Combined multi-bit parallel sum |
| `Cout` | Output | 1 | Final terminal carry overflow |

---

## 🔍 Verification & Waveform Summary
The testing platform (`rca_tb.v`) profiles hardware timing and logic accuracy via:
* Exhaustive case verification across various input limits.
* Propagation latency tracing on complete overflow vectors (e.g., `4'b1111` + `4'b0001`).

