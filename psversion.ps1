# note: Win10 comes with Powershell v5 by default
# https://4sysops.com/archives/powershell-versions-and-their-windows-version/#powershell-and-windows-versions

#definitions
$url = 'https://www.microsoft.com/en-us/download/details.aspx?id=50395'
#$psver = $PSVersionTable.PSVersion.Major
$psver=4

# get the OS architecture
if ([Environment]::Is64BitOperatingSystem) {
    $arch = 'x64'
    } else {
    $arch = 'x86'
}





# error if we can't determine the architecture
if ($arch -ne 'x86' -and $arch -ne 'x64') {
    Write-Host 'cannot get your OS architecture'
    Write-Host 'please contact CAKEbuildercs@gmail.com'
    pause
    exit
}




# inform the user on what they need to do, if anything
if ($psver -lt 5 ) {

    Write-Host "Powershell version:"$psver
    Write-Host "OS arch:"$arch
    Write-Host ""
    Write-Host "This version is too low, download Powershell 5"
    Write-Host ""
    if ($arch -eq 'x64') {
        Write-Host 'if you have Windows 7, download the 2nd file (Win7AndW2K8R2-KB3134760-x64.msu)'
        Write-Host ''
        Write-Host 'if you have Windows 8/8.1, download the 4th file (Win8.1AndW2K12R2-KB3134758-x64.msu)'
    }
    if ($arch -eq 'x86') {
        Write-Host 'if you have Windows 7, download the 3rd file (Win7-KB3134760-x86.msu)'
        Write-Host ''
        Write-Host 'if you have Windows 8/8.1, download the 5th file (Win8.1-KB3134758-x86.msu)'
    }
    Write-Host ''
    Write-Host "when you are ready, press Enter and I will bring you to the download page"
    Write-Host ''
    Write-Host ''
    pause
    # open the download page using the default browser
    Start-Process $url

} else {
    
    Write-Host "Powershell version:"$psver
    Write-Host "OS arch:"$arch
    Write-Host ""
    Write-Host "This version will work"
    Write-Host ""
    Write-Host "you're all set!"
    Write-Host ""
    pause

    }

