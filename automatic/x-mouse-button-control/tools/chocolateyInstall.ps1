$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
    packageName            = $env:ChocolateyPackageName
    fileType               = 'exe'
    url                    = 'https://dvps.highrez.co.uk/downloads/XMouseButtonControlSetup.2.20.1.exe'
    checksum               = '9cd3c24ed6a764c40f591072ba6fd9d1e6c0ff2b707bdce9ea03ad6d5d56546e'
    checksumType           = 'sha256'
    silentArgs             = '/S'
    validExitCodes         = @(0)
    softwareName           = 'X-Mouse Button Control *'
}

Install-ChocolateyPackage @packageArgs
