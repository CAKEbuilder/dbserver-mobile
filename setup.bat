@echo off

:setmysteamid
set /p mysteamid="Enter your SteamID (0:1:1337): "
IF [%mysteamid%] == [] cls & echo can't be blank & GOTO setmysteamid
rem later, look for letters and don't allow them
rem IF [%mysteamid%] 

rem overwrite the old settings
echo.
echo %mysteamid%> settings.txt

:setcsgodir
rem clear the value, otherwise if the user made a mistake, pressing Enter will not use the default dir
set "csgodir="
set /p csgodir="Enter your CSGO directory (just press Enter if it is the default directory): "
rem if they press Enter, set to default dir
rem evaluating this variable with double quotes, to preserve spaces in the user input
IF ["%csgodir%"] == [""] set csgodir=C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo
rem check if the directory entered exists
IF NOT EXIST "%csgodir%" echo that directory doesn't exist, try again & GOTO setcsgodir

rem append
echo %csgodir%>> settings.txt

cls

echo - [done] -
echo.
echo your steamid is %mysteamid%
echo your csgo directory is %csgodir%
echo.
 echo if you made any mistakes, run this file again.
echo.
echo press any key to exit


pause >nul

