@echo off
..\packer.exe build template.json
vmx2ova.bat ubuntu-1604/ubuntu-1604.vmx ubuntu-1604.ova
