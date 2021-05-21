$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'sublimetext4'
  fileType               = 'exe'
  url                    = ''
  checksum               = ''
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes         = @(0)
  softwareName           = 'Sublime Text 4'
}

Install-ChocolateyPackage @packageArgs
