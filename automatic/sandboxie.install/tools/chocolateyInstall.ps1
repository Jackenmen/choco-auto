$ErrorActionPreference = 'Stop'

$silentArgs = '/S'
$key = Get-UninstallRegistryKey -SoftwareName "Sandboxie *"
if ($key) { 
  $silentArgs += ' /upgrade'
} else {
  $silentArgs += ' /install'
}

$pp = Get-PackageParameters

if ($pp.Language) {
  if ($pp.Language -match '^\d+$') {
    $pp.Language = $pp.Language -as [int32]
  }
  try {
    $lang = [System.Globalization.Cultureinfo]::GetCultureInfo($pp.Language)
  } catch {
    Write-Error "Couldn't find locale '$($pp.Language)'. Aborting..."
  }
  Write-Host "Using language: $($lang.DisplayName)"
  $silentArgs = "/lang=$($lang.LCID) $silentArgs"
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
