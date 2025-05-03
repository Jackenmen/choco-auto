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
          "(^[$]version\s*=\s*)('.*')"              = "`${1}'$($Latest.RemoteVersion)'"
        }
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    $releaseData = Invoke-RestMethod $releases
    $url = $releaseData.AppInstaller.MainPackage.Uri
    $remoteVersion = $releaseData.AppInstaller.MainPackage.Version
    $version = $remoteVersion

    while ($version.EndsWith('.0')) {
        $version = $version.Substring(0, $version.Length - 2)
    }

    $dot_count = ($version.Length - $version.replace('.', '').Length)
    if ($dot_count -eq 3) {
        $version += '00'
    }

    @{
      URL64         = $url
      RemoteVersion = $remoteVersion
      Version       = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}
