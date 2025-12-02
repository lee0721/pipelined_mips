# pipelined_mips ⚙️

pipelined_mips is a Verilog implementation of a five-stage pipelined MIPS
processor derived from CYCU Computer System & Architecture Lab course
material. The design models the classic IF → ID → EX → MEM → WB datapath,
complete with control logic, pipeline registers, divider/HiLo subsystem, and a
testbench plus memory/reg initialisation images so you can simulate end-to-end.

## Project Overview 🧠
This repo targets teaching/experimentation: each module stays small and
instrumented with `$display` statements so you can watch the PC, register file
activity, memory traffic, and control signals while stepping through programs.
`Document.pdf` and `architecture_diagram.pdf` complement the source for a quick
architecture refresher.

## Features ✨
- **Full five-stage pipeline** – Instruction fetch, decode, execute, memory,
  and write-back stages wired through `IF_ID`, `ID_EX`, `EX_MEM`, `MEM_WB`
  registers to expose true pipelined behaviour.
- **MIPS control + ALU control** – `control_single` handles R-type, ORI,
  LW/SW, BEQ/BNE, and J opcodes while `alu_ctl` maps funct fields to
  ADD/SUB/AND/OR/SLL/SLT operations.
- **Bit-slice ALU with shifter** – `alu.v` composes 32 `Bitslices*` modules
  and the barrel-style `ALU_Shifter` to support arithmetic, logic, and shift
  instructions with a zero flag for branching.
- **Divider + Hi/Lo path** – Dedicated divider running on `div_clk` implements
  `divu`, `mfhi`, and `mflo`, publishing remainder/quotient through the Hi/Lo
  register pair.
- **Memory + register file models** – Byte-addressable 1 KB RAM (`memory.v`)
  and a dual-read register file (`reg_file.v`) with `$display` tracing make it
  easy to observe loads, stores, and register writes.
- **Simulation collateral** – `tb_SingleCycle.v` generates clocks, loads
  `instr_mem.txt`, `data_mem.txt`, `reg.txt`, dumps a `mips_single.vcd`
  waveform, and prints a textual trace per cycle.

## Pipeline at a Glance 🧭
```
PC/Instr Mem ──► IF/ID ──► ID/EX ──► EX/MEM ──► MEM/WB ──► Reg File
                 │          │         │           │
        control_single   alu_ctl   alu+divider   memory
                 │          │         │           │
           branch / jump logic ───────────────────┘
```

## Repository Layout 🗂️
- `mips_single.v` – Top-level module instantiating every datapath component.
- `IF_ID.v`, `ID_EX.v`, `EX_MEM.v`, `MEM_WB.v` – Pipeline register bundles.
- `alu.v`, `Bitslices*.v`, `ALU_Shifter.v`, `FA.v` – ALU, shifter, bit-slice,
  and full-adder primitives.
- `Divider.v`, `HiLo.v` – Divider state machine and Hi/Lo latch logic.
- `control_single.v`, `alu_ctl.v`, `sign_extend.v`, `mux2.v`, `add32.v`,
  `reg32.v` – Supporting control and datapath helpers.
- `reg_file.v`, `memory.v` – Register file and shared instruction/data memory.
- `instr_mem.txt`, `data_mem.txt`, `reg.txt` – Initial program/data/register
  contents loaded by the testbench.
- `tb_SingleCycle.v` – Simulation driver that clocks the CPU and records VCD.
- `Document.pdf`, `architecture_diagram.pdf` – Reference documentation.

## Getting Started 🛠️

### Prerequisites
- A Verilog simulator (e.g., Icarus Verilog, ModelSim, Verilator).
- Optional waveform viewer (GTKWave) for inspecting `mips_single.vcd`.

### Simulate the CPU
```bash
cd pipelined_mips
iverilog -g2012 -o cpu_tb tb_SingleCycle.v *.v
vvp cpu_tb
```

What happens:
1. `tb_SingleCycle` toggles `clk` (period 100 time units) and a faster
   `div_clk` (period 2 time units) for the divider.
2. `$readmemh` loads `instr_mem.txt`, `data_mem.txt`, and `reg.txt` into their
   respective memories/regs.
3. Simulation runs for `cycle_count` × 10 time units (default 250 cycles).
4. `mips_single.vcd` captures all signals for post-run inspection.
5. Console output prints the PC, instruction type, and register write data
   each cycle so you can follow along without a viewer.

### Customise the Program
- **Instructions** – Edit `instr_mem.txt` (little-endian, one byte per line) to
  load your own sequence.
- **Data memory** – Update `data_mem.txt` with new words for loads/stores.
- **Registers** – Seed registers differently by editing `reg.txt`.
- **Simulation length** – Change `cycle_count` inside `tb_SingleCycle.v` if
  your program requires more cycles.