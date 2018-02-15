@echo off
..\packer.exe build template.json
vmx2ova.bat ubuntu-1604-amd64/ubuntu-1604-amd64.vmx ubuntu-1604-amd64.ova