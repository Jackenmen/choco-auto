$ErrorActionPreference = 'Stop'
 
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$silentSetupFile = Join-Path $toolsPath "..\setup.iss"
$programFilesLocation = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]
$installPath = Join-Path $programFilesLocation "NVIDIA Corporation\DDS Thumbnail Viewer"

. $toolsPath\helpers.ps1
CreateSilentSetupFile $silentSetupFile $installPath

$packageArgs = @{
  packageName            = 'dds-thumbnail-viewer'
  fileType               = 'exe'
  url                    = 'https://download.nvidia.com/developer/NVTextureSuite/DDS_viewer.exe'
  checksum               = '57e65c30e8c38b09fff818e9636f6c2f9ac58b92bf6b802a7aa5156c1e75e6a7'
  checksumType           = 'sha256'
  silentArgs             = '/s /f1' + $silentSetupFile
  validExitCodes         = @(0)
  softwareName           = 'DDS Thumbnail Viewer *'
}
Install-ChocolateyPackage @packageArgs