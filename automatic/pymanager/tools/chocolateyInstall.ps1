$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. "$toolsPath/helpers.ps1"

$pp = Get-PackageParameters

$filePath    = "$toolsPath\python-manager-25.1.msix"
$appxVersion = '25.1.240.0'

if ([Environment]::OSVersion.Version.Major -ne '10') {
    throw 'This package requires Windows 10 22H2 or above / Windows Server 2022.'
}
if ([Environment]::OSVersion.Version.Build -lt '19044') {
    throw 'This package requires at least Windows 10 version 22H2/OS build 19044.x.'
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

Install-PyManager -FilePath $filePath -Version $appxVersion -Provision:$processHasAdminRights

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
