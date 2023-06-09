$ErrorActionPreference = 'Stop'
 
[array]$key = Get-UninstallRegistryKey -SoftwareName "Chrome Remote Desktop Host"
$alreadyInstalled = $false
$version = '115.0.5790.10'

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
  checksum               = 'e4b601638bfd827cb0aab9504fb0221ba7e2ba06e3a0dfd13df68ea8eb5bd184'
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
