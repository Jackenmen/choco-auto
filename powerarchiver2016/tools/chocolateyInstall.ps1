$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
  packageName            = 'powerarchiver2016'
  fileType               = 'msi'
  url                    = 'https://github.com/jack1142/choco-auto/releases/download/powerarchiver2016/setup.msi'
  checksum               = 'f7e3629344287e963d7171d780bea153924e8ba269b543209993d5fd23c1d9f5'
  checksumType           = 'sha256'
  silentArgs             = '/qn /norestart'
  validExitCodes         = @(0)
  softwareName           = 'PowerArchiver 2016 *'
}
Install-ChocolateyPackage @packageArgs