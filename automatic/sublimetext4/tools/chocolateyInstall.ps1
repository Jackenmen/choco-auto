$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'sublimetext4'
  fileType               = 'exe'
  url                    = 'https://download.sublimetext.com/sublime_text_build_4130_x64_setup.exe'
  checksum               = '7e928209f0d485bf5ae081c78287eea8552e3e6e6996fe5354d00b93f777053c'
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes         = @(0)
  softwareName           = 'Sublime Text 4'
}

Install-ChocolateyPackage @packageArgs
