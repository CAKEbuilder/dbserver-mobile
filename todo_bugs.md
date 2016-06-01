# todo
* account for other division names. eg I've seen CAL-im = "CSIM". unexpected names are saved to $configdir\log.txt
* create functions for repetitive tasks. eg, "clean" function for resetting $currentbest and $best
* add a "best user" feature that shows who has the highest experience

# bugs
*   the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them. plenty of examples. tweeted @csgo_dev, no response
*   randomly get this error. I believe it's only an ISE issue and won't effect users: "Exception from HRESULT: 0x800A01B6" caused by line "$full = ($html.ParsedHtml.getElementsByTagName(‘td’) | Where ..."
* "clear;status;condump" does not wait for "status" to complete before issuing "condump". need to find a reliable, one-shot method to execute these commands in succession so we can bind one key to execute all commands in order. for now, you must manually type all three commands, or bind the first two to X and the last to Y.
