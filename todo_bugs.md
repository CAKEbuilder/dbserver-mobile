# todo
* account for other division names. unexpected names are saved to $configdir\log.txt
* instead of asking the user for their steamid, find all configdir folders yourself.
* account for double quotes in an alias
* provide user with dump binds for autoexec:
 * // condump
 * bind [ +dump
 * alias +dump "clear; status"
 * alias -dump "condump"
 * bind ] "exec results"
* error check each ID read from condump. if condump fails to export correctly, skip the record and try to continue


# bugs
* (valve) the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them. plenty of examples. tweeted @csgo_dev, no response
* if there is only one user in the condump, $allaliases.Length returns the length of the one alias, not how many aliases there are


