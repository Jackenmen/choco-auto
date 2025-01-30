import-module au

$domain = [Uri]'https://lame.buanzo.org'
$releases = [Uri]::new($domain, '/ffmpeg.php').AbsoluteUri

$user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36';
$headers = @{
    "Accept" = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7';
    "Accept-Encoding" = 'gzip, deflate, br, zstd';
    "Accept-Language" = 'en-GB,en-US;q=0.9,en;q=0.8';
    "Host" = 'lame.buanzo.org';
    "sec-ch-ua" = '"Not A(Brand";v="8", "Chromium";v="132", "Google Chrome";v="132"';
    "sec-ch-ua-mobile" = '?0';
    "sec-ch-ua-platform" = '"Windows"';
    "Sec-Fetch-Dest" = 'document';
    "Sec-Fetch-Mode" = 'navigate';
    "Sec-Fetch-Site" = 'none';
    "Sec-Fetch-User" = '?1';
    "Upgrade-Insecure-Requests" = '1';
    "User-Agent" = $user_agent;
}
$headers_with_referer = $base_headers + @{Referer = $releases};

$options = @{
    Headers = $headers_with_referer;
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
            "(?i)(^\s*file64\s*=\s*`"[$]toolsPath\\).*" = "`${1}$($Latest.FileName64)`""
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

    Invoke-WebRequest $Latest.Url64 -OutFile $file_path -UseBasicParsing -Headers $headers_with_referer -UserAgent $user_agent
    $Latest.Checksum64 = Get-FileHash $file_path -Algorithm sha256 | ForEach-Object Hash
    $Latest.ChecksumType64 = 'sha256'
    $Latest.FileName64 = $file_name
}

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -Headers $headers -UserAgent $user_agent
     $regex = 'FFmpeg_(\d+(?:\.\d+)*)_for_Audacity_on_Windows_x86_64\.exe$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
     $version = $Matches[1]
     $url = [Uri]::new($domain, $url).AbsoluteUri
     $zip_url = $url.SubString(0, $url.length - 3) + 'zip'

     return @{ Version = $version; Url64 = $url; ZipUrl = $zip_url; Options = $options }
}

update -ChecksumFor none -NoCheckUrl
