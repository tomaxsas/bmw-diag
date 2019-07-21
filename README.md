# Helper scripts/programs for BMW diagnostic

## comportlatency.ps1

This powershell scripts read C:\EDIABAS\Bin\obd.ini to determine used comport and then checks registry for FTDI comports. If found comport with that name, it's latency is checked, if it's not 1, adjusted to one. This is required because for some reason K-DCAN cable sometime looses setting, and if latency is not 1, there are issue with diagnostic
If first time running PowerShell script, run power shell as administrator and type: `set-executionpolicy remotesigned` this allow to run local scripts.
To run script double click ***comportlatency.bat*** batch file

## selectSPdaten.bat

Batch script for easier selection of chasis for WinKfP. Tools like BMW Coding tool copies selected chasis data, this script uses file system links, so chasis change is instant. This is only for WinKFP, for Inpa and NCSexpert use BMW Coding tool to update. In script edit *ecu_folder* variable to point to ecudata folder.
