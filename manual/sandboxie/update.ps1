import-module au

#Virtual package uses dependency updater to get the version
. $PSScriptRoot\..\sandboxie.install\update.ps1

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
            "(?i)(^\s*\<title\>).*(\<\/title\>)" = "`${1}$($Latest.Title)`${2}"
        }
    }
}

# Left empty intentionally to override BeforeUpdate in sandboxie.install
function global:au_BeforeUpdate { }

update -ChecksumFor none