import-module au

$metadata = Get-Content -Raw "metadata.json" | ConvertFrom-Json

function global:au_SearchReplace {
    @{
        ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s*Click on.*)\`".*`"" = "`${1}`"$($Latest.FileName64)`""
          "(?i)(\s*the following software.*)\<.*\>" = "`${1}<$($Latest.Url64)>"
          "(?i)(^\s*checksum\s*type\:).*" = "`${1} $($Latest.ChecksumType64)"
          "(?i)(^\s*checksum64\:).*" = "`${1} $($Latest.Checksum64)"
          "(?i)(\s*the FFmpeg installer.*)\<.*\>" = "`${1}<$($Latest.Url64)>"
        }
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*file64\s*=\s*`"[$]toolsPath\\).*" = "`${1}$($Latest.FileName64)`""
        }
        "$($Latest.PackageName).nuspec" = @{
            "(<file src=`"tools\\)[^ ]+\.exe(`" target=`"tools\\)[^ ]+\.exe(`" />)" = "`$1$($Latest.FileName64)`$2$($Latest.FileName64)`$3"
        }
    }
}

function global:au_BeforeUpdate {
    function name4url($url) {
        $res = $url -split '/' | Select-Object -Last 1
        $res -replace '\.[^.]+$'
    }

    $toolsPath = Resolve-Path tools

    $base_name = name4url $Latest.Url64
    $file_name = "$base_name.exe"
    $file_path = Join-Path $toolsPath $file_name

    $Latest.Checksum64 = Get-FileHash $file_path -Algorithm sha256 | ForEach-Object Hash
    $Latest.ChecksumType64 = 'sha256'
    $Latest.FileName64 = $file_name
}

function global:au_GetLatest {
     $version = $metadata.version;
     $url = $metadata.url;

     return @{ Version = $version; Url64 = $url }
}

update -ChecksumFor none -NoCheckUrl
