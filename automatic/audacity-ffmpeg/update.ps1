import-module au

$domain = [Uri]'https://lame.buanzo.org'
$releases = [Uri]::new($domain, '/ffmpeg64audacity.php').AbsoluteUri

$user_agent = 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.15063; en-US) PowerShell/6.0.0'
$headers = @{
    Referer = $releases;
}

$options = @{
    Headers = @{
        Referer = $releases;
        'User-Agent' = $user_agent;
    }
}

function global:au_SearchReplace {
    @{
        ".\legal\VERIFICATION.txt" = @{
          "(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$releases>"
          "(?i)(\s*64\-Bit Software.*)\<.*\>" = "`${1}<$($Latest.Url64)>"
          "(?i)(^\s*checksum\s*type\:).*" = "`${1} $($Latest.ChecksumType64)"
          "(?i)(^\s*checksum64\:).*" = "`${1} $($Latest.Checksum64)"
          "(?i)(\s*the FFmpeg COMPRESSED PACKAGE.*)\<.*\>" = "`${1}<$($Latest.ZipUrl)>"
        }
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*file64\s*=\s*)('.*')" = "`$1'$($Latest.FileName64)'"
        }
    }
}

function global:au_BeforeUpdate {
    function name4url($url) {
        $res = $url -split '/' | Select-Object -Last 1
        $res -replace '\.[^.]+$'
    }

    New-Item -Type Directory tools -ea 0 | Out-Null
    $toolsPath = Resolve-Path tools

    Write-Host 'Purging' exe
    $purgePath = "$toolsPath{0}*.exe" -f [IO.Path]::DirectorySeparatorChar
    Remove-Item -Force $purgePath -ea ignore

    $base_name = name4url $Latest.Url64
    $file_name = "$base_name.exe"
    $file_path = Join-Path $toolsPath $file_name

    Invoke-WebRequest $Latest.Url64 -OutFile $file_path -UseBasicParsing -Headers $Headers
    $Latest.Checksum64 = Get-FileHash $file_path -Algorithm sha256 | ForEach-Object Hash
    $Latest.ChecksumType64 = 'sha256'
    $Latest.FileName64 = $file_name
}

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -Headers $headers -UserAgent $user_agent
     $regex = 'FFmpeg_v(\d+(?:\.\d+)*)_for_Audacity_on_Windows_64bit.exe$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
     $version = $Matches[1]
     $url = [Uri]::new($domain, $url).AbsoluteUri
     $zip_url = $url.SubString(0, $url.length - 3) + 'zip'

     return @{ Version = $version; Url64 = $url; ZipUrl = $zip_url; Options = $options }
}

update -ChecksumFor none -NoCheckUrl
