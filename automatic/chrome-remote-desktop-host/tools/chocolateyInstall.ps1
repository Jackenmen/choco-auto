$ErrorActionPreference = 'Stop'
 
[array]$key = Get-UninstallRegistryKey -SoftwareName "Chrome Remote Desktop Host"
$alreadyInstalled = $false
$version = '151.0.7922.13'

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
  checksum               = '4d4810a9f10b3fc663fb114246328faeceb2e6eb82f32e08a844effadc0c484e'
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
