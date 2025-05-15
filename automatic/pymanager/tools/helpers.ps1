$Script:appxPackageName = 'PythonSoftwareFoundation.PythonManager'
$Script:appxPublisherId = '3847v3x7pw1km'

function Install-PyManager {
    param(
        [string] $FilePath,
        [string] $Version,
        [switch] $Provision = $true
    )

    $foundAppxPackage = $null

    if ($Provision) {
        $appxPackages = Get-AppxProvisionedPackage -Online | Where-Object {
            $_.DisplayName -eq $Script:appxPackageName
        }
    } else {
        $appxPackages = Get-AppxPackage -Name $Script:appxPackageName
    }

    foreach ($appxPackage in $appxPackages) {
        if ($Provision) {
            $appxPackageName = $appxPackage.PackageName
        } else {
            $appxPackageName = $appxPackage.PackageFullName
        }
        if (!$appxPackageName.EndsWith("__$Script:appxPublisherId")) {
            if ($env:ChocolateyForce) {
                Write-Host (
                    "Removing already installed Python Install Manager from a different publisher" +
                    " (${appxPackageName}) first"
                )
                if ($Provision) {
                    Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $appxPackageName
                }
                Remove-AppxPackage -AllUsers:$Provision -Package $appxPackageName
                continue
            }
            throw (
                "The $Script:appxPackageName package from a different publisher is already provisioned:`n" +
                "${appxPackageName}`n" +
                "This may be a Store package or a development build.`n" +
                "This Chocolatey package uses MSIX from Python.org which cannot be provisioned" +
                " side-by-side with other variants."
            )
        }
        if ($foundAppxPackage -ne $null) {
            throw 'Unreachable error: found multiple packages from same publisher?'
        }
        $foundAppxPackage = $appxPackage
    }
    if ($Provision) {
        $appxPackages = Get-AppxPackage -Name $Script:appxPackageName
        foreach ($appxPackage in $appxPackages) {
            if (!$appxPackageName.EndsWith("__$Script:appxPublisherId")) {
                Write-Warning (
                    "Current user already has the $Script:appxPackageName installed" +
                    " from a different publisher. This may be a Store package" +
                    " or a development build. It is recommended to uninstall that variant" +
                    " to allow this package to receive updates."
                )
            }
        }
    }

    [version]$foundVersion = $foundAppxPackage.Version
    if ($foundAppxPackage -eq $null) {
        # pymanager isn't already installed
    } elseif ($env:ChocolateyForce) {
        # you can't install the same version of an appx package, you need to remove it first
        Write-Host (
            "Removing already installed version ($foundVersion)" +
            " of Python Install Manager first."
        )
        Uninstall-PyManager -IsProvisioned:$Provision
    } elseif ($foundVersion -gt [version]$Version) {
        Write-Warning (
            "The version of Python Install Manager in this Chocolatey package ($Version)" +
            " is older than the already installed version ($foundVersion)." +
            " The application may have auto-updated."
        )
        Write-Host 'MSIX installation will not be performed.'
        return
    } elseif ($foundVersion -Match [version]$Version) {
        if ($env:ChocolateyForce) {
            # you can't install the same version of an appx package, you need to remove it first
            Write-Host (
                "Removing already installed version ($foundVersion)" +
                " of Python Install Manager first."
            )
            Uninstall-PyManager -IsProvisioned:$Provision
        } else {
            Write-Host "Python Install Manager $Version is already installed."
            return
        }
    }

    if ($Provision) {
        Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath $FilePath
    } else {
        Add-AppxPackage $FilePath
    }
    Write-Host
}

function Uninstall-PyManager {
    param([switch]$IsProvisioned = $true)

    $provisionedAppxPackages = $null
    if ($IsProvisioned) {
        $provisionedAppxPackages = Get-AppxProvisionedPackage -Online | Where-Object {
            $_.DisplayName -eq $Script:appxPackageName -and $_.PackageName.EndsWith("__$Script:appxPublisherId")
        }
        $provisionedAppxPackages | Remove-AppxProvisionedPackage -Online -AllUsers
    } else {
        $appxPackages = Get-AppxPackage -Name $Script:appxPackageName | Where-Object {
            $_.PackageFullName.EndsWith("__$Script:appxPublisherId")
        }
        $appxPackages | Remove-AppxPackage
    }

    if ($provisionedAppxPackages -eq $null -and $appxPackages -eq $null) {
        Write-Warning "$Script:appxPackageName has already been uninstalled through other means."
        return
    }
}

function Add-GlobalShortcutsToPath {
    param([System.EnvironmentVariableTarget] $PathType)

    $pathEntry = '%USERPROFILE%\AppData\Local\Python\bin'
    $actualPath = Get-EnvironmentVariable -Name 'Path' -Scope $PathType -PreserveVariables

    if ($actualPath -eq $null) {
        throw "Could not get PATH from $PathType Variables."
    }

    if ($actualPath -Split ';' -Contains $pathEntry) {
        Write-Host "$pathEntry PATH entry is already part of $PathType Variables."
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
        -VariableName 'Path' -VariableValue $newPath -VariableType $PathType
    Write-Host "Added $pathEntry as PATH entry in $PathType Variables."
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
