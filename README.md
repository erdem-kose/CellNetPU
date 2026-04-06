# CellNetPU (Cellular Neural Network Processing Unit)

A Cellular Neural Network SoC with template learning on FPGA (Digilent Atlys Board, Spartan-6 XC6SLX45).

## Prerequisites

- **Xilinx ISE 14.7** with EDK (Embedded Development Kit) -- includes XPS, SDK, CoreGen
- **Windows 10/11 (native):** ISE crashes without a DLL fix -- see [docs/ISE/README.md](docs/ISE/README.md)
- **Linux VM (alternative):** Use the [Xilinx ISE 14.7 Virtual Machine](https://www.xilinx.com/member/forms/download/xef.html?filename=ise-14.7-vm.zip) (pre-configured Oracle VirtualBox image with ISE + EDK). Set up a shared folder to exchange project files with the host -- see [Building from a VM](#building-from-a-vm-not-shared-folder)
- **Hardware:** Digilent Atlys Board + USB-JTAG cable (for deployment)

## Project Structure

```
src/
  ISE/
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
  SDK/
    mpu_hw_platform/           -- Hardware definition (exported from XPS)
    mpu_bsp/                   -- Board Support Package (drivers, lwIP)
    mpu_sw/                    -- MicroBlaze C firmware
      src/main.c               --   Entry point (UART command loop)
      src/cnn/                 --   CNN algorithms and driver functions
      src/sys/                 --   System init, UART, memory access
      src/lscript.ld           --   Linker script (BRAM + DDR2 layout)
docs/
  ISE/                         -- ISE Windows 10/11 fixes and license
```

## Build Flow

The full build order is: **CoreGen → XPS → ISE Synthesis → SDK Build → Program FPGA**.

Only hand-written source files are tracked in git. All generated netlists, IP cores, and
build artifacts must be regenerated from source before the first build.

### Step 1: Generate IP Cores (CoreGen)

The clocking IP must be regenerated before synthesis:

1. Open **Xilinx CoreGen** (or ISE -> Tools -> Core Generator)
2. Open `src/ISE/ipcore_dir/cnn_clocking.xco`
3. Click **Generate** -- produces the `.ngc` netlist and `.xise` project file

### Step 2: Generate MicroBlaze Netlist (XPS)

The MicroBlaze SoC (CPU, AXI bus, DDR2 controller, Ethernet, UART, GPIOs) must be
synthesized into a netlist before the top-level design can be built:

1. Open `src/ISE/mpu/mpu.xmp` in **Xilinx Platform Studio (XPS)**
2. Run **Hardware -> Generate Netlist**
3. Wait for completion -- produces `mpu.ngc` and wrapper files

### Step 3: Synthesize Top-Level Design (ISE)

Open `src/ISE/cnn_application.xise` in **Project Navigator**, select `cnn_system` as
top-level entity, then run in order:

| Step | Action | Output |
|------|--------|--------|
| 1 | Double-click **Synthesize - XST** | `.ngc` netlist |
| 2 | Double-click **Implement Design** (Translate + Map + Place & Route) | `.ncd` placed design |
| 3 | Double-click **Generate Programming File** | `cnn_system.bit` bitstream |

Multi-threading is enabled (2 threads for XST, 4 threads for PAR).

> `.gise` files are auto-generated metadata -- ignore them.

### Step 4: Build MicroBlaze Firmware (SDK)

The firmware source is in `src/SDK/` with three pre-configured projects:

| Project | Purpose |
|---------|---------|
| `mpu_hw_platform` | Hardware definition (exported from XPS) |
| `mpu_bsp` | Board Support Package (Xilinx drivers, lwIP, standalone OS) |
| `mpu_sw` | C application (CNN algorithms, UART control, template loading) |

**Build steps:**

1. **Export hardware** from XPS to SDK:
   - In XPS: Project -> Export Hardware Design to SDK
   - Or from ISE: Project -> Export Hardware Design to SDK
2. **Open Xilinx SDK:**
   ```
   xsdk -workspace src/SDK
   ```
3. **Import existing projects:**
   - File -> Import -> General -> Existing Projects into Workspace
   - Browse to `src/SDK/` and import all three projects
4. **Build BSP first**, then the application:
   - Right-click `mpu_bsp` -> Build Project
   - Right-click `mpu_sw` -> Build Project
   - Produces `mpu_sw.elf`

### Step 5: Merge Bitstream + Firmware

The MicroBlaze firmware (`.elf`) must be embedded into the FPGA bitstream's BRAM
initialization data:

**Via SDK (recommended):**
- Xilinx Tools -> Program FPGA (does merge + download in one step)

**Via command line:**
```
data2mem -bm system.bmm -bd mpu_sw.elf -bt cnn_system.bit -o b download.bit
```

### Step 6: Program FPGA

Connect the Digilent Atlys board via USB-JTAG.

**Via SDK (easiest -- combines Steps 5+6):**
- Xilinx Tools -> Program FPGA -> select `.bit` and `.elf` -> Program

**Via iMPACT:**
1. Double-click **Configure Target Device** in ISE -> launches iMPACT
2. Detect chain -> assign `download.bit` -> Program

**Via command line:**
```
impact -batch -process_config program.impact
```

**Via Digilent Adept (alternative):**
```
djtgcfg prog -d Atlys -i 0 -f download.bit
```

## Simulation

### Option A: CNN-only (fast, recommended)

1. In Project Navigator, switch to **Simulation** view (top-left dropdown)
2. Select `cnn_test` or `cnn_mock_testbench` as top module
3. Double-click **Simulate Behavioral Model**

`cnn_mock_testbench.vhd` runs 5 test cases without MicroBlaze overhead.

### Option B: Full system with MicroBlaze (slow)

1. Add `src/ISE/mpu/simulation/behavioral/mpu_tb.vhd` as testbench
2. Set simulation time to 10 ms+ (MicroBlaze needs time to boot)
3. Double-click **Simulate Behavioral Model**

> Full system simulation is very slow (~100K clock cycles per ms of sim time).

## Architecture

```
MicroBlaze CPU (100 MHz)
  |-- I/O Module (UART 921600 baud, GPIO)
  |-- Debug Module (JTAG)
  |-- DDR2 Memory Controller (MCB)
  |-- QSPI Flash
  |-- Ethernet Lite MAC
  |-- CNN Processor (3x3 patch neighborhood)
        |-- Template A (3x3 feedback weights)
        |-- Template B (3x3 control weights)
        |-- Error outputs: error_u[00..22], error_x[00..22], error_i
```

MicroBlaze loads templates and reads error signals via memory-mapped GPIO registers. The CNN processor operates on 3x3 neighborhoods internally.

## Building from a VM (not shared folder)

If you are running ISE inside a Linux VM and the project is on a **local path** (e.g.
`/home/ise/Desktop/CellNetPU/`) rather than a VirtualBox shared folder, you must copy
the project files from the shared folder to the VM first:

```bash
cp -r /media/sf_XilinxISEsharedFolder/CellNetPU ~/Desktop/CellNetPU
```

Building from a local VM path avoids:
- **Clock skew warnings** (`make: Clock skew detected`) caused by host/guest clock drift
  on shared folders
- **"Text file busy" errors** when XPS cleanup tries to delete temp directories
- **Slow I/O** from VirtualBox shared folder overhead

> After building, copy any outputs you need (`.bit`, `.elf`) back to the shared folder.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| ISE crashes on Windows 10/11 | Apply DLL fix -- see [docs/ISE/README.md](docs/ISE/README.md) |
| Synthesis errors | Check `.ucf` constraints match top-level ports |
| Timing violations | Reduce clock or optimize critical path |
| MicroBlaze simulation too slow | Use `cnn_mock_testbench.vhd` instead |
| Device programming fails | Check JTAG cable, try iMPACT cable test |
| `rm: cannot remove 'xst': Text file busy` | Build from local VM path instead of shared folder (see above) |
| `Clock skew detected` | Run `touch` on all files, or build from local VM path |
| NgdBuild can't find `mpu.ngc` | Set **Macro Search Path** to `mpu/implementation` in ISE Translate properties |

## ISE on Windows 10/11

ISE 14.7 crashes on Windows 10+ due to a DLL compatibility issue. See
[docs/ISE/README.md](docs/ISE/README.md) for the fix (libPortability.dll replacement
and PlanAhead 32-bit patch).

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
