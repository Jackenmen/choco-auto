import-module au

$domain_stable   = 'https://www.sandboxie.com'
$releases_stable = "$domain_stable/AllVersions"
$domain_beta     = 'https://forums.sandboxie.com/phpBB3'
$releases_beta   = "$domain_beta/viewforum.php?f=43"

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(?i)(^\s*\<title\>).*(\<\/title\>)" = "`${1}$($Latest.Title) (Install) `${2}"
        }
    }
}

function global:au_BeforeUpdate {
    $Latest.Checksum = Get-RemoteChecksum $Latest.URL -Headers $headers
}

function Get-Stable {
    param(
        [string]$domain,
        [string]$releases,
        [string]$title
    )

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regex   = 'SandboxieInstall-.+\.exe$'
    $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
    $url     = $domain + '/' + $url
    $version = [array]($url -split '-|.exe' | select -First 4 -Skip 1 | select -SkipLast 1)
    $version[0] = $version[0].Substring(0, 1) + '.' + $version[0].Substring(1)
    $version = $version -join '.'

    @{ 
        Title = $title
        Version = $version
        URL = $url
    }
}

function Get-Beta {
    param(
        [string]$domain,
        [string]$releases,
        [string]$title
    )

    # Forum with different beta version links
    $download_page = Invoke-WebRequest -Uri $releases
    $releases      = $download_page.links | Where class -eq 'forumtitle' | Where innerText -like 'Beta Version *' | select -first 1 -expand href
    $releases      = $domain + '/' + $releases.replace('&amp;', '&')

    # Forum for specific beta version
    $download_page = Invoke-WebRequest -Uri $releases
    $releases      = $download_page.links | Where class -eq 'topictitle' | Where innerText -like '* Beta Available*' | select -first 1 -expand href
    $releases      = $domain + '/' + $releases.replace('&amp;', '&')

    # Thread with specific beta version
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regex   = 'SandboxieInstall-.+\.exe$'
    $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
    if (!$url) {
        Write-Host "No links in beta thread on $releases"
        return 'ignore'
    }
    $version = [array]($url -split '-|.exe' | select -First 4 -Skip 1 | select -SkipLast 1)
    $version[0] = $version[0].Substring(0, 1) + '.' + $version[0].Substring(1)
    $version = $version -join '.'

    @{
        Title = $title
        Version = $version + '-beta'
        URL = $url
    }
}

function global:au_GetLatest {
    $streams = [ordered] @{
        stable = Get-Stable -domain $domain_stable -releases $releases_stable -title "Sandboxie"
        beta = Get-Beta -domain $domain_beta -releases $releases_beta -title "Sandboxie Beta"
    }

    return @{ Streams = $streams }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}