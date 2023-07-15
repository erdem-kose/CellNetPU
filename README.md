# CellNetPU (Cellular Neural Network Processing Unit)
A Cellular Neural Network SoC implementation with learning algorithm on VHDL. (Digilent Atlys Board)

## How to use ISE on Windows 10
Xilinx ISE 14.7:
The license manager and Project Navigator both just CLOSE.

Fixing Project Navigator, iMPACT and License Manager
1. Open the following directory: C:\Xilinx\14.7\ISE_DS\ISE\lib\nt64 
2. Find and rename libPortability.dll to libPortability.dll.orig
3. Make a copy of libPortabilityNOSH.dll (copy and paste it to the same directory) and rename it libPortability.dll
4. Copy libPortabilityNOSH.dll again, but this time navigate to C:\Xilinx\14.7\ISE_DS\common\lib\nt64 and paste it there 
5. in C:\Xilinx\14.7\ISE_DS\common\lib\nt64 Find and rename libPortability.dll to libPortability.dll.orig
6. Rename libPortabilityNOSH.dll to libPortability.dll
OK, I have fixed this, you can try in your windows.

Next, Fixing Project not opening from 64-bit Project Navigator
To fix it, we have to force PlanAhead to always run in 32-bit mode.
Open C:\Xilinx\14.7\ISE_DS\PlanAhead\bin and rename rdiArgs.bat to rdiArgs.bat.orig

Download the "win8planaheadfix.zip" from repository.
Extract it. You should now have a file named rdiArgs.bat
Copy the new rdiArgs.bat file to C:\Xilinx\14.7\ISE_DS\PlanAhead\bin

Now you should have a working ISE Design Suite on win 10

## Publications
If you use this work, please citate following papers.

[A new architecture for emulating CNN with template learning on FPGA](https://ieeexplore.ieee.org/abstract/document/8093280)
**TeX Citation Template:**

    @inproceedings{kose2018new,
      title={A new architecture for emulating CNN with template learning on FPGA},
      author={Kose, Erdem and Mustak, Yalcin},
      booktitle={CNNA 2018; The 16th International Workshop on Cellular Nanoscale Networks and their Applications},
      pages={1--4},
      year={2018},
      organization={VDE}
    }

[Emulating CNN with template learning on FPGA](https://ieeexplore.ieee.org/abstract/document/8470492)
**TeX Citation Template:**

    @inproceedings{kose2017emulating,
      title={Emulating CNN with template learning on FPGA},
      author={Kose, Erdem and Yalcin, Mustak E},
      booktitle={2017 European Conference on Circuit Theory and Design (ECCTD)},
      pages={1--4},
      year={2017},
      organization={IEEE}
    }
