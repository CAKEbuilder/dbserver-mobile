tool for MM and public servers. shows hours played and league experience for all players in the game you're in.

# setup instructions
* download the .zip and extract the folder anywhere on your computer: https://github.com/CAKEbuilder/dbserver-mobile/archive/master.zip
* double click "compatability.bat". if there are no problems, you will be told to press any key to continue. if there are problems, download Windows Management Framework 4.0 (https://www.microsoft.com/en-us/download/details.aspx?id=40855)

# use the script
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
