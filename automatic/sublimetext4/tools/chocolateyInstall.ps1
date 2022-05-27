$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'sublimetext4'
  fileType               = 'exe'
  url                    = 'https://download.sublimetext.com/sublime_text_build_4133_x64_setup.exe'
  checksum               = '6936d0e2998b21570480533de001b96d33dc56888f8424196cc205f07a241e24'
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes         = @(0)
  softwareName           = 'Sublime Text 4'
}

Install-ChocolateyPackage @packageArgs
