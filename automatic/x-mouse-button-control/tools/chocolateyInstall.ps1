$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
    packageName            = $env:ChocolateyPackageName
    fileType               = 'exe'
    url                    = 'https://dvps.highrez.co.uk/downloads/XMouseButtonControlSetup.2.18.8.exe'
    checksum               = '1aec34caf04815b936fa7d0e311e1f0a082d93e0074132f278a72413a646e4e2'
    checksumType           = 'sha256'
    silentArgs             = '/S'
    validExitCodes         = @(0)
    softwareName           = 'X-Mouse Button Control *'
}

Install-ChocolateyPackage @packageArgs
