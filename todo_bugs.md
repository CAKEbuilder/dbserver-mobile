# todo
* account for other division names. unexpected names are saved to $configdir\log.txt
* instead of asking the user for their steamid, find all configdir folders yourself.
* account for double quotes in an alias
* add dump binds:
 * bind [ dump1
 * alias dump1 "clear; status; bind [ dump2"
 * alias dump2 "condump; bind [ dump1"
* error check each ID read from condump. if condump fails to export correctly, skip the record and try to continue


# bugs
* (valve) the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them. plenty of examples. tweeted @csgo_dev, no response
* if there is only one user in the condump, $allaliases.Length returns the length of the one alias, not how many aliases there are


