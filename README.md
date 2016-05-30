Lookup league history for users in current session

# instructions
## prepare the script
* save the .ps1 anywhere on your computer
* right click the .ps1 and edit it with any text editor
* change the path in the double quotes for $csgodir to match your computer's directory to csgo
* change the path in the double quotes for configdir to match your computer's directory to csgo config files (usually "C:\Program Files (x86)\Steam\userdata\%acc_specific_numbers%\730\local\cfg")
## prepare powershell
* press Win + S, type "powershell" without quotes. Right click Windows Powershell and Run As Administrator
* type "Set-ExecutionPolicy RemoteSigned" without quotes. when asked, type Y and press enter
## run the script
* launch csgo and join a game with players. open the console
* type "clear", press enter
* type "status", press enter
* type "condump", press enter
* minimize csgo, right click the .ps1 file, and click Run with Powershell
	
# todo
      account for other league's division names. eg I've seen CAL-im = "CSIM"
      create functions for repetitive tasks. eg, create "clean" function for resetting $currentbest and $best
      add funny random blurbs to post as experience for bots
      add a "best user" feature that shows who has the best experience
      add checking logic for when condump000.txt does not exist. remind the user to export it first, pause powershell, and tell them to press any key to continue
      consider making a scheduler that, when it sees condump000.txt, execs the ps1
      add support for if legit-proof.com is down
      show how much csgo time the user has played
      add support for if the user accidentally runs condump multiple times from ingame before running the ps1
      make the output nicer
      
# bugs
        the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them.
        will randomly get an error and have to restart ISE, maybe only an ISE issue.
            "Exception from HRESULT: 0x800A01B6" caused by line "$full = ($html.ParsedHtml.getElementsByTagName(‘td’) | Where ..."
