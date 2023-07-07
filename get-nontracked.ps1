﻿# Define a function that takes a list of paths as input
function Get-NonTrackedPaths {
  param (
    [Parameter(Mandatory=$true)]
    [string[]]$Paths
  )

  # Initialize an empty array to store the non-tracked paths
  $NonTrackedPaths = @()

  # Loop through each path in the input list
  foreach ($Path in $Paths) {

    # Check if the path is a valid directory
    if (Test-Path -Path $Path -PathType Container) {

      # Check if the path contains a .git folder
      if (Test-Path -Path "$Path\.git") {

        # Assume the path is not tracked by any other path
        $IsTracked = $false

        # Loop through the other paths in the input list
        foreach ($OtherPath in $Paths) {

          # Skip the current path
          if ($OtherPath -ne $Path) {

            # Check if the other path is a valid directory
            if (Test-Path -Path $OtherPath -PathType Container) {

              # Check if the other path contains a .git folder
              if (Test-Path -Path "$OtherPath\.git") {

                # Change the current location to the other path
                Push-Location -Path $OtherPath

                # Invoke git status command and capture the output
                $GitStatus = git status --porcelain --untracked-files=no

                # Restore the original location
                Pop-Location

                # Check if the output contains the current path as a normal part of repository or as a submodule
                if ($GitStatus -match [regex]::Escape($Path)) {

                  # Set the flag to indicate the current path is tracked by the other path
                  $IsTracked = $true

                  # Break the inner loop
                  break

                }

              }

            }

          }

        }

        # If the flag is still false, add the current path to the non-tracked paths array
        if (-not $IsTracked) {
          $NonTrackedPaths += $Path
        }

      }

    }

  }

  # Return the non-tracked paths array
  return $NonTrackedPaths

}

# Example usage: pass a list of paths as input and get the non-tracked paths as output
$Paths = @("C:\path1", "C:\path2", "C:\path3", "C:\path4")
$NonTrackedPaths = Get-NonTrackedPaths -Paths @(get-clipboard)
$NonTrackedPaths
