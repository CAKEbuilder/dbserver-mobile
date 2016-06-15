# note: Win10 comes with Powershell v5 by default
# https://4sysops.com/archives/powershell-versions-and-their-windows-version/#powershell-and-windows-versions

#definitions
$url = 'https://www.microsoft.com/en-us/download/details.aspx?id=50395'


# get the OS architecture
if ([Environment]::Is64BitOperatingSystem) {
    $arch = 'x64'
    } else {
    $arch = 'x86'
}

if ($arch -eq 'x64') {
    $file2download = 'Win7AndW2K8R2-KB3134760-x64.msu'
    } else {
    $file2download = 'Win7-KB3134760-x86.msu'
}



# get the version of Powershell
$psver = $PSVersionTable.PSVersion.Major
if ($psver -lt 4 ) {

    Start-Process $url
    Write-Host "Powershell version:"$psver
    Write-Host "OS Arch:"$arch
    Write-Host ""
    Write-Host "this version is too low, download Powershell 5"
    Write-Host ""
    Write-Host "I will open your browser to the download page. The only file you need to download and install is -"$file2download
    Write-Host ""

} else {
    
    Write-Host "Powershell version:"$psver
    Write-Host "OS Arch:"$arch
    Write-Host ""
    Write-Host "this version will work"
    Write-Host ""
    Write-Host "you're all set!"
    Write-Host ""

    }

