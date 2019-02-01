#Requires -Version 6

# check if newer version
$promptScript = Invoke-RestMethod https://gist.githubusercontent.com/SteveL-MSFT/a208d2bd924691bae7ec7904cab0bd8e/raw/64e1e1330b8dcf1fe7ad17a12b4ff520034a225d/profile.ps1
if ($promptScript.GetHashCode() -ne (Get-Content $profile -Raw).GetHashCode()) {
  $choice = Read-Host -Prompt "Found newer profile, install? (Y)"
  if ($choice -eq "Y" -or $choice -eq "") {
    Set-Content -Path $profile -Value $promptScript
    Write-Verbose "Installed newer version of profile"
    . $profile
    return
  }
}

function prompt {

  $lastSuccess = $?

  $color = @{
    Reset = "`e[0m"
    Red = "`e[31;1m"
    Green = "`e[32;1m"
    Yellow = "`e[33;1m"
    Grey = "`e[37m"
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
      $branch = git rev-parse --abbrev-ref --symbolic-full-name --% @{u}

      # handle case where branch is local
      if ($lastexitcode -ne 0) {
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
  $maxPath = 24
  if ($currentDirectory.Length -gt $maxPath) {
    $currentDirectory = "`u{2026}" + $currentDirectory.SubString($currentDirectory.Length - $maxPath)
  }

  "$($lastExit)PS$($color.Reset) $lastCmdTime$currentDirectory$gitBranch$('>' * ($nestedPromptLevel + 1)) "
}
