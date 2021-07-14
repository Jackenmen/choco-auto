import-module au

$updatesEndpoint = 'https://www.sublimetext.com/updates/4/stable_update_check'
$downloadUrlFormat = 'https://download.sublimetext.com/sublime_text_build_{0}_x64_setup.exe'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum)'"
        }
    }
}

function global:au_BeforeUpdate {
    $Latest.Checksum = Get-RemoteChecksum $Latest.URL
}

function global:au_GetLatest {
     $releaseInformation = Invoke-RestMethod -Uri $updatesEndpoint
     $buildNumber = $releaseInformation.latest_version
     $downloadUrl = $downloadUrlFormat -f $buildNumber

     return @{ Version = "4.0.0.$(buildNumber)00"; URL = $downloadUrl }
}

update -ChecksumFor none
