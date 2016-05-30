# todo
* account for other division names. eg I've seen CAL-im = "CSIM". unexpected names are saved to $configdir\log.txt
* create functions for repetitive tasks. eg, "clean" function for resetting $currentbest and $best
* add funny random blurbs to post as experience for bots
* add a "best user" feature that shows who has the highest experience
* add logic to check for condump000.txt does not exist. if not, remind the user to export it first, pause powershell, and tell them to press any key to continue
* if other condumps exist (eg, user ran condump 3 times in game before running .ps1), use the one with the highest value (condump003.txt)
* account for legit-proof.com being down
* add support for if the user accidentally runs condump multiple times from ingame before running the ps1
* format the output better
* (later) show how much csgo time the user has played

# bugs
*   the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them.
*   will randomly get an error and have to restart ISE, maybe only an ISE issue.
* * "Exception from HRESULT: 0x800A01B6" caused by line "$full = ($html.ParsedHtml.getElementsByTagName(‘td’) | Where ..."
