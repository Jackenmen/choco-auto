import-module au

$releases = 'https://www.sublimetext.com/download'

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
     $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
     $regex   = 'sublime_text_build_(4\d+)_x64_setup\.exe$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
     $version = $Matches[1]
     return @{ Version = $version; URL = $url }
}

update -ChecksumFor none