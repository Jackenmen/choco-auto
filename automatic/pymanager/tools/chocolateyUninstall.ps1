$ErrorActionPreference = 'Stop'

$appxPackageName = "PythonSoftwareFoundation.PythonManager"

$appxPackage = Get-AppxPackage -Name $appxPackageName | Select-Object -Last 1

if ($appxPackage -eq $null) {
    Write-Warning "$appxPackageName has already been uninstalled through other means."
    return
}

Remove-AppxPackage -Package $appxPackage
