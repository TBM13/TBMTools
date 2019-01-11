@echo off
title Spacedesk Launcher v1.0
echo First start Spacedesk drivers!
echo.
pause
echo Configuring Spacedesk service...
sc config spacedeskService start=demand
echo Done.
echo.
echo.
echo Starting Spacedesk service...
net start spacedeskService
echo Done.
