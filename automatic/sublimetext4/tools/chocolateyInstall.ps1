$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'sublimetext4'
  fileType               = 'exe'
  url                    = 'https://download.sublimetext.com/sublime_text_build_4129_x64_setup.exe'
  checksum               = '98ecd388f7d374ae29a7da3a56cb00f51cdea031b1fb4c596c23b0938acdddc6'
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes         = @(0)
  softwareName           = 'Sublime Text 4'
}

Install-ChocolateyPackage @packageArgs
