$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$softwareName = 'Sublime Text'

$packageArgs = @{
  packageName            = $packageName
  fileType               = 'exe'
  url                    = 'https://download.sublimetext.com/sublime_text_build_4153_x64_setup.exe'
  checksum               = '54578abf89c708e577f3fa642f3cc98b965c7c3fca0c48dc9ed49010b6801a48'
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes         = @(0)
}

Install-ChocolateyPackage @packageArgs

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    $sublInstallLocation = Join-Path -Path $_.InstallLocation -ChildPath 'subl.exe'
    Install-BinFile -Name 'subl' -Path $sublInstallLocation
  }
} elseif ($key.Count -eq 0) {
  Write-Error "$packageName installation failed, unable to detect uninstall registry key."
  Write-Warning "Please report this to the package maintainer."
} elseif ($key.Count -gt 1) {
  Write-Error "$packageName installation failed, multiple ($($key.Count)) uninstall registry keys found."
  Write-Warning "Please inform the package maintainer that the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName): $($_.InstallLocation)" }
}
