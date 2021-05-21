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
     $regex   = 'sublime_text_build_4\d+_x64_setup\.exe$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href

     $version_regex = '<h2>(?<version>[\d\.]+)\s*\(Build (?<build>4\d+)'
     $null = $download_page.Content -match $version_regex
     $version = $Matches.version
     $build = $Matches.build
     $segment_count = (Select-String -InputObject $version -Pattern '\.' -AllMatches).Matches.Count + 1
     for ($i = $segment_count; $i -lt 3; $i++) {
         $version += '.0'
     }
     $version += ".$($build)00"

     return @{ Version = $version; URL = $url }
}

update -ChecksumFor none