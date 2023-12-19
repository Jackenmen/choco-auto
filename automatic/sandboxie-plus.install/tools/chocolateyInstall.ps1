$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition

$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
$key = Get-UninstallRegistryKey -SoftwareName "Sandboxie-Plus *"

$pp = Get-PackageParameters

if ($pp.Language) {
  $silentArgs = "/LANG=$($pp.Language) $silentArgs"
}

$packageArgs = @{
  packageName            = 'sandboxie-plus.install'
  fileType               = 'exe'
  file                   = "$toolsPath\Sandboxie-Plus-x86-v1.12.5.exe"
  file64                 = "$toolsPath\Sandboxie-Plus-x64-v1.12.5.exe"
  silentArgs             = $silentArgs
  validExitCodes         = @(0)
  softwareName           = 'Sandboxie-Plus *'
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsPath\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" '' } }
