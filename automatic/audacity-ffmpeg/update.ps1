import-module au

$releases = 'https://lame.buanzo.org/'

$options =
@{
  Headers = @{
    Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
    Referer = 'https://lame.buanzo.org/';
  }
}

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
     $regex   = 'ffmpeg-win-.+\.exe$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
     $version = $url -split '-|.exe' | select -Last 1 -Skip 1
     return @{ Version = $version; URL = $url; Options = $options }
}

update