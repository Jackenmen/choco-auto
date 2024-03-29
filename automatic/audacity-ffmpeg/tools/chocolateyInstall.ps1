﻿$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition
 
$packageArgs = @{
  packageName            = 'audacity-ffmpeg'
  fileType               = 'exe'
  file64                 = "$toolsPath\FFmpeg_v2.2.2_for_Audacity_on_Windows_64bit.exe"
  silentArgs             = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes         = @(0)
  softwareName           = 'FFmpeg (Windows) for Audacity *'
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsPath\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" '' } }
