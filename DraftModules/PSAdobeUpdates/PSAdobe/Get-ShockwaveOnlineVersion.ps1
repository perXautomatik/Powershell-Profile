Function Get-ShockwaveOnlineVersion 
{
	<#	
		.SYNOPSIS
			Get-ShockwaveOnlineVersion retrieves the most current version of Shockwave from the web.
		
		.DESCRIPTION
			Get-ShockwaveOnlineVersion retrieves the most current version of Shockwave from the web. Uses Invoke-WebRequest, so requires PowerShell 3 or greater.
		
		.PARAMETER Uri
			The website to gather information about shockwave from. Defaults to adobe's webpage help for shockwave

		.EXAMPLE
			Get-ShockwaveOnlineVersion
			
			Returns the current version of Shockwave from Adobe's website
			
		.NOTES
			Reiles on website information and parsing that information, so it will likely break in the future.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,ValueFromPipelinebyPropertyName=$true)]
		[alias("Url")]
		[string]$Uri = "https://helpx.adobe.com/shockwave.html"
	)
	Begin{}
	Process 
	{
		$Shockwave = Invoke-WebRequest -Uri $Uri
 		$ShockWaveVersionPage = "https://helpx.adobe.com" + ($Shockwave.Links | Where {$_.outerText -like "Release Notes*"}).href
        $ShockWaveVersion = Invoke-WebRequest -Uri $ShockWaveVersionPage
        $regex = "Shockwave Player.*"
        $ShockWaveVersions = [regex]::matches($ShockWaveVersion, $regex, "IgnoreCase")
		$CurrentVersionUgly = ($ShockwaveVersions | Where {$_.Value -match "\d+" -and $_.Value -like "Shockwave Player*" -and $_.Value -notlike "Shockwave Player 11*"} | Sort Index)[0]
		$ShockWaveCurrentVersion = (($CurrentVersionUgly -split '&nbsp;')[1]).replace('<br />',"")
		New-Object -TypeName PSOBject -Property @{ShockWavePlayerVersion=$ShockWaveCurrentVersion}
	}
	End{}
}