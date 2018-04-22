$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
  packageName            = 'dds-thumbnail-viewer'
  fileType               = 'exe'
  url                    = 'http://download.nvidia.com/developer/NVTextureSuite/DDS_viewer.exe'
  checksum               = '57e65c30e8c38b09fff818e9636f6c2f9ac58b92bf6b802a7aa5156c1e75e6a7'
  checksumType           = 'sha256'
  silentArgs             = '/s'
  validExitCodes         = @(0)
  softwareName           = 'DDS Thumbnail Viewer *'
}
Install-ChocolateyPackage @packageArgs