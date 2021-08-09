$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
  packageName            = 'audacity-ffmpeg'
  fileType               = 'exe'
  file64                 = ''
  silentArgs             = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes         = @(0)
  softwareName           = 'FFmpeg (Windows) for Audacity *'
}

Install-ChocolateyInstallPackage @packageArgs
