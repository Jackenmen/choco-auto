$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'sublimetext4'
  fileType               = 'exe'
  url                    = 'https://download.sublimetext.com/sublime_text_build_4120_x64_setup.exe'
  checksum               = '4fad8022dcf6f9201b4986f452a53cab6c06e05f63355f5a28898a562d73fece'
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes         = @(0)
  softwareName           = 'Sublime Text 4'
}

Install-ChocolateyPackage @packageArgs
