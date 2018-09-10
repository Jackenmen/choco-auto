$packageName = "audacity-ffmpeg"
$installerType = "exe"

if (Test-Path "$env:ProgramFiles\FFmpeg for Audacity") {
    Uninstall-ChocolateyPackage $packageName $installerType "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-" "$env:ProgramFiles\FFmpeg for Audacity\unins000.exe"
}

if (Test-Path "${env:ProgramFiles(x86)}\FFmpeg for Audacity") {
    Uninstall-ChocolateyPackage $packageName $installerType "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-" "${env:ProgramFiles(x86)}\FFmpeg for Audacity\unins000.exe"
}