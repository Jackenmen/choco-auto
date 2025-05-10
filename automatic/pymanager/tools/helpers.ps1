function Set-AllowAllTrustedApps {
    # NOTE: This does not affect the "Allow all trusted apps to install" group policy
    # and the package will properly fail to install, if that policy is configured to
    # "Disabled" setting. We don't want to alter administrator's explicit decision,
    # just the default behavior seen in earlier builds.
    $registryEntry = @{
        Path         = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
        Name         = 'AllowAllTrustedApps'
        Value        = 1
        PropertyType = 'DWORD'
        Force        = $true
    }
    New-ItemProperty @registryEntry | Out-Null
    Write-Host 'Applied app sideloading behavior as seen in build 18956 and above.'
}

function Install-PyManager {
    param(
        [string] $filePath,
        [string] $version
    )

    $appxPackageName = 'PythonSoftwareFoundation.PythonManager'
    $appxPackage = Get-AppxPackage -Name $appxPackageName | Select-Object -Last 1
    [version]$foundVersion = $appxPackage.Version

    if ($appxPackage -eq $null) {
        # pymanager isn't already installed
    } elseif ($env:ChocolateyForce) {
        # you can't install the same version of an appx package, you need to remove it first
        Write-Host (
            "Removing already installed version (${appxPackage.Version})" +
            " of Python Install Manager first."
        )
        Remove-AppxPackage $appxPackage
    } elseif ($appxPackage.Version -gt [version]$version) {
        Write-Warning (
            "The version of Python Install Manager in this Chocolatey package ($version)" +
            " is older than the already installed version (${appxPackage.Version})." +
            " The application may have auto-updated."
        )
    } elseif ($appxPackage.Version -Match [version]$version) {
        if ($env:ChocolateyForce) {
            # you can't install the same version of an appx package, you need to remove it first
            Write-Host (
                "Removing already installed version (${appxPackage.Version})" +
                " of Python Install Manager first."
            )
            Remove-AppxPackage $appxPackage
        } else {
            Write-Host "Python Install Manager $version is already installed."
            return
        }
    }

    Add-AppxPackage $filePath
    Write-Host
}

function Add-GlobalShortcutsToPath {
    param([System.EnvironmentVariableTarget] $pathType)

    $pathEntry = '%USERPROFILE%\AppData\Local\Python\bin'
    $actualPath = Get-EnvironmentVariable -Name 'Path' -Scope $pathType -PreserveVariables

    if ($actualPath -eq $null) {
        throw "Could not get PATH from $pathType Variables."
    }

    if ($actualPath -Split ';' -Contains $pathEntry) {
        Write-Host "$pathEntry PATH entry is already part of $pathType Variables."
        return
    }
    $pathToInstall = $pathEntry
    if (!$actualPath.StartsWith(';')) {
        $pathToInstall = "$pathToInstall;"
    }
    $newPath = $pathToInstall + $actualPath
    if (!$newPath.EndsWith(';')) {
        $newPath = "$newPath;"
    }
    Install-ChocolateyEnvironmentVariable `
        -VariableName 'Path' -VariableValue $newPath -VariableType $pathType
    Write-Host "Added $pathEntry as PATH entry in $pathType Variables."
}

function Remove-MaxPathLimitation {
    $registryEntry = @{
        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem'
        Name         = 'LongPathsEnabled'
        Value        = 1
        PropertyType = 'DWORD'
        Force        = $true
    }
    New-ItemProperty @registryEntry | Out-Null
    Write-Host 'Removed the MAX_PATH limitation'
}
