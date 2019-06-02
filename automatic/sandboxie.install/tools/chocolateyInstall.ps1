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
  url                    = 'https://www.sandboxie.com/attic/SandboxieInstall-530.exe'
  checksum               = '7b131a6b9fcfc8581749eaccd8bd15e9628bcfe94fe9e90f143dae1416e82d7f'
  checksumType           = 'sha256'
  silentArgs             = $silentArgs
  validExitCodes         = @(0)
  softwareName           = 'Sandboxie *'
}

Install-ChocolateyPackage @packageArgs
