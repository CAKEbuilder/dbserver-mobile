Get league history for users in your current session

# instructions
### prepare the script
in December 2015, Valve updated the default path to store csgo cfgs. at a minimum, you will have to edit the .ps1 to have your unique path ($configdir). edit the first two lines of the .ps1 and update the paths.

* save the .ps1 anywhere on your computer
* right click the .ps1 and edit it with any text editor
* change the path in the double quotes for $csgodir to match your computer's directory to csgo (usually "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo")
* change the path in the double quotes for configdir to match your computer's directory to csgo config files (usually "C:\Program Files (x86)\Steam\userdata\%acc_specific_numbers%\730\local\cfg")

### prepare powershell
powershell does not allow you to execute scripts you've downloaded from the internet by default.

* press Win + S, type "powershell" without quotes. Right click Windows Powershell and Run As Administrator
* type "Set-ExecutionPolicy RemoteSigned" without quotes. when asked, type Y and press enter

### run the script
* launch csgo and join a game with players. open the console
* type "clear", press enter
* type "status", press enter
* type "condump", press enter
* minimize csgo, right click the .ps1 file, and click Run with Powershell
	
### get the results
* when the script finishes, type "exec export" in console
