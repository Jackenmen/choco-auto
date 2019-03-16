import-module au
. "$PSScriptRoot\update_helper.ps1"

$url = 'https://dl.google.com/dl/edgedl/chrome-remote-desktop/chromeremotedesktophost.msi'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1"       = @{
            "(^[$]version\s*=\s*)('.*')"      = "`$1'$($Latest.RemoteVersion)'"
            "(?i)(^\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }
    }
}

function global:au_GetLatest {
    $setup_path = "$PSScriptRoot\chromeremotedesktophost.msi"

    Invoke-WebRequest -Uri $url -OutFile $setup_path
    $version = Get-MsiDatabaseVersion $setup_path
    $checksum = Get-FileHash $setup_path | % Hash
    Remove-Item $setup_path -ea 0
    return @{
        Version = $version
        RemoteVersion = $version
        URL = $url
        Checksum = $checksum.ToLower()
    }
}

update -ChecksumFor none