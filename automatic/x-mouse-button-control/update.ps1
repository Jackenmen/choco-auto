import-module au

$protocol = "https"
$latest_release_url = "${protocol}://www.highrez.co.uk/scripts/download.asp?package=XMouse"


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
    $request = [System.Net.WebRequest]::Create($latest_release_url)
    $request.AllowAutoRedirect = $false
    $response = $request.GetResponse()
    if ($response.StatusCode -ge 500) {
        return "ignore"
    }
    if ($response.StatusCode -ne 302) {
        throw "The url $latest_release_url wasn't a redirect."
    }
    $url = $response.GetResponseHeader("Location")
    if ($url.StartsWith("//")) {
        $url = "${protocol}:" + $url
    }
    $version = $url -split 'XMouseButtonControlSetup.|.exe' | select -Last 1 -Skip 1
    return @{ Version = $version; URL = $url; Options = $options }
}

update -ChecksumFor none