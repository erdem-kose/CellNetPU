# Xilinx ISE 14.7 on Windows 10/11

ISE 14.7 crashes on Windows 8+ due to a DLL compatibility issue. Two fixes are needed.

## Fix 1: Project Navigator, iMPACT, and License Manager

Replace `libPortability.dll` with the non-SmartHeap version in two locations:

**Location A:** `C:\Xilinx\14.7\ISE_DS\ISE\lib\nt64`

1. Rename `libPortability.dll` to `libPortability.dll.orig`
2. Copy `libPortabilityNOSH.dll` and rename the copy to `libPortability.dll`

**Location B:** `C:\Xilinx\14.7\ISE_DS\common\lib\nt64`

1. Rename `libPortability.dll` to `libPortability.dll.orig`
2. Copy `libPortabilityNOSH.dll` and rename the copy to `libPortability.dll`

## Fix 2: PlanAhead 64-bit Mode

PlanAhead fails to open projects from 64-bit Project Navigator. Force it to run in 32-bit mode:

1. Go to `C:\Xilinx\14.7\ISE_DS\PlanAhead\bin`
2. Rename `rdiArgs.bat` to `rdiArgs.bat.orig`
3. Extract `win8planaheadfix.zip` (included in this directory) and copy the new `rdiArgs.bat` there

## Other Files

| File | Description |
|------|-------------|
| `win8planaheadfix.zip` | Patched `rdiArgs.bat` for PlanAhead 32-bit mode |
| `xilinx_ise.lic` | ISE license file |
| `xps_ise_websites.txt` | Reference links for ISE/XPS resources |
