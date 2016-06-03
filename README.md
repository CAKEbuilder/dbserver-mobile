Get league history for users in your current session

# instructions
### prepare the script
edit the .ps1 with Notepad and change the first three lines. if you don't want the bind, just leave it blank.

* save the .ps1 anywhere on your computer
* right click the .ps1 and edit it with any text editor
* enter your steamid in the double quotes of the first line
* enter your csgo directory in the double quotes of the second line
* enter in a key to bind an additional script to
** this is not required. if you assign this bind to "k", every time you press "k" in game, a different user's results will be sent to mm1. if you do not want this, don't put anything in the double quotes.
* save and close the file

### prepare powershell
powershell does not allow you to execute scripts you've downloaded from the internet by default.

* press Win + S, type "powershell" without quotes (do not press enter). Right click Windows Powershell and Run As Administrator
* type "Set-ExecutionPolicy RemoteSigned" without quotes. when asked, type Y and press enter

### run the script
* launch csgo and join a game with players. open the console
* type "clear", press enter
* type "status", press enter
* type "condump", press enter
* minimize csgo, right click the .ps1 file, and click Run with Powershell
	
### get the results
* when the script finishes, type "exec export" in console
