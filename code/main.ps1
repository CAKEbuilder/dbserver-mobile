<# 
 for each drive letter, check if csgo is installed (is it possible that people install in 'Program Files'?). during this check, also find the config directory
 look for multiple cs accounts existing on the computer
 (continue breaking down the steps...)

#>

<# dynamically find all csgo directories on the computer #>

# initialize the array
$locations = @()

# get the drive letters. drivetype 3 is local disk, and should exclude network (4) and removable (2) drives
foreach($drive in (gwmi win32_logicaldisk -Filter "DriveType='3'").DeviceID) {
    
    # find the csgo dir
    if (Test-Path "$drive\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\") {

        $csgodir = "$drive\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\"
        
    }

    # find the config dir
    if (Test-Path "$drive\Program Files (x86)\Steam\userdata\") {
        foreach($folder in ((gci "$drive\Program Files (x86)\Steam\userdata\").Name)) {

            $location = "$drive\Program Files (x86)\Steam\userdata\$folder\730\local\cfg"

            #$folder
            if (Test-Path "$drive\Program Files (x86)\Steam\userdata\$folder\730\local\cfg") {

                $locations += $location

            } 
        }
    }
}

# check if there are multiple csgo accounts on the computer.
if (($locations).Length -gt 1) {
    #Write-Host 'there are multiple csgo accounts on this computer.'
    } else {
    #Write-Host 'only one csgo account found'
}

# make sure CS is installed
if (!$locations) {
    Write-Host 'cs is not installed on this computer.'
    exit
}


<# lookup player info #>

# here we go... massive foreach loop to parse the multiple directories...
$wehaveresults = 0
foreach ($location in $locations) {

        # if we already have the results, copy them to all csgo directories and finish
        if ($wehaveresults -eq 1) {
            Write-Host ''
            Write-Host 'we already have the results. copying them to all csgo accounts'
            Write-Host ''
        
            # copy results.cfg to any other config directories we know about
            $i=1
            foreach ($location in $locations) {

                $baseloc = $locations[0]
                $baselocresults = $locations[0] + '\results.cfg'

                # skip the first location in the array, we don't want to overwrite the files
                if ($location -ne $baseloc) {
                    Copy-Item $baselocresults $location
                }

                $i=$i+1
            }

            Write-Host 'done'
            Write-Host ''
            exit
        
        }
        #>


        # define the current configdir, which was previously sent as a parameter
        $configdir = $location

        # make sure a condump file exists. if not, let the user know what to do, then exit the script
        $condump_file = Get-ChildItem "$csgodir\condump*.txt"
        if (!$condump_file) {
	        Write-Host "There is no condump file."
	        Write-Host "Open a CSGO, join a game, then type clear, status, condump."
		
	        pause

	        # break out of the entire script
	        exit
	}

        # test the connection to legit-proof.com
        #    if there is an error, inform the user, then exit the script
        #    if there is no error, send the content to null, because we don't care what it is - only that we got something back
        $url = "http://legit-proof.com"
        # fail for testing
        # $url = "banana"

        try {
	        Invoke-WebRequest -Uri $url | Out-Null
	        } catch {
		        "Error contacting the webpage (is legit-proof.com down?)"
		
                pause
		        exit
	}

        # definitions
        $condump_file = Get-ChildItem "$csgodir\condump*.txt" | select-object -last 1
        $condump = Get-Content $condump_file | Select-String -Pattern "^#" | Select-Object -Skip 1 | Select-Object -SkipLast 1
        $datetime = (Get-Date -format "yyyyMMdd") + " - "
        $exportcfg = "$configdir\results.cfg"
        $exporttxt = "$configdir\export.txt"
        $exporttxt_delim = "$configdir\export_delim.txt"
        $bindcfg_name = "userstats_bind.cfg"
        $bindcfg = "$configdir\$bindcfg_name"

        # purge old stuff. get rid of this section in the future, along with the need for temp files
        if (Test-Path "$configdir\export*") {
            Remove-Item "$configdir\export*"
        }

        if (Test-Path "$bindcfg") {
            Remove-Item "$bindcfg"
        }

        if (Test-Path "$exportcfg") {
            Remove-Item "$exportcfg"
        }


        # extract/save the Steam ID
        $allsteamids = $condump | foreach {
                                            # remove "STEAM_"
                                            $steamid = $_ -split "STEAM_"

                                            # replace everything after first trailing space of the Steam ID, replace ":" with "%3A" (for legit-proof.com formatting), remove trailing space
                                            $steamid[1] -replace '^([^ ]+ ).+$','$1' `
                                            -replace ':','%3A' `
                                            -replace ' ',''
                                  }

        $allsteamids_raw = $condump | foreach {
                                            # remove "STEAM_"
                                            $steamid = $_ -split "STEAM_"

                                            # replace everything after first trailing space of the Steam ID, replace ":" with "%3A" (for legit-proof.com formatting), remove trailing space
                                            $steamid[1] -replace '^([^ ]+ ).+$','$1' `
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

        # if condump is null, assume the user used condump at the wrong time, and break
        if (!$condump) {

            Write-Host "your condump file doesn't have any users in it. join a game that has players, type clear/status/condump, then run this file again"
            exit
        }


        # create the base header row
        # this defines the columns we'll use
        "alias(steamid),hours,division,league,team,name" >> $exporttxt


        Write-Host "number of users: (" $allaliases.Length ")"
        Write-Host ""


        <# calculate each user's communityid #>
        Write-Host "collecting hours played from Steam..."
        Write-Host ""

        $x=0
        foreach ($rawid in $allsteamids_raw) {


                    # progress bar, to let users know we are dilligently scraping Steam's site
                    # something like this...
                    #Write-Progress -Activity "collecting hours played" -status "Searching player X of Y" -PercentComplete ($x / ($allsteamids_raw.Length))
           
                    # steamid format - STEAM_X:Y:Z
                    # we don't need X
                    $rawidY = ($rawid -split ":")[1]
                    $rawidZ = ($rawid -split ":")[2]
                    # incidentally, this is the unique number used to distinguish accounts on your local machine. remember the "random" number in the $configdir path?
                    $accnumber = ([decimal]$rawidZ * 2)
                    $communityid = ($accnumber) + 76561197960265728 + $rawidY
                    $communityurl = "http://steamcommunity.com/profiles/" + $communityid

                    # for testing
                    # $rawid + "     " + $rawidY + "     " +  $rawidZ + "     " +  $accnumber + "     " +  $communityid + "     " + $communityurl

                    # for consistency's sake, match the format used in the legit-proof loop
                    $url = $communityurl
                    $html = Invoke-WebRequest -Uri $url

                    # to find what we can scrape for to distinguish private and public profiles
                    #$html.AllElements >> dump.txt

                    # the CSGO recently played section
                    # $html.ParsedHtml.getElementsByClassName('game_info') | Where { $_.innerHTML -like "*Counter-Strike: Global Offensive*" }
                    # ($html.ParsedHtml.getElementsByClassName('game_info') | Where { $_.innerHTML -like "*Counter-Strike: Global Offensive*" }).textContent

                    # get-variable -name "hours$x" -valueonly
            
            
                    # get hours played on record
                    $hours = ($html.ParsedHtml.getElementsByClassName('game_info') | Where { $_.innerHTML -like "*Counter-Strike: Global Offensive*" }).textContent -split 'on' | Select-Object -first 1
            
                    # check if the profile is private
                    $full = $html.ParsedHtml.getElementsByClassName('no_header')

            
                    if (($full | Where { $_.className -like '*private_profile*' })) {
                        "Private Profile" | set-variable -name "hours$x"
                    } else {
                        # attempt to remove the comma from the hours played, to remove conflict as the delimiter
                        #$hours | set-variable -name "hours$x"
                        $hours = ($hours).replace(',', '') | set-variable -name "hours$x"
                    }
            
                    Write-Host "     user" ($x+1) "- done"
                    $x = $x+1
        }

        Write-Host ""
        Write-Host "done"
        Write-Host ""

        Write-Host "looking up league history..."
        Write-Host ""

        # remove any commas from the steamids, because we will use this as our delimiter
        $allaliases = ($allaliases).replace(',', ' ')

        # reset $x
        $x=0
        foreach ($id in $allsteamids) {

                $url = "http://legit-proof.com/search?q=STEAM_" + $id
                $html = Invoke-WebRequest -Uri $url

                # get the data we want
                # this only considers the first page of legit-proof, a max of 20 rec.
                # to do: figure out how to capture multiple pages. the best division might be on page 2, ect
                $full = ($html.ParsedHtml.getElementsByTagName('td') | Where { $_.className -ne 'text-center' } ).innerText

                # if you found td elements on the page, continue processing.
                # if not, the user has no experience. ridicule them.
                if ($full) {

                                # evaluate the divisions, save the best
                                # the table on legit-proof stores the division in cell 5. this is "4" in ps, because 0 1 2 3 4. check every 5th cell (division)
                                for ($i=4; $i -le $full.Length; $i=$i+5) {

                                        if ($full[$i] -like '*Invite*') { 
                                        #if ($full[$i] -like '*banana*') { 
    
                                            $best = $allaliases[$x] + "(" + $full[$i-4] + ") ," + (get-variable -name "hours$x" -ValueOnly) + "," + $full[$i] + "," + $full[$i-1] + "," + $full[$i-2] + "," + $full[$i-3]
                                            # store the current best division. do not overwrite if of a lesser division
                                            $currentbest = "invite"

                                        } elseif ($full[$i] -like '*Main*' -and $currentbest -ne "invite") {
        
                                            $best = $allaliases[$x] + "(" + $full[$i-4] + ") ," + (get-variable -name "hours$x" -ValueOnly) + "," + $full[$i] + "," + $full[$i-1] + "," + $full[$i-2] + "," + $full[$i-3]
                                            $currentbest = "main"

                                        } elseif ($full[$i] -like '*Intermediate*' -and $currentbest -ne "invite" -and $currentbest -ne "main") {
        
                                            $best = $allaliases[$x] + "(" + $full[$i-4] + ") ," + (get-variable -name "hours$x" -ValueOnly) + "," + $full[$i] + "," + $full[$i-1] + "," + $full[$i-2] + "," + $full[$i-3]
                                            $currentbest = "im"

                                        } elseif ($full[$i] -like '*Open*' -and $currentbest -ne "invite" -and $currentbest -ne "main" -and $currentbest -ne "im") {
        
                                            $best = $allaliases[$x] + "(" + $full[$i-4] + ") ," + (get-variable -name "hours$x" -ValueOnly) + "," + $full[$i] + "," + $full[$i-1] + "," + $full[$i-2] + "," + $full[$i-3]
                                            $currentbest = "open"
                                  
                                        # if $currentbest is null (hasn't been set), we don't know about this division
                                        } elseif (!$currentbest) { 
                                                                   $best = $allaliases[$x] + "(" + $full[$i-4] + ") ," + "Unrecognized division..."
                                                                   $currentbest = "unknown"

                                                                   # append the log with the league/division, so we know what else we should account for
                                                                   $datetime + "League: " + $full[$i-1] + ", Division: " + $full[$i] | Out-File -Append -FilePath "$configdir\log.txt"
                                        }

                                }

        
                # distinguish if the user has no experience, or if you are evaluataing a bot
                } else { 
        
                        # if the $id is null, we are evaluating a bot...
                        if (!$id) {

                            #$best = $allaliases[$x] + " (BOT) ," +  (get-variable -name "hours$x" -ValueOnly) + "," + $allaliases[$x] + " has seen more than you know..."
                            # attempt to show bot's hours as "X"
                            $best = $allaliases[$x] + " (BOT) , X, (none)"
                            $currentbest = "bot"

                        } else {                          

                            # we normally grab the steamid from the html table. we know what it is though, so we just need to unformat it.
                            $id_reformatted = $id -replace '%3A',':'
        
                            $best = $allaliases[$x] + " (" + $id_reformatted + ") ," + (get-variable -name "hours$x" -ValueOnly) + "," + "(none)"

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

        # if $bind has been set, export the bindcfg and add a line to execute it in the $exportcfg
        # if $bind is not set, the user doesn't want this feature
        # reset $x
        $x=0
        if ($key) {

            foreach($line in (gc $exporttxt) -replace ",",", ") {

                # you should also replace any semi colons just to be safe

                $combine = "alias userstats" + $x + " `"say " + $line + "; bind " + $key + " userstats" + ($x+1) + "`""

                Add-Content -path $bindcfg -value $combine

                $x=$x+1
            }

            # bind the key, ignore userstats0 because this is just the header line
            set-content $bindcfg -value "bind $key userstats1", (gc $bindcfg)

            Add-Content -path $bindcfg -value "alias userstats$x `"say done; bind $key userstats1`""

            }


        # import the csv
        Import-CSV $exporttxt -Delimiter "," | Format-Table -AutoSize | Out-File $exporttxt_delim #-encoding UTF8 $exporttxt_delim


        <#
        # add more header info
        # encoding to preserve special characters in aliases. this makes it to $exporttxt_delim, but is pointless since we don't encode $exportcfg later. need to revisit this
        set-content -encoding UTF8 $exporttxt_delim -value "-------------------------------------", (gc $exporttxt_delim)
        set-content -encoding UTF8 $exporttxt_delim -value "CAKEbuilder's legit-proof.com lookup", (gc $exporttxt_delim)
        set-content -encoding UTF8 $exporttxt_delim -value "-------------------------------------", (gc $exporttxt_delim)
        #>


        foreach($line in (gc $exporttxt_delim)) {
    
            $front = "echo `""
            $back = "`""

            $combine = $front + $line + $back
    
            #Add-Content -path $exportcfg -encoding UTF8 -value $combine
            #$combine >> $exportcfg
            $combine | Out-File $exportcfg -Append
        }


        # add a "clear" line to the export. we didn't do this earlier, because we don't want it formatted with double quotes
        set-content $exportcfg -value "clear", (gc $exportcfg)
        # also execute the $bindcfg, if $bind is used
        if ($key) {
    
            Write-Host "binding $key to send results in mm1..."
            Write-Host ""
    
            set-content $exportcfg -value "exec $bindcfg_name", (gc $exportcfg)
    
            # may want to remove ", (none)" in $bindcfg
            (get-content $bindcfg) -replace ', (none)','' | set-content $bindcfg

            }



            $wehaveresults = 1

        # if there is only one csgo account found, finish here
        if (($locations).Length -eq 1 ) {
            Write-Host 'done'
        }


}

