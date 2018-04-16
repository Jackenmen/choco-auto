$ErrorActionPreference = 'Stop'

$packageName = 'powerarchiver2016'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChocolateyWebFile -PackageName $packageName -File "$toolsDir\powarc161024.exe" -Url 'http://dl.powerarchiver.com/2016/powarc161024.exe' -Checksum 'a909f952d011caa59349af59e75194103329bbaeb2466aa5e8ada214ea45bf03' -ChecksumType 'sha256'
Get-ChocolateyUnzip -File "$toolsDir\powarc161024.exe" -Destination "$toolsDir"

$fileLocation = Join-Path $toolsDir "setup.msi"

$packageArgs = @{
  packageName            = $packageName
  fileType               = 'msi'
  file                   = $fileLocation
  silentArgs             = '/qn /norestart'
  validExitCodes         = @(0)
  softwareName           = 'PowerArchiver 2016 *'
};

Install-ChocolateyInstallPackage @packageArgs