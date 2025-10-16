$ErrorActionPreference = 'Stop'
 
[array]$key = Get-UninstallRegistryKey -SoftwareName "Chrome Remote Desktop Host"
$alreadyInstalled = $false
$version = '142.0.7444.18'

if ($key.Count -ne 0) {
  $key | ForEach-Object {
    if ($_.DisplayVersion -eq $version) {
      $alreadyInstalled = $true
    }
  }
}

$packageArgs = @{
  packageName            = 'chrome-remote-desktop-host'
  fileType               = 'msi'
  url                    = 'https://dl.google.com/dl/edgedl/chrome-remote-desktop/chromeremotedesktophost.msi'
  checksum               = '7d879a6a65350fb862949ebed33e618a4f6c8d8d5b3deb08f9fb163b9ae29650'
  checksumType           = 'sha256'
  silentArgs             = '/qn /norestart'
  validExitCodes         = @(0)
  softwareName           = 'Chrome Remote Desktop Host'
}

if ($alreadyInstalled) {
  Write-Host "Chrome Remote Desktop Host $version is already installed."
} else {
  Install-ChocolateyPackage @packageArgs
}
