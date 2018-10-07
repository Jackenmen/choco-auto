function CreateSilentSetupFile {
  param(
    $silentSetupFile,
    $installPath
  )

  $fileContent = @"
  [InstallShield Silent]
  Version=v7.00
  File=Response File
  [File Transfer]
  OverwrittenReadOnly=NoToAll
  [{2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-DlgOrder]
  Dlg0={2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdWelcome-0
  Count=5
  Dlg1={2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdLicense2-0
  Dlg2={2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdAskDestPath2-0
  Dlg3={2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdStartCopy2-0
  Dlg4={2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdFinish-0
  [{2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdWelcome-0]
  Result=1
  [{2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdLicense2-0]
  Result=1
  [{2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdAskDestPath2-0]
  szDir=$installPath
  Result=1
  [{2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdStartCopy2-0]
  Result=1
  [Application]
  Name=DDS Thumbnail Viewer
  Version=1.00.000
  Company=NVIDIA Corporation
  Lang=0009
  [{2205B8AE-490E-43F2-AB43-C13C2BEC86A7}-SdFinish-0]
  Result=1
  bOpt1=0
  bOpt2=0
"@

  $fileContent | Out-File $silentSetupFile
}
