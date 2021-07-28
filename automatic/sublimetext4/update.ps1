import-module au

$downloadUrlFormat = 'https://download.sublimetext.com/sublime_text_build_{0}_x64_setup.exe'
$availableStreams = [ordered] @{
    stable = @{
        title           = 'Sublime Text 4'
        updatesEndpoint = 'https://www.sublimetext.com/updates/4/stable_update_check'
        versionFormat   = '4.0.0.{0}00'
    }
    dev = @{
        title           = 'Sublime Text 4'
        updatesEndpoint = 'https://www.sublimetext.com/updates/4/dev_update_check'
        versionFormat   = '4.0.0.{0}00-dev'
    }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"         = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(?i)(^\s*\<title\>).*(\<\/title\>)" = "`${1}$($Latest.Title)`${2}"
        }
    }
}

function global:au_BeforeUpdate {
    $Latest.Checksum = Get-RemoteChecksum $Latest.URL
}

function Get-Stream {
    param(
        [string]$updatesEndpoint,
        [string]$title,
        [string]$versionFormat
    )

    $releaseInformation = Invoke-RestMethod -Uri $updatesEndpoint
    $buildNumber = $releaseInformation.latest_version

    @{
        Title   = $title
        Version = $versionFormat -f $buildNumber
        URL     = $downloadUrlFormat -f $buildNumber
    }
}

function global:au_GetLatest {
    $streams = [ordered] @{}
    $errors = [ordered] @{}

    ForEach ($stream in $availableStreams.GetEnumerator()) {
        Try {
            $streamData = $stream.Value
            $streams[$stream.Name] = Get-Stream @streamData
        }
        Catch {
            $streams[$stream.Name] = 'ignore'
            $errors[$stream.Name] = $_
        }
    }

    if ($errors.Count) {
        Write-Error $errors
    }

    return @{ Streams = $streams }
}

update -ChecksumFor none
