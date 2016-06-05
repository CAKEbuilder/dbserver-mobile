# todo
* account for other division names. unexpected names are saved to $configdir\log.txt
* handle special characters in the aliases. currently, these might be replaced, and break the indentation of data in the table
* test if the directory input in the setup not only exists, but contains csgo.exe
* change pipe delimiter to something less common. aliases that contain pipes mess things up
* account for double quotes in an alias
* add dump binds:
 * bind [ dump1
 * alias dump1 "clear; status; bind [ dump2"
 * alias dump2 "condump; bind [ dump1"

# bugs
* (valve) the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them. plenty of examples. tweeted @csgo_dev, no response
* if there is only one user in the condump, $allaliases.Length returns the length of the one alias, not how many aliases there are


