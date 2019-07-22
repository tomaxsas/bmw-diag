# Helper scripts/programs for BMW diagnostic

## comportlatency.ps1

This powershell script reads *C:\EDIABAS\Bin\obd.ini* file to determine used comport number and then checks registry for all registered FTDI comports. If found comport with that number, it's latency is checked, if it's not 1, adjusted to 1. This is required because for some reason K-DCAN cable  looses this setting from time to time, and if latency is not 1, there are issues when performing diagnostic.

If first time running PowerShell script, run power shell as administrator and type: `set-executionpolicy remotesigned` this allow to run local scripts.

To run script double click ***comportlatency.bat*** batch file

## selectSPdaten.bat

Batch script for easier selection of chasis for programing with WinKFP.

Tools like BMW Coding tool copies selected chasis data, this script uses file system links, so chasis change is instant. This is only for WinKFP, for Inpa and NCSexpert use BMW Coding tool to update. In script edit *ecu_folder* variable to point to ecudata folder. Everything in *C:\EC-APPS\NFS\DATA* will be **DELETED**. Script does not have much error checking, so enter folder number carefully.
