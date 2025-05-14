$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. "$toolsPath/helpers.ps1"

$processHasAdminRights = Test-ProcessAdminRights

Uninstall-PyManager $processHasAdminRights
