# BCD Adder Simulation Report

This document records the simulation output and behavioral verification for the SystemVerilog 4-bit Binary Coded Decimal (BCD) Adder design using an interface.

## Simulation Summary

- **Simulator Engine:** AMD Vivado XSim
- **Target Snapshot:** `bcd_interface_behav`
- **Total Command Runtime:** 1000 ns
- **Simulation Exit:** `$finish` called at **5 ns**
- **Source File:** `C:/Users/Aishwarya/day5/day5.srcs/sim_1/new/bcd_interface.v` (Line 56)

---

## Log Output & Console Traces

The simulation was initiated via the `run 1000ns` console command. Below is the raw trace generated from the testbench `$monitor` execution:

```text
# run 1000ns
Time=0t: A= 0, B= 0, cin=0 -> S= 0, cout=0
Time=1t: A= 3, B= 4, cin=0 -> S= 7, cout=0
Time=2t: A= 5, B= 6, cin=0 -> S= 1, cout=1
Time=3t: A= 8, B= 7, cin=1 -> S= 6, cout=1
Time=4t: A= 9, B= 9, cin=1 -> S= 9, cout=1
\$finish called at time : 5 ns : File "C:/Users/Aishwarya/day5/day5.srcs/sim_1/new/bcd_interface.v" Line 56
INFO: [USF-XSim-96] XSim completed. Design snapshot 'bcd_interface_behav' loaded.
INFO: [USF-XSim-97] XSim simulation ran for 1000ns
launch_simulation: Time (s): cpu = 00:00:03 ; elapsed = 00:00:08 . Memory (MB): peak = 1348.980 ; gain = 0.000
```

---

## Test Case Breakdown & Functional Verification

The output results verify that the BCD mathematical correction logic ($+6$ shift when binary sum $> 9$ or a raw carry out occurs) works as expected:

| Simulation Time | Input A | Input B | Carry-In (`cin`) | Expected BCD (Decimal Total) | Output BCD Sum (`S`) | Output Carry (`cout`) | Status |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **0 ns** | 0 | 0 | 0 | 0 | 0 | 0 | **Passed** |
| **1 ns** | 3 | 4 | 0 | 7 | 7 | 0 | **Passed** |
| **2 ns** | 5 | 6 | 0 | 11 | 1 | 1 | **Passed** |
| **3 ns** | 8 | 7 | 1 | 16 | 6 | 1 | **Passed** |
| **4 ns** | 9 | 9 | 1 | 19 | 9 | 1 | **Passed** |

### Logic Evaluation Key
- **At 1 ns ($3 + 4 = 7$):** Valid BCD region ($\le 9$). No correction vector needed.
- **At 2 ns ($5 + 6 = 11$):** Exceeds 9. Corrected by adding 6 ($11 + 6 = 17 \rightarrow \text{Binary } 5'\text{b}10001$). Sum outputs `1`, Carry outputs `1`.
- **At 3 ns ($8 + 7 + 1 = 16$):** Triggers internal overflow. Corrected by adding 6 ($16 + 6 = 22 \rightarrow \text{Binary } 5'\text{b}10110$). Sum outputs `6`, Carry outputs `1`.
- **At 4 ns ($9 + 9 + 1 = 19$):** Max edge boundary. Corrected by adding 6 ($19 + 6 = 25 \rightarrow \text{Binary } 5'\text{b}11001$). Sum outputs `9`, Carry outputs `1`.
