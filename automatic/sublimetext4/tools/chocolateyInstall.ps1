$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$softwareName = 'Sublime Text'

$packageArgs = @{
  packageName            = $packageName
  fileType               = 'exe'
  url                    = 'https://download.sublimetext.com/sublime_text_build_4145_x64_setup.exe'
  checksum               = '42e50b59c5ae6d803a6ac87ccf12b0d215572bfdfc39b8f9448085b6f97d290c'
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes         = @(0)
}

Install-ChocolateyPackage @packageArgs
