# note: Win10 comes with Powershell v5 by default
# https://4sysops.com/archives/powershell-versions-and-their-windows-version/#powershell-and-windows-versions

#definitions
$url = 'https://www.microsoft.com/en-us/download/details.aspx?id=50395'
$psver = $PSVersionTable.PSVersion.Major

# get the OS version (make this prettier you lazy shit)
if ([System.Environment]::OSVersion.Version.Major -eq 7) {
    $osver = '7'
    }
# '-like' here because I'm not sure how 8.1 shows up even as a Major object...
if ([System.Environment]::OSVersion.Version.Major -like 8) {
    $osver = '8'
    }
if ([System.Environment]::OSVersion.Version.Major -eq 10) {
    $osver = '10'
    }


# get the OS architecture
if ([Environment]::Is64BitOperatingSystem) {
    $arch = 'x64'
    } else {
    $arch = 'x86'
}



# set the correct filename to download for this user
if ($arch -eq 'x64') {
    if ($osver -eq '7') {
        $file2download = 'Win7AndW2K8R2-KB3134760-x64.msu'
    }
    if ($osver -like '8') {
        $file2download = 'Win8.1AndW2K12R2-KB3134758-x64.msu'
    }
}
if ($arch -eq 'x86') {
    if ($osver -eq '7') {
        $file2download = 'Win7-KB3134760-x86.msu'
    }
    if ($osver -like '8') {
        $file2download = 'Win8.1-KB3134758-x86.msu'
    }
}

# error if we can't determine the architecture
if ($arch -ne 'x86' -and $arch -ne 'x64') {
    Write-Host 'cannot get your OS architecture'
    Write-Host 'please contact CAKEbuildercs@gmail.com'
    pause
    exit
}




# inform the user on what they need to do, if anything
if ($psver -lt 4 ) {

    # open the download page using the default browser
    Start-Process $url
    Write-Host "Powershell version:"$psver
    Write-Host "OS version:"$osver
    Write-Host "OS arch:"$arch
    Write-Host ""
    Write-Host "this version is too low, download Powershell 5"
    Write-Host ""
    Write-Host "I will open your browser to the download page. The only file you need to download and install is -"$file2download
    Write-Host ""

} else {
    
    Write-Host "Powershell version:"$psver
    Write-Host "OS version:"$osver
    Write-Host "OS arch:"$arch
    Write-Host ""
    Write-Host "this version will work"
    Write-Host ""
    Write-Host "you're all set!"
    Write-Host ""

    }

