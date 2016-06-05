# todo
* account for other division names. unexpected names are saved to $configdir\log.txt
* handle special characters in the aliases. currently, these might be replaced, and break the indentation of data in the table

# bugs
* (valve) the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them. plenty of examples. tweeted @csgo_dev, no response
* if there is only one user in the condump, $allaliases.Length returns the length of the one alias, not how many aliases there are


