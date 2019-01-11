@echo off
title Service Stopper v1.3.4.2
echo Stopping VMware Workstation Pro Services...
net stop VMwareHostd
net stop VMnetDHCP
net stop "VMware NAT Service"
net stop VMUSBArbService
net stop VMAuthdService
echo.
echo Stopping LogMeIn Hamachi Services...
net stop Hamachi2Svc
net stop LMIGuardianSvc
echo.
echo Stopping Office Service...
net stop ClickToRunSvc
pause
cls
echo Configuring VMware Workstation Pro Services... [Disabled]
sc config VMAuthdService start=disabled
sc config VMnetDHCP start=disabled
sc config "VMware NAT Service" start=disabled
sc config VMUSBArbService start=disabled
sc config VMwareHostd start=disabled
echo Done.
echo.
echo Configuring LogMeIn Hamachi Services... [Disabled]
sc config Hamachi2Svc start=disabled
sc config LMIGuardianSvc start=disabled
echo Done.
echo.
echo Configuring SpaceDesk Service... [Disabled]
sc config spacedeskService start=disabled
echo Done.
echo.
echo Configuring Office Service... [Manual]
sc config ClickToRunSvc start=demand
echo Done.
goto :continue

:continue
echo.
set /P c="Do you want to stop other services [Y/N]? "
if /I "%c%" EQU "Y" goto :s_o_s
if /I "%c%" EQU "N" exit
exit

:s_o_s
cls
echo Stopping Adobe Services...
net stop AdobeUpdateService
net stop AGMService
net stop AGSService
echo.
echo Stopping Samsung Mobile Connectivity Service...
net stop ss_conn_service
echo.
echo Stopping SpaceDesk Service...
net stop spacedeskService
echo.
echo Stopping EasyAntiCheat Service...
net stop EasyAntiCheat
echo.
echo Stopping BattlEye Service...
net stop BEService
echo.
echo Stopping Windows Phone Services...
net stop IpOverUsbSvc
echo.
echo Stopping Avast Cleanup Services...
net stop CleanupPSvc
echo.
echo Stopping Steam Services...
net stop "Steam Client Service"
pause
cls
echo Configuring Adobe Services... [Disabled] [Cracked]
sc config AdobeUpdateService start=disabled
sc config AGMService start=disabled
sc config AGSService start=disabled
echo Done.
echo.
echo Configuring Samsung Mobile Connectivity Service Service... [Manual]
sc config ss_conn_service start=demand
echo Done.
echo.
echo Configuring SpaceDesk Service... [Disabled]
sc config spacedeskService start=disabled
echo Done.
echo.
echo Configuring EasyAntiCheat Service... [Manual]
sc config EasyAntiCheat start=demand
echo Done.
echo.
echo Configuring BattlEye Service... [Manual]
sc config BEService start=demand
echo Done.
echo.
echo Configuring Windows Phone Services... [Disabled]
sc config IpOverUsbSvc start=disabled
echo Done.
echo.
echo Configuring Avast Cleanup Services... [Manual]
sc config CleanupPSvc start=demand
echo Done.
echo.
echo Configuring Steam Services... [Manual]
sc config "Steam Client Service" start=demand
echo Done.
pause
exit