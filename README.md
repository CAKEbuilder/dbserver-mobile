Show hours played and league experience for all players in the game you're in. Works in public servers, MM, ect.

# instructions
### prepare the script
simply edit the "script" file with Notepad and change the first three lines.

* save the "script" file anywhere on your computer
* right click the script, click and edit, click Notepad
* enter your steamid in the double quotes of the first line
* enter your csgo directory in the double quotes of the second line (if you installed CSGO to the default directory, you don't need to change this)
* the third line is optional, put nothing inside the double quotes to skip it. if you decide to use this, enter a button (eg "k"). every time you press "k" in game, one line of the results will be sent to mm1 at a time.
* save and close notepad

### prepare powershell
quickly change your powershell settings

* click on the Windows start menu, type "powershell" without quotes and do not press enter. right click "Windows Powershell", then click Run As Administrator
* copy this line and paste it into powershell (don't copy the quotes): "Set-ExecutionPolicy RemoteSigned"
* when asked, type Y and press enter

# once you've done everything above this point, the script is setup. you will not have to repeate any of those steps again.

### using the script
* launch csgo and join a game with players (public is fine). open the console
* type "clear", press enter. type "status", press enter. type "condump", press enter
* minimize csgo, right click the script file, and click Run with Powershell. powershell will open and show you the progress
* when the script is finished, powershell will close. now in csgo, type "exec export" in the console
