$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
  packageName            = 'chrome-remote-desktop-host'
  fileType               = 'msi'
  url                    = 'https://dl.google.com/dl/edgedl/chrome-remote-desktop/chromeremotedesktophost.msi'
  checksum               = '6418fd7b0f00b032227d59c0f5b483ed17a9384efd2544fc23b36ff269123a9f'
  checksumType           = 'sha256'
  silentArgs             = '/qn /norestart'
  validExitCodes         = @(0)
  softwareName           = 'Chrome Remote Desktop Host *'
}
Install-ChocolateyPackage @packageArgs