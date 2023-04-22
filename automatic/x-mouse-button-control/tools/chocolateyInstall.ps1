$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
    packageName            = $env:ChocolateyPackageName
    fileType               = 'exe'
    url                    = 'https://dvps.highrez.co.uk/downloads/XMouseButtonControlSetup.2.20.3.exe'
    checksum               = 'f4707a78b51cbb82504db6cc2b3627d33a66beee7ea20d77472ae7e03d55ec39'
    checksumType           = 'sha256'
    silentArgs             = '/S'
    validExitCodes         = @(0)
    softwareName           = 'X-Mouse Button Control *'
}

Install-ChocolateyPackage @packageArgs
