# CellNetPU (Cellular Neural Network Processing Unit)

A Cellular Neural Network SoC with template learning on FPGA (Digilent Atlys Board, Spartan-6 XC6SLX45).

## Prerequisites

- **Xilinx ISE 14.7** (WebPACK is free)
- **Windows 10/11 fix:** see [ISE on Windows 10+](#ise-on-windows-1011) below
- **Hardware:** Digilent Atlys Board + USB-JTAG cable (for deployment)

## Project Structure

```
src/ISE/
  cnn_application.xise       -- Main project file (open this)
  source/                    -- VHDL source files
    packages/                --   cnn_types, cnn_constants, cnn_components
    cnn_processor.vhd        --   CNN processor core
    cnn_system.vhd           --   Top-level (UART, Ethernet, DDR2)
    cnn_au.vhd               --   Arithmetic unit
    cnn_state_machine.vhd    --   Control logic
    cnn_interface.vhd        --   Interface controller
    cnn_fifo.vhd             --   FIFO buffers
    cnn_commands.vhd         --   Command decoder
    cnn_rand.vhd             --   Random number generator
    ram_generic.vhd          --   Generic RAM
    cnn_system.ucf           --   Pin constraints
  ipcore_dir/
    cnn_clocking.xco         -- Clock IP core definition
    cnn_clocking.vhd         -- Clock IP core wrapper
  mpu/
    mpu.mhs                  -- MicroBlaze system definition
    mpu.xmp                  -- XPS project file
    data/mpu.ucf             -- MicroBlaze constraints
    simulation/behavioral/
      mpu_tb.vhd             -- Full system testbench
  simfiles/
    cnn_test.vhd             -- CNN-only testbench
    cnn_mock_testbench.vhd   -- Mock testbench (no MicroBlaze)
    ram_sim.init             -- Memory init data
    sim_wave_conf.wcfg       -- ISim waveform config
```

## Step 1: Open Project

Double-click `src/ISE/cnn_application.xise` or:
```
cd src/ISE
projectnav cnn_application.xise
```

> `.gise` files are auto-generated metadata -- ignore them.

## Step 2: Synthesize (FPGA Build)

In Project Navigator, select `cnn_system` as top-level entity, then run in order:

| Step | Action | Output |
|------|--------|--------|
| 1 | Double-click **Synthesize - XST** | `.ngc` netlist |
| 2 | Double-click **Implement Design** (runs Translate + Map + Place & Route) | `.ncd` placed design |
| 3 | Double-click **Generate Programming File** | `.bit` bitstream |

Multi-threading is enabled (2 threads) for Map and PAR.

## Step 3: Simulate

### Option A: CNN-only (fast)

1. In Project Navigator, switch to **Simulation** view (top-left dropdown)
2. Select `cnn_test` or `cnn_mock_testbench` as top module
3. Double-click **Simulate Behavioral Model**

`cnn_mock_testbench.vhd` runs 5 test cases without MicroBlaze overhead.

### Option B: Full system with MicroBlaze (slow)

1. Add `src/ISE/mpu/simulation/behavioral/mpu_tb.vhd` as testbench
2. Set simulation time to 10 ms+ (MicroBlaze needs time to boot)
3. Double-click **Simulate Behavioral Model**

> Full system simulation is very slow (~100K clock cycles per ms of sim time).

## Step 4: Build MicroBlaze Firmware (C Code)

1. **Export hardware** from ISE:
   - In Project Navigator: Project -> Export Hardware Design to SDK
   - Or run: `make -f mpu.make exporttosdk`

2. **Open Xilinx SDK:**
   ```
   xsdk -workspace src/ISE/mpu/SDK/SDK_Export
   ```

3. **Create BSP + Application:**
   - File -> New -> Board Support Package (select `mpu` hardware)
   - File -> New -> Application Project (link to BSP)
   - Write your C code (template loading, CNN control, UART output)

4. **Build** -> produces `.elf` file

5. **Merge bitstream + firmware:**
   ```
   data2mem -bm mpu.bmm -bd firmware.elf -bt cnn_system.bit -o b download.bit
   ```

## Step 5: Program FPGA

**Via ISE GUI:**
1. Double-click **Configure Target Device** -> launches iMPACT
2. Detect chain -> assign `.bit` file -> Program

**Via command line:**
```
impact -batch -process_config program.impact
```

**Via Digilent Adept** (alternative):
```
djtgcfg prog -d Atlys -i 0 -f download.bit
```

## Architecture

```
MicroBlaze CPU (100 MHz)
  |-- I/O Module (UART 9600 baud, GPIO)
  |-- Debug Module (JTAG)
  |-- DDR2 Memory Controller (MCB)
  |-- QSPI Flash
  |-- Ethernet Lite MAC
  |-- CNN Processor Array (3x3 grid)
        |-- Template A (3x3 feedback weights)
        |-- Template B (3x3 control weights)
        |-- Error outputs: error_u[00..22], error_x[00..22], error_i
```

MicroBlaze loads templates and reads error signals via memory-mapped registers. CNN processors compute in parallel.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| ISE crashes on Windows 10/11 | Apply libPortability.dll fix (see below) |
| Synthesis errors | Check `.ucf` constraints match top-level ports |
| Timing violations | Reduce clock or optimize critical path |
| MicroBlaze simulation too slow | Use `cnn_mock_testbench.vhd` instead |
| Device programming fails | Check JTAG cable, try iMPACT cable test |

## ISE on Windows 10/11

ISE 14.7 crashes on Windows 10+ without this fix:

1. Go to `C:\Xilinx\14.7\ISE_DS\ISE\lib\nt64`
2. Rename `libPortability.dll` to `libPortability.dll.orig`
3. Copy `libPortabilityNOSH.dll` and rename copy to `libPortability.dll`
4. Repeat steps 2-3 in `C:\Xilinx\14.7\ISE_DS\common\lib\nt64`

**PlanAhead 64-bit fix:**
1. Go to `C:\Xilinx\14.7\ISE_DS\PlanAhead\bin`
2. Rename `rdiArgs.bat` to `rdiArgs.bat.orig`
3. Extract `utils/ISE/win8planaheadfix.zip` and copy `rdiArgs.bat` there

## Publications

If you use this work, please cite:

- [A new architecture for emulating CNN with template learning on FPGA](https://ieeexplore.ieee.org/abstract/document/8093280) (CNNA 2018)
- [Emulating CNN with template learning on FPGA](https://ieeexplore.ieee.org/abstract/document/8470492) (ECCTD 2017)

```bibtex
@inproceedings{kose2018new,
  title={A new architecture for emulating CNN with template learning on FPGA},
  author={Kose, Erdem and Mustak, Yalcin},
  booktitle={CNNA 2018; The 16th International Workshop on Cellular Nanoscale Networks and their Applications},
  pages={1--4},
  year={2018},
  organization={VDE}
}
```
