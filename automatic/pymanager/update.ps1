import-module au

$releases = 'https://www.python.org/ftp/python/pymanager/pymanager.appinstaller'

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
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    $releaseData = Invoke-RestMethod $releases
    $url = $releaseData.AppInstaller.MainPackage.Uri
    $filename = ([System.Uri]$url).Segments[-1]
    $appxVersion = $releaseData.AppInstaller.MainPackage.Version

    $re = '^python-manager-(?<version>\d+\..+).msix$'
    if (!($filename -match $re)) {
        throw "Can't find version number"
    }
    $version = Get-Version $matches['version']

    @{
      URL64       = $url
      AppxVersion = $appxVersion
      Version     = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}
