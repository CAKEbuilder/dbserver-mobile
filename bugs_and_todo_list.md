# todo
* organize folder structure so that all files users interact with are at the root, and resources are in a folder
* account for cs not being installed on the computer at all
* handle special characters in the alias
* account for double quotes in an alias
* error check for malformed records in condump. if condump fails to export accurately, skip the record and continue
* account for other division names. unexpected names are exported to $configdir\log.txt
* test if anti virus software cares about the batch, or that it calls powershell without using the profile's execution policy
* during the next failure of the condump command, try con_log <filename>
* revisit the bind used to send results to mm1, remembering that many users make their configs read only
* provide user with dump binds for autoexec:
 * // condump
 * bind [ +dump
 * alias +dump "clear; status"
 * alias -dump "condump"
 * bind ] "exec results"

# bugs
* (on valve) the content in console is not reliably sent to the export via the "condump" command. errors include standard characters in aliases being truncated, double quotes surrounding aliases, ect. tweeted @csgo_dev, no response
* if there is only one user in the condump, $allaliases.Length returns the length (in characters) of the single alias, not how many aliases there are



