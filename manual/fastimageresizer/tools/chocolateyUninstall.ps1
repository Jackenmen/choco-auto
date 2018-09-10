$packageName = "fastimageresizer"
$installerType = "exe"

if (Test-Path "$env:ProgramFiles\Fast Image Resizer") {
    Uninstall-ChocolateyPackage $packageName $installerType "/S" "$env:ProgramFiles\Fast Image Resizer\uninstall.exe"
}

if (Test-Path "${env:ProgramFiles(x86)}\Fast Image Resizer") {
    Uninstall-ChocolateyPackage $packageName $installerType "/S" "${env:ProgramFiles(x86)}\Fast Image Resizer\uninstall.exe"
}