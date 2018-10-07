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
  url                    = 'https://www.sandboxie.com/attic/SandboxieInstall-526.exe'
  checksum               = 'c736313c14844aeb134edd4d7a4e47ccb86e93f33adaeb0ac1f83369352487cd'
  checksumType           = 'sha256'
  silentArgs             = $silentArgs
  validExitCodes         = @(0)
  softwareName           = 'Sandboxie *'
}

Install-ChocolateyPackage @packageArgs
