import-module au

$releases = 'https://api.github.com/repos/sandboxie-plus/Sandboxie/releases/latest'

function global:au_SearchReplace {
    @{
        ".\legal\VERIFICATION.txt"      = @{
          "(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$releases>"
          "(?i)(\s*64\-Bit Software.*)\<.*\>" = "`${1}<$($Latest.URL64)>"
          "(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType64)"
          "(?i)(^\s*checksum64\:).*"          = "`${1} $($Latest.Checksum64)"
        }
        ".\tools\chocolateyInstall.ps1" = @{
          "(?i)(^\s*file64\s*=\s*`"[$]toolsPath\\).*" = "`${1}$($Latest.FileName64)`""
        }
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    $release_data = Invoke-RestMethod $releases

    $re = 'Release\sv(?<plus>\d+(?:\.\d+)+(?<plus_letter>[a-z]?))\s+\/\s+(?<classic>\d+(?:\.\d+)+)\s*'
    if (!($release_data.name -match $re)) {
        throw "Can't find version numbers"
    }
    $version = $matches['classic']
    $dot_count = ($version.Length - $version.replace('.', '').Length)
    if ($dot_count -eq 3) {
        $version += '00'
    } elseif ($dot_count -gt 3) {
        throw 'Version number has too many segments'
    }

    $url = ''

    foreach ($asset in $release_data.assets) {
        $re = 'Sandboxie-Classic-x64.*\.exe'
        if ($asset.name -match $re) {
            $url = $asset.browser_download_url
        }
    }

    foreach ($url_data in $urls.GetEnumerator()) {
        if (!$url_data.Value) {
            throw "Can't find URL for Sandboxie Classic"
        }
    }

    @{
      URL64        = $url
      Version      = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}