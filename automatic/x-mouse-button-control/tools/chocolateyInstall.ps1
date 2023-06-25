$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
    packageName            = $env:ChocolateyPackageName
    fileType               = 'exe'
    url                    = 'https://dvps.highrez.co.uk/downloads/XMouseButtonControlSetup.2.20.5.exe'
    checksum               = '2240bf5fb5d80938b0676c46ef9f84bc1739c32f60c473ff85e530ae0eca2818'
    checksumType           = 'sha256'
    silentArgs             = '/S'
    validExitCodes         = @(0)
    softwareName           = 'X-Mouse Button Control *'
}

Install-ChocolateyPackage @packageArgs
