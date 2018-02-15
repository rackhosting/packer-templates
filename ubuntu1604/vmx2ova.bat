@echo off
set arg1=%1
set arg2=%2
shift
shift

"C:\Program Files (x86)\VMware\VMware Workstation\OVFTool\ovftool.exe" %arg1% %arg2%