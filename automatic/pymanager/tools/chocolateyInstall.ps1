$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. "$toolsPath/helpers.ps1"

$pp = Get-PackageParameters

$filePath = "$toolsPath\python-manager-25.0b3.msix"
$version  = '25.0.179'

if ([Environment]::OSVersion.Version.Major -ne '10') {
    throw 'This package requires Windows 10 or 11.'
}
if ([Environment]::OSVersion.Version.Build -lt '17763') {
    throw 'This package requires at least Windows 10 version 1809/OS build 17763.x.'
}

$processHasAdminRights = Test-ProcessAdminRights
$addGlobalShortcuts = $true
switch ($pp.GlobalShortcuts) {
    '' {
        if ($processHasAdminRights) {
            $pathType = [System.EnvironmentVariableTarget]::Machine
            Write-Host (
                'Admin rights available, will try to add global shortcuts to' +
                ' PATH in Machine Variables.'
            )
        } else {
            $pathType = [System.EnvironmentVariableTarget]::User
            Write-Host (
                'Admin rights available, will try to add global shortcuts to' +
                ' PATH in User Variables.'
            )
        }
    }
    'Machine' {
        $pathType = [System.EnvironmentVariableTarget]::Machine
    }
    'User' {
        $pathType = [System.EnvironmentVariableTarget]::User
    }
    'Disabled' {
        $addGlobalShortcuts = $false
    }
    default {
        throw (
            'Unknown value of /GlobalShortcuts parameter, supported options are:' +
            ' Machine, User, Disabled'
        )
    }
}

if ([Environment]::OSVersion.Version.Build -lt '18956') {
    # See https://github.com/Jackenmen/choco-auto/issues/13
    # Ref for the build number:
    # https://blogs.windows.com/windows-insider/2019/08/07/announcing-windows-10-insider-preview-build-18956/
    Write-Warning (
        'Windows builds before 18956 do not have sideloading enabled by default.' +
        ' The script will try to enable it automatically but this may fail,' +
        ' if admin rights ar not available.'
    )
    Set-AllowAllTrustedApps
}

Install-PyManager $filePath $version

if ($addGlobalShortcuts) {
    Add-GlobalShortcutsToPath $pathType
}

if ($pp.SkipMaxPathLimitationRemoval) {
    Write-Host (
        'NOT removing MAX_PATH limitation due to presence of' +
        ' /SkipMaxPathLimitationRemoval parameter.'
    )
} elseif ($processHasAdminRights) {
    Remove-MaxPathLimitation
} else {
    Write-Warning 'Could not remove MAX_PATH limitation due to lack of admin rights.'
}
