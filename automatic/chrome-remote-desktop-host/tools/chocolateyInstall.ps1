$ErrorActionPreference = 'Stop'
 
[array]$key = Get-UninstallRegistryKey -SoftwareName "Chrome Remote Desktop Host"
$alreadyInstalled = $false
$version = '76.0.3809.21'

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
  checksum               = '1c024b6021c6a2826d970fb25372d3a872aef2563579d750726e5a55b511fe34'
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
