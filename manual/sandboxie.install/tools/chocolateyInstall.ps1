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
  url                    = 'https://downloads.sophos.com/inst/GMNtRx6IQ6HmUvXYJRTPjQZD02MTA5/sandboxie/SandboxieInstall-531-4.exe'
  checksum               = '4577a1f5af37a9d2203e62dd49da947c79f5a0b0c679dd8db601aab5c0d57c6a'
  checksumType           = 'sha256'
  silentArgs             = $silentArgs
  validExitCodes         = @(0)
  softwareName           = 'Sandboxie *'
}

Install-ChocolateyPackage @packageArgs
