import-module au

$releases = 'https://www.python.org/ftp/python/pymanager/pymanager-preview.appinstaller'

function global:au_SearchReplace {
    @{
        ".\legal\VERIFICATION.txt"      = @{
          "(?i)(^\s*location at\:?\s*)\<.*\>" = "`${1}<$releases>"
          "(?i)(\s*64\-Bit Software.*)\<.*\>" = "`${1}<$($Latest.URL64)>"
          "(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType64)"
          "(?i)(^\s*checksum64\:).*"          = "`${1} $($Latest.Checksum64)"
        }
        ".\tools\chocolateyInstall.ps1" = @{
          "(^[$]filePath\s*=\s*`"[$]toolsPath\\).*" = "`${1}$($Latest.FileName64)`""
          "(^[$]appxVersion\s*=\s*)('.*')"          = "`${1}'$($Latest.AppxVersion)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(\<description\>The Python Install Manager )[^ ]+ " = "`${1}$($Latest.FriendlyVersion) "
        }
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    $releaseData = Invoke-RestMethod $releases
    $url = $releaseData.AppInstaller.MainPackage.Uri

    $filename = ([System.Uri]$url).Segments[-1]
    $re = '^python-manager-(?<version>\d+\..+).msix$'
    if (!($filename -match $re)) {
        throw "Can't find version number"
    }
    $friendlyVersion = $matches['version']
    $parsedFriendlyVersion = Get-Version $friendlyVersion

    $appxVersion = $releaseData.AppInstaller.MainPackage.Version
    $version = $appxVersion

    while ($version.EndsWith('.0')) {
        $version = $version.Substring(0, $version.Length - 2)
    }

    $dot_count = ($version.Length - $version.replace('.', '').Length)
    if ($dot_count -eq 3) {
        $version += '00'
    }
    if ($parsedFriendlyVersion.Prerelease) {
        $version += "-$($parsedFriendlyVersion.Prerelease)"
    }

    @{
      URL64           = $url
      AppxVersion     = $appxVersion
      FriendlyVersion = $friendlyVersion
      Version         = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}
