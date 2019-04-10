$ErrorActionPreference = 'Stop'

$silentArgs = '/S'
$key = Get-UninstallRegistryKey -SoftwareName "Sandboxie *"
if ($key) { 
  $silentArgs += ' /upgrade'
} else {
  $silentArgs += ' /install'
}

$packageArgs = @{
  packageName            = 'sandboxie.install'
  fileType               = 'exe'
  url                    = 'https://www.sandboxie.com/SandboxieInstall-529-2.exe'
  checksum               = 'bbc0093b1ccd9d6c09bb2abd1a1051304546e1c8a6661eb52dfdabea783330f0'
  checksumType           = 'sha256'
  silentArgs             = $silentArgs
  validExitCodes         = @(0)
  softwareName           = 'Sandboxie *'
}

Install-ChocolateyPackage @packageArgs
