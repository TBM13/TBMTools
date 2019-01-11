@echo off
title Vmware Workstation Pro Launcher v1.1
echo Configuring VMware Workstation Pro Services...
sc config VMAuthdService start=demand
sc config VMnetDHCP start=demand
sc config "VMware NAT Service" start=demand
sc config VMUSBArbService start=demand
sc config VMwareHostd start=demand
echo Done.
echo.
echo Starting VMware Workstation Pro Services...
net start VMAuthdService
net start VMnetDHCP
net start "VMware NAT Service"
net start VMUSBArbService
net start VMwareHostd
echo Done.
echo.
start vmware.exe
timeout 1