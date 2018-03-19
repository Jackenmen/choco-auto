$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
  packageName            = 'comodo-firewall'
  fileType               = 'exe'
  url                    = 'http://cdn.download.comodo.com/cis/download/installs/1000/xml_binaries/cis/cis_setup_x64.msi'
  checksum               = '42704805e8d61c86ec81e7b2a96c7188f0696cfa2a50f5818017312b4f1a8d22'
  checksumType           = 'sha256'
  silentArgs             = '/S'
  validExitCodes         = @(0)
  softwareName           = 'Comodo Firewall *'
}
Install-ChocolateyPackage @packageArgs