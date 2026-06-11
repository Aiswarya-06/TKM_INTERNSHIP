# Multi-Module Face Scanning & Data Routing Infrastructure

## 📋 Architectural Overview
This system operates as an integrated hardware engine designed to securely ingest, queue, process, and stream multi-byte image data frameworks. The core layout relies on a top-level structural wrapper that brings together distinct, synchronous sub-modules to manage high-speed tracking data without signal degradation or processing bottlenecks.

```text
       ┌────────────────────────────────────────────────────────┐
       │                 top.v (System Wrapper)                 │
       └───────────────────────────┬────────────────────────────┘
                                   │
         ┌─────────────────────────┼─────────────────────────┐
         ▼                         ▼                         ▼
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│   face_mod.v    │       │     fifo.v      │       │   mod_out.v     │
│ (Sensor Ingest) │──────>│ (Elastic Queue) │──────>│ (Serialization) │
└─────────────────┘       └─────────────────┘       └─────────────────┘
```

### ⚙️ Module Responsibilities
*   **`top.v` (Global Hardware Wrapper):** Interconnects control signals and local routing vectors between memory elements and streaming interfaces.
*   **`face_mod.v` (Image Streaming Engine):** Processes raw matrix lines from the optical capture frontend, monitoring system active pulses.
*   **`fifo.v` (Elastic FIFO Buffer):** A circular memory array designed to isolate varying clock structures or sample-rate differences between capture hardware and external data connections.
*   **`mod_out.v` (Data Alignment Interface):** Handles framing controls and formats internal queue values for transmission.

---

## 💻 Hardware Port Mapping Specifications

### Master Wrapper System (`top.v`)

| Port Name | Direction | Bit Width | Functional Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Global operational timing line |
| `rst_n` | Input | 1 | Global active-low asynchronous system reset |
| `stream_valid`| Input | 1 | Validation flag affirming active sensor input payload |
| `scan_data_in`| Input | 8 | Multi-bit raw scanning payload data vector |
| `sys_ready` | Output | 1 | Hardware readiness handshake flag to source transmitter |
| `processed_out`| Output | 8 | Rate-matched, formatted system output data array |

---

## 🔄 FIFO Management & Boundary Flags
The internal `fifo.v` storage matrix prevents data corruption or frame drop issues via hardware status flags:
1.  **Full Guard (`fifo_full`):** Automatically halts external data ingest from `face_mod.v` when memory lines are fully occupied to avoid data overwrite conditions.
2.  **Empty Guard (`fifo_empty`):** Signals the output serializer (`mod_out.v`) to delay read actions when the queue has been depleted, preventing underflow errors.

---

## 🔍 Simulation & Functional Verification
The testing environment (`fss_tb.v`) simulates a real-world hardware verification scenario inside Xilinx Vivado:
*   **Active Video Stimulus:** Feeds continuous blocks of varying 8-bit stream arrays into the processor.
*   **Handshake Auditing:** Monitors the active states of the feedback flags during sudden transmission stalls.
*   **Boundary Stress Testing:** Deliberately drives the processing engine to maximum capacities to verify that memory full and empty safeguards engage exactly as designed.
