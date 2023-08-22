﻿function remove-worktree
{
   # Read the config file content as an array of lines
            $configLines = Get-Content -Path $configFile

            # Filter out the lines that contain worktree
            $newConfigLines = $configLines | Where-Object { $_ -notmatch "worktree" }

                  # Check if there are any lines to remove
            if (($configLines | Where-Object { $_ -match "worktree" }))
                  {
                      # Write the new config file content
                Set-Content -Path $configFile -Value $newConfigLines -Force
            }

}

# A function to validate a path argument
function Validate-Path {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    if (-not (Test-Path $Path)) {
        Write-Error "Invalid $Name path: $Path"
        exit 1
    }
}

# A function to repair a fatal git status
function Repair-Git {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Modules
    )
    # Print a message indicating fatal status
    Write-Output "fatal status for $Path"

    # Get the .git file or folder in that path
    $toRepair = Get-ChildItem -Path "$Path\*" -Force | Where-Object { $_.Name -eq ".git" }

    # Check if it is a file or a folder
    if( $toRepair -is [System.IO.FileInfo] )
    {
        # Get the module folder that matches the name of the parent directory
        $module = Get-ChildItem -Path $Modules -Directory | Where-Object { $_.Name -eq $toRepair.Directory.Name } | Select-Object -First 1
              $moveParams = @{
				  Path = $module.FullName
			      Destination = $toRepair
                  Force = $true
                  PassThru = $true
              }

              # Move the module folder to replace the .git file and return the moved item
        Remove-Item -Path $toRepair -Force   
		
              $movedItem = Move-Item @moveParams
              # Print a message indicating successful move
              Write-Output "moved $($movedItem.Name) to $($movedItem.DirectoryName)"
          }
    elseif( $toRepair -is [System.IO.DirectoryInfo] )
          {
              # Get the path to the git config file
        $configFile = Join-Path -Path $toRepair -ChildPath "\config"
    
              # Check if it exists
              if (-not (Test-Path -LiteralPath $configFile)) {
          Write-Error "Invalid folder path: $toRepair"  
              }
              else
              {
         
	remove-worktree
        }
    }
    else
    {
        # Print an error message if it is not a file or a folder
        Write-Error "not a .git file or folder: $toRepair"
    }
}

# A function to process files with git status and repair them if needed
function Process-Files {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Start,
        [Parameter(Mandatory=$true)]
        [string]$Modules
    )
    
begin
{
    Push-Location

        # Validate the arguments
	Validate-Path $Modules $folder

    # Redirect the standard error output of git commands to the standard output stream
    $env:GIT_REDIRECT_STDERR = '2>&1'

        Write-Progress -Activity "Processing files" -Status "Starting" -PercentComplete 0

        # Create a queue to store the paths
        $que = New-Object System.Collections.Queue

        # Enqueue the start path
        $Start | % { $que.Enqueue($_) }

    # Initialize a counter variable
    $i = 0;

    }
    
    process {

    # Define parameters for Write-Progress cmdlet
    $progressParams = @{
        Activity = "Processing files"
        Status = "Starting"
        PercentComplete = 0
    }
         # Loop through the queue until it is empty
         do {    
      # Increment the counter
      $i++;

             # Dequeue a path from the queue
             $path = $que.Dequeue()

      # Change the current directory to the subdirectory
             Set-Location $path;

      # Run git status and capture the output
      $output = git status

      # Check if the output is fatal
      if($output -like "fatal*")
      {
			Repair-Git -Path $path -modules $modules
          }
          else
          {
              # Print an error message if it is not a file or a folder
              Write-Error "not a .git file or folder: $gitFile"
                 # Get the subdirectories of the path and enqueue them, excluding any .git folders
                 Get-ChildItem -Path "$path\*" -Directory -Exclude "*.git*" | % { $que.Enqueue($_.FullName) }
          }

      # Calculate the percentage of directories processed
             $percentComplete =  ($i / ($que.count+$i) ) * 100

      # Update the progress bar
      $progressParams.PercentComplete = $percentComplete
      Write-Progress @progressParams
     
         } while ($que.Count -gt 0)
}
end {
    # Restore the original location
    Pop-Location

    # Complete the progress bar
    $progressParams.Status = "Finished"
    Write-Progress @progressParams
    }
}

# Synopsis: A script to process files with git status and repair them if needed
# Parameter: Start - The start path to process
# Parameter: Modules - The path to the modules folder
param (
    [Parameter(Mandatory=$true)]
    [string]$Start,
    [Parameter(Mandatory=$true)]
    [string]$Modules
)

# Call the main function
Process-Files -Start $Start -Modules $Modules
