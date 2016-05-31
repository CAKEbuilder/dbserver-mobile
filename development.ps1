$csgodir = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo"
$configdir = "C:\Program Files (x86)\Steam\userdata\993812\730\local\cfg"
<# ^^^ CHANGE THE VALUES ABOVE ^^^ #>



<#
    todo
        account for other league's division names. eg I've seen CAL-im = "CSIM"
        create functions for repetitive tasks. eg, create "clean" function for resetting $currentbest and $best
        add funny random blurbs to post as experience for bots
        add a "best user" feature that shows who has the best experience
        add checking logic for when condump000.txt does not exist. remind the user to export it first, pause powershell, and tell them to press any key to continue
        consider making a scheduler that, when it sees condump000.txt, execs the ps1
        add support for if legit-proof.com is down
        show how much csgo time the user has played
        add support for if the user accidentally runs condump multiple times from ingame before running the ps1

    bugs
        the content in console is not reliably sent directly to the export via condump. aliases can be truncated, as well as the double quotes that surround them.
        will randomly get an error and have to restart ISE, maybe only an ISE issue.
            "Exception from HRESULT: 0x800A01B6" caused by line "$full = ($html.ParsedHtml.getElementsByTagName(‘td’) | Where ..."
#>


<# definitions #>
$condump = Get-Content "$csgodir\condump000.txt" | Select-String -Pattern "^#" | Select-Object -Skip 1 | Select-Object -SkipLast 1


# enable/disable export when testing
$exporttxt = "$configdir\export.txt"
$exportcfg = "$configdir\export.cfg"
# $exporttxt = Out-Null

# remove previous export.txt/export.cfg files, if any exist
    if (Test-Path "$configdir\export*") {
        Remove-Item "$configdir\export*"
    }




<# static prompts before looped prompts #>

"[CAKEbuilder's legit-proof.com lookup]" >> $exporttxt
"" >> $exporttxt
"[alias](steamid)    [username]     [team]     [league]     [division]" >> $exporttxt
"------------------------------------------------------------------------" >> $exporttxt


<# extract the alias' from the double quotes #>
<#
$condump | foreach {
    $alias = $_ -split "`""
    $alias[1]
        }
#<


<# extract/save the Steam ID #>
$allsteamids = $condump | foreach {
                                    # remove "STEAM_"
                                    $steamid = $_ -split "STEAM_"

                                    # replace everything after first trailing space of the Steam ID, replace ":" with "%3A" (for legit-proof.com formatting), remove trailing space
                                    $steamid[1] -replace '^([^ ]+ ).+$','$1' `
                                    -replace ':','%3A' `
                                    -replace ' ',''
                          }

<# extract/save the alias #>
$i = 1
$allaliases = $condump | foreach {
                                    # get the alias, which is between quotes
                                    $alias = ($condump -split "`"")[$i]
                                    $alias
                                    $i = $i + 3
                          }


# loop through all the steam ids

Write-Host "evaluating users (" $allaliases.Length ")..."
Write-Host ""

$x=0
foreach ($id in $allsteamids) {

        $url = "http://legit-proof.com/search?q=STEAM_" + $id
        $html = Invoke-WebRequest -Uri $url

        # get the data we want
        # this only considers the first page of legit-proof, a max of 20 rec.
        # to do: figure out how to capture multiple pages. the best division might be on page 2, ect
        $full = ($html.ParsedHtml.getElementsByTagName(‘td’) | Where { $_.className -ne ‘text-center’ } ).innerText

        # if you found td elements on the page, continue processing.
        # if not, the user has no experience. ridicule them.
        if ($full) {

                        # evaluate the divisions, save the best
                        # the table on legit-proof stores the division in cell 5. this is "4" in ps, because 0 1 2 3 4. check every 5th cell (division)
                        for ($i=4; $i -le $full.Length; $i=$i+5) {

                                if ($full[$i] -like '*Invite*') { 
                                # if ($full[$i] -like '*banana*') { 
    
                                    $best = $allaliases[$x] + " (" + $full[$i-4] + ") - " + $full[$i-3] + ", " + $full[$i-2] + ", " + $full[$i-1] + ", " + $full[$i]
                                    # store the current best division. do not overwrite if of a lesser division
                                    $currentbest = "invite"

                                } elseif ($full[$i] -like '*Main*' -and $currentbest -ne "invite") {
        
                                    $best = $allaliases[$x] + " (" + $full[$i-4] + ") - " + $full[$i-3] + ", " + $full[$i-2] + ", " + $full[$i-1] + ", " + $full[$i]
                                    $currentbest = "main"

                                } elseif ($full[$i] -like '*Intermediate*' -and $currentbest -ne "invite" -and $currentbest -ne "main") {
        
                                    $best = $allaliases[$x] + " (" + $full[$i-4] + ") - " + $full[$i-3] + ", " + $full[$i-2] + ", " + $full[$i-1] + ", " + $full[$i]
                                    $currentbest = "im"

                                } elseif ($full[$i] -like '*Open*' -and $currentbest -ne "invite" -and $currentbest -ne "main" -and $currentbest -ne "im") {
        
                                    $best = $allaliases[$x] + " (" + $full[$i-4] + ") - " + $full[$i-3] + ", " + $full[$i-2] + ", " + $full[$i-1] + ", " + $full[$i]
                                    $currentbest = "open"
                                  
                                # if $currentbest is null (hasn't been set), we don't know about this division
                                } elseif (!$currentbest) { 
                                                           $best = $allaliases[$x] + " (" + $full[$i-4] + ") - " + "Unrecognized division..."
                                                           $currentbest = "unknown"

                                                           # append the log with the league/division, so we know what else we should account for
                                                           "League: " + $full[$i-1] + ", Division: " + $full[$i] | Out-File -Append -FilePath "$configdir\log.txt"
                                }

                        }

        
        # distinguish if the user has no experience, or if you are evaluataing a bot
        } else { 
        
                # if the $id is null, we are evaluating a bot...
                if (!$id) {

                    $best = $allaliases[$x] + " (BOT) - " + $allaliases[$x] + " has seen more than you know..."
                    $currentbest = "bot"

                } else {                          

                    # we normally grab the steamid from the html table. we know what it is though, so we just need to unformat it.
                    $id_reformatted = $id -replace '%3A',':'
        
                    $best = $allaliases[$x] + " (" + $id_reformatted + ") - " + "This noob has no experience..."

                }

        }
                # show the output in powershell or not. useful when testing
                $best >> $exporttxt
                # show progress of user evaluation in powershell
                Write-Host "     user" ($x+1) "- done"
                # $best

                # reset the current best, otherwise someone else's experience might negate the results of the current alias we're looking at
                $currentbest = ""
                $best = ""
                
                $x = $x + 1
}

# show the user who has the highest league experience (you haven't added this in yet)
# " " >> $exporttxt
# $absolutebest >> $exporttxt


<# save the results to export.cfg #>
Write-Host ""
Write-Host "formatting results..."
Write-Host ""

foreach($line in (gc $exporttxt)) {
    
    $front = "echo `""
    $back = "`""

    $combine = $front + $line + $back

    Add-Content -path $exportcfg -value $combine
}

# add a "clear" line to the export. we didn't do this earlier, because we don't want it formatted with double quotes
set-content $exportcfg -value "clear", (gc $exportcfg)

# remove all condump files in the csgo directory
    if (Test-Path "$csgodir\condump*.txt") {
        Remove-Item "$csgodir\condump*.txt"
    }


<# done #>
Write-Host "done"
Write-Host ""


<#

# reset all variables
$csgocfgdir = ""
$condump_path = ""
$condump = ""
$allsteamids = ""
$steamid = ""
$i = ""
$allaliases = ""
$alias = ""
$x= ""
$id = ""
$allsteamids = ""
$url = ""
$html = ""
$full = ""
$html = ""
$full = ""
$i= ""
$best = ""
$currentbest = ""
$id_reformatted = ""

#>
