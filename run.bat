@echo off

rem get the first line, the ID, from settings.txt
rem old way, set mysteamid="0:1:496906"
set /p mysteamid=<settings.txt

rem this is a silly method for a file with a fixed length... but get the dir by getting the last line
rem old way, set csgodir="C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo"
for /F "delims=" %%a in (settings.txt) do (
   set "csgodir=%%a"
)

echo steamid - %mysteamid%
echo csgodir - %csgodir%

echo.

powershell.exe -executionpolicy bypass -file code.ps1 -mysteamid %mysteamid% -csgodir "%csgodir%"


echo press any key to finish

pause >nul
