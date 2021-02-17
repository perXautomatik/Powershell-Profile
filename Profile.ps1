#Requires -Version 7

# Version 1.2.6

# check if newer version
$gistUrl = "https://api.github.com/gists/a208d2bd924691bae7ec7904cab0bd8e"
$latestVersionFile = Join-Path -Path ~ -ChildPath ".latest_profile_version"
$versionRegEx = "# Version (?<version>\d+\.\d+\.\d+)"

if (Test-Path $latestVersionFile) {
  $latestVersion = Get-Content $latestVersionFile
  $currentProfile = Get-Content $profile -Raw
  [version]$currentVersion = "0.0.0"
  if ($currentProfile -match $versionRegEx) {
    $currentVersion = $matches.Version
  }

  if ($latestVersion -gt $currentVersion) {
    Write-Verbose "Your version: $currentVersion" -Verbose
    Write-Verbose "New version: $latestVersion" -Verbose
    $choice = Read-Host -Prompt "Found newer profile, install? (Y)"
    if ($choice -eq "Y" -or $choice -eq "") {
      try {
        $gist = Invoke-RestMethod $gistUrl -ErrorAction Stop
        $gistProfile = $gist.Files."profile.ps1".Content
        Set-Content -Path $profile -Value $gistProfile
        Write-Verbose "Installed newer version of profile" -Verbose
        . $profile
        return
      }
      catch {
        # we can hit rate limit issue with GitHub since we're using anonymous
        Write-Verbose -Verbose "Was not able to access gist, try again next time"
      }
    }
  }
}

$null = Start-ThreadJob -Name "Get version of `$profile from gist" -ArgumentList $gistUrl, $latestVersionFile, $versionRegEx -ScriptBlock {
  param ($gistUrl, $latestVersionFile, $versionRegEx)

  try {
    $gist = Invoke-RestMethod $gistUrl -ErrorAction Stop

    $gistProfile = $gist.Files."profile.ps1".Content
    [version]$gistVersion = "0.0.0"
    if ($gistProfile -match $versionRegEx) {
      $gistVersion = $matches.Version
      Set-Content -Path $latestVersionFile -Value $gistVersion
    }
  }
  catch {
    # we can hit rate limit issue with GitHub since we're using anonymous
    Write-Verbose -Verbose "Was not able to access gist to check for newer version"
  }
}

# add path to dotnet global tools
$env:PATH += [System.IO.Path]::PathSeparator + (Join-Path (Resolve-Path ~) ".dotnet" "tools")

if ($IsWindows) {
  Set-PSReadLineOption -EditMode Emacs -ShowToolTips
  Set-PSReadLineKeyHandler -Chord Ctrl+Shift+c -Function Copy
  Set-PSReadLineKeyHandler -Chord Ctrl+Shift+v -Function Paste
}
else {
  if ($null -eq (Get-Module Microsoft.PowerShell.UnixCompleters -listavailable)) {
    Install-Module Microsoft.PowerShell.UnixCompleters -Repository PSGallery -AcceptLicense -Force
  }

  Import-Module Microsoft.PowerShell.UnixCompleters
}

if ((Get-Module PSReadLine).Version -lt 2.2) {
  throw "Profile requires PSReadLine 2.2+"
}

Set-PSReadLineOption -Colors @{ Selection = "`e[92;7m"; InLinePrediction = "`e[36;7;238m" } -PredictionSource History
Set-PSReadLineKeyHandler -Chord Shift+Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord

# ensure dotnet cli is in path
$dotnet = Get-Command dotnet -CommandType Application -ErrorAction Ignore
if ($null -eq $dotnet) {
  if (Test-Path ~/.dotnet/dotnet) {
    $env:PATH += [System.IO.Path]::PathSeparator + (Join-Path (Resolve-Path ~) ".dotnet")
  }
}

# setup psdrives
if ((Test-Path (Join-Path -Path ~ -ChildPath 'test')) -and (!(Test-Path test:))) {
  New-PSDrive -Root ~/test -Name Test -PSProvider FileSystem > $Null
}

if (!(Test-Path repos:)) {
  if (Test-Path (Join-Path -Path ~ -ChildPath 'git')) {
    New-PSDrive -Root ~/repos -Name git -PSProvider FileSystem > $Null
  }
  elseif (Test-Path "d:\PowerShell") {
    New-PSDrive -Root D:\ -Name git -PSProvider FileSystem > $Null
  }
}

function prompt {

  $currentLastExitCode = $LASTEXITCODE
  $lastSuccess = $?

  $color = @{
    Reset = "`e[0m"
    Red = "`e[31;1m"
    Green = "`e[32;1m"
    Yellow = "`e[33;1m"
    Grey = "`e[37;0m"
    White = "`e[37;1m"
    Invert = "`e[7m"
    RedBackground = "`e[41m"
  }

  # set color of PS based on success of last execution
  if ($lastSuccess -eq $false) {
    $lastExit = $color.Red
  } else {
    $lastExit = $color.Green
  }


  # get the execution time of the last command
  $lastCmdTime = ""
  $lastCmd = Get-History -Count 1
  if ($null -ne $lastCmd) {
    $cmdTime = $lastCmd.Duration.TotalMilliseconds
    $units = "ms"
    $timeColor = $color.Green
    if ($cmdTime -gt 250 -and $cmdTime -lt 1000) {
      $timeColor = $color.Yellow
    } elseif ($cmdTime -ge 1000) {
      $timeColor = $color.Red
      $units = "s"
      $cmdTime = $lastCmd.Duration.TotalSeconds
      if ($cmdTime -ge 60) {
        $units = "m"
        $cmdTIme = $lastCmd.Duration.TotalMinutes
      }
    }

    $lastCmdTime = "$($color.Grey)[$timeColor$($cmdTime.ToString("#.##"))$units$($color.Grey)]$($color.Reset) "
  }

  # get git branch information if in a git folder or subfolder
  $gitBranch = ""
  $path = Get-Location
  while ($path -ne "") {
    if (Test-Path (Join-Path $path .git)) {
      # need to do this so the stderr doesn't show up in $error
      $ErrorActionPreferenceOld = $ErrorActionPreference
      $ErrorActionPreference = 'Ignore'
      $branch = git rev-parse --abbrev-ref --symbolic-full-name '@{u}'
      $ErrorActionPreference = $ErrorActionPreferenceOld

      # handle case where branch is local
      if ($lastexitcode -ne 0 -or $null -eq $branch) {
        $branch = git rev-parse --abbrev-ref HEAD
      }

      $branchColor = $color.Green

      if ($branch -match "/master") {
        $branchColor = $color.Red
      }
      $gitBranch = " $($color.Grey)[$branchColor$branch$($color.Grey)]$($color.Reset)"
      break
    }

    $path = Split-Path -Path $path -Parent
  }

  # truncate the current location if too long
  $currentDirectory = $executionContext.SessionState.Path.CurrentLocation.Path
  $consoleWidth = [Console]::WindowWidth
  $maxPath = [int]($consoleWidth / 2)
  if ($currentDirectory.Length -gt $maxPath) {
    $currentDirectory = "`u{2026}" + $currentDirectory.SubString($currentDirectory.Length - $maxPath)
  }

  # check if running dev built pwsh
  $devBuild = ''
  if ($PSHOME.Contains("publish")) {
    $devBuild = " $($color.White)$($color.RedBackground)DevPwsh$($color.Reset)"
  }

  "${lastCmdTime}${currentDirectory}${gitBranch}${devBuild}`n${lastExit}PS$($color.Reset)$('>' * ($nestedPromptLevel + 1)) "

  # set window title
  try {
    $prefix = ''
    if ($isWindows) {
      $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
      $windowsPrincipal = [Security.Principal.WindowsPrincipal]::new($identity)
      if ($windowsPrincipal.IsInRole("Administrators") -eq 1) {
        $prefix = "Admin:"
      }
    }

    $Host.ui.RawUI.WindowTitle = "$prefix$PWD"
  } catch {
    # do nothing if can't be set
  }

  $global:LASTEXITCODE = $currentLastExitCode
}
