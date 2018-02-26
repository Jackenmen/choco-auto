$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
  packageName            = 'fastimageresizer'
  fileType               = 'exe'
  url                    = 'https://adionsoft.net/fastimageresize/FastImageResizer_v098.exe'
  checksum               = 'f0a91e31050e0f5df39f5c484a66adf83f42354305694fd2b092b87c2ae42cf5'
  checksumType           = 'sha256'
  silentArgs             = '/verysilent'
  validExitCodes         = @(0)
  softwareName           = 'Fast Image Resizer *'
}
Install-ChocolateyPackage @packageArgs