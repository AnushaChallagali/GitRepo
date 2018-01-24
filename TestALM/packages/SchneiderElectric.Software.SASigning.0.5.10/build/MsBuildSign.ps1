Param([string]$certificate, [string]$modifiedFilesRaw, [bool]$force = $false)

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$scriptName = $MyInvocation.MyCommand.Name
$filesToSign = ".*\.dll$|.*\.exe$|.*\.msi$|.*\.ocx$|.*\.cab$|.*\.msm$" #regular expressions for matching the files

$modifiedFiles = $modifiedFilesRaw.Split(";");
 foreach ($modifiedFile in $modifiedFiles)
 {
	if( $force -or ($modifiedFile -match $filesToSign))
	 {	   	   
		$signState = Get-AuthenticodeSignature -filePath $modifiedFile

        if($signState.Status -ne "Valid" )
        {
            Write-Host "Signing $modifiedFile"
            $certificateFullPath = "C:\\SASigning\\" + $certificate
            & C:\SASigning\SASigning.exe /config "$certificateFullPath"  /tosign ([IO.Path]::GetFullPath( "$modifiedFile" ))
        }
        else
        {
            Write-Host "File $modifiedFile already signed with" $signState.SignerCertificate.Thumbprint
        }
	 }
	 else
	 {
	       Write-Host "File $modifiedFile excluded from signing"
	 }
 }