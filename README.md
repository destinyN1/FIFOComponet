# FIFO Design and Simulation in VHDL

## Overview
This project involves the design, simulation, and analysis of a **First-In-First-Out (FIFO)** buffer implemented in VHDL. The FIFO is parameterized to support varying data widths (`DATA_WIDTH`) and depths (`DEPTH`). The project includes:
- Implementation of the FIFO architecture with essential features like `write_en`, `read_en`, `full`, and `empty` flags.
- A comprehensive test bench to validate functionality under different scenarios.
- Analysis of timing and behavior when changing data width from 8 bits to 32 bits.

---

## Features
1. **FIFO Implementation**:
   - Generic parameters for data width and depth.
   - Synchronous operations using `clk` and `reset`.
   - Handling of simultaneous read and write operations.
   - `full` and `empty` flag management.
   
2. **Test Bench**:
   - Validates `full` and `empty` conditions.
   - Tests FIFO behavior with both 8-bit data width but can be adjust per the tester's wishes
   - Simulates simultaneous read and write operations.

3. **Analysis**:
   - Effect of increasing `DATA_WIDTH` on timing and performance.
   - Observations of pointer behavior and flag transitions.

---

## Repository Structure
```plaintext
├── src/
│   ├── FIFO.vhd          # VHDL implementation of the FIFO
│   ├── FIFO_tb.vhd       # Test bench for the FIFO
├── README.md             # Project overview (this file)
