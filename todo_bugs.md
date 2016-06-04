# todo
* account for other division names. eg I've seen CAL-im = "CSIM". unexpected names are saved to $configdir\log.txt
* handle special characters (UTF8). currently, these might be replaced, and break the indentation of the table
* remove the need for temp files - do things in one shot
* create an install file

# bugs
* (valve) the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them. plenty of examples. tweeted @csgo_dev, no response
* "clear;status;condump" does not wait for "status" to complete before issuing "condump". need to find a reliable, one-shot method to execute these commands in succession so we can bind one key to execute all commands in order. for now, you must manually type all three commands, or bind the first two to X and the last to Y.
* if there is only one user in the condump, $allaliases.Length returns the length of the one alias, not how many aliases there are


