@echo off
setlocal enableDelayedExpansion

set data_folder="C:\EC-APPS\NFS\DATA"
set ecu_folder="C:\BMW misc\ecudata"

::build "array" of folders
set folderCnt=0
for /f "eol=: delims=" %%F in ('dir /b /ad %ecu_folder%') do (
  set /a folderCnt+=1
  set "folder!folderCnt!=%%F"
)

::print menu
for /l %%N in (1 1 %folderCnt%) do echo %%N - !folder%%N!
echo(

:get selection
set selection=
set /p "selection=Enter a ECU folder number: "

if exist %data_folder% (
    rd  %data_folder%
) else (
    echo DATA folder link was not found
)

mklink /D %data_folder% %ecu_folder%\!folder%selection%!\data

pause