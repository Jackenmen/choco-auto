$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'sublimetext4'
  fileType               = 'exe'
  url                    = 'https://download.sublimetext.com/sublime_text_build_4125_x64_setup.exe'
  checksum               = 'df8334934611e88c6e5cb5041e911a3b39bdeb22befcbf805bb11a2a981d5543'
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes         = @(0)
  softwareName           = 'Sublime Text 4'
}

Install-ChocolateyPackage @packageArgs
