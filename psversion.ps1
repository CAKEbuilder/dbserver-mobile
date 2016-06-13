
$psver = $PSVersionTable.PSVersion.Major
if ($psver -lt 4 ) {

    Write-Host 'Powershell version (' $psver ') is too low'

} else {

    Write-Host 'your version of Powershell (' $psver ') will work. no further action is needed.'
    }

