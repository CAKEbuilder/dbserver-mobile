# about
######tool for MM and public servers. shows hours played and league experience for all players in the game you're in. results are shown in the console and can optionally also be sent to ingame chat.
* make sure you meet the requirements
* type 3 commands in console
* run the script

the results are sent to the csgo console

# requirements
* Windows 7 or higher
* Powershell version 5
 * don't worry, Windows 10 has this by default. provided is a file called "requirements". double click the file to check if you have it. if your current version is too low, the download page for the file you need will open automatically

# setup instructions
* download the .zip and extract the folder anywhere on your computer: https://github.com/CAKEbuilder/dbserver-mobile/archive/master.zip
* double click "requirements.bat". if you pass the requirements, you will be asked to press any key to continue. if not, your browser will open and the prompts will tell you which file to download (you only need to download one file).
 * if you needed to download a file: install it, restart, and run the requirements file again to verify the installation.

# using the script
* open csgo and join a game with players. open the console
 * type "clear" (press enter)
 * type "status" (press enter)
 * type "condump" (press enter)
* double click the "run" file from the folder you downloaded. a window will open to show you the progress. when it's done, you'll be asked to press Enter to close it.
* maximize csgo, type "exec results" in console to get the results

# how it works
the "condump" command sends the text from the console to a file (with some major caveats, see below). for each steamid, we contact steamcommunity.com and legit-proof.com and scrape for data we want.

# caveats
the "condump" command unreliably sends text from the console to a file. it will frequently remove characters, misalign data, repeate data, ect. as a result, the output of the script may come out distorted. 


