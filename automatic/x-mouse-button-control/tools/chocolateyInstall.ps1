$ErrorActionPreference = 'Stop'
 
$packageArgs = @{
    packageName            = $env:ChocolateyPackageName
    fileType               = 'exe'
    url                    = 'https://dvps.highrez.co.uk/downloads/XMouseButtonControlSetup.2.18.7.exe'
    checksum               = 'f64883d27153465dced0e08049b5b7666901ca158bf9103443279c352848bcc3'
    checksumType           = 'sha256'
    silentArgs             = '/S'
    validExitCodes         = @(0)
    softwareName           = 'X-Mouse Button Control *'
}

Install-ChocolateyPackage @packageArgs
