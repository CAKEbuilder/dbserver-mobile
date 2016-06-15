# get the OS architecture
if ([Environment]::Is64BitOperatingSystem) {
    $arch = 'x64'
    } else {
    $arch = 'x86'
}



# get the version of Powershell
$psver = $PSVersionTable.PSVersion.Major
if ($psver -lt 4 ) {

    Write-Host "Powershell version:"$psver
    Write-Host "OS:"$arch
    Write-Host ""
    Write-Host "this version is too low"
    Write-Host ""
    Write-Host "download Windows Management Framework 5 (the link is on the github page)"
    Write-Host ""

} else {
    
    Write-Host "Powershell version:"$psver
    Write-Host "OS:"$arch
    Write-Host ""
    Write-Host "this version will work"
    Write-Host ""
    Write-Host "you're all set!"
    Write-Host ""

    }

