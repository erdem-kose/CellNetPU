Fix prolem with Xilinx not open Project and License ManagerOk,
Hello every one, to day I will help you to fix the problem with Xilinx ISE 14.7:
The license manager and Project Navigator both just CLOSE when you try to open a file in win 8, win 8.1, win 10

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


Download the attached zip file
Extract it. You should now have a file named rdiArgs.bat
Copy the new rdiArgs.bat file to C:\Xilinx\14.7\ISE_DS\PlanAhead\bin

Now you should have a working ISE Design Suite on win 8, win 8,1 and win 10
To see that.
OK. that all about. Tks