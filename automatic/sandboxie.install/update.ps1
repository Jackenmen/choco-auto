import-module au

$domain   = 'https://www.sandboxie.com'
$releases = "$domain/AllVersions"

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum)'"
        }
    }
}

function global:au_BeforeUpdate {
    $Latest.Checksum = Get-RemoteChecksum $Latest.URL -Headers $headers
}

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
     $regex   = 'SandboxieInstall-.+\.exe$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
     $url     = $domain + '/' + $url
     Write-Warning $url
     $version = $url -split '-|.exe' | select -Last 1 -Skip 1
     $version = $version.Substring(0, 1) + '.' + $version.Substring(1)
     return @{ Version = $version; URL = $url }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}