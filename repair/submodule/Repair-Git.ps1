function Repair-Git {
# A function to repair a fatal git status
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Modules
    )
begin
{
    Push-Location

    # Validate the arguments
    if (-not (Test-Path $modules)) { 
      Write-Error "Invalid modules path: $modules"
      exit 1
    }

    if (-not (Test-Path $start)) {
      Write-Error "Invalid start path: $start"
      exit 1
    }

    # Redirect the standard error output of git commands to the standard output stream
    $env:GIT_REDIRECT_STDERR = '2>&1'

    Write-Progress -Activity "Processing files" -Status "Starting" -PercentComplete 0

    # Create a queue to store the paths
    $que = New-Object System.Collections.Queue

    # Enqueue the start path
    $start | % { $que.Enqueue($_) }

    # Initialize a counter variable
    $i = 0;
}
process {

    # Loop through the queue until it is empty
    do
    {    
        # Increment the counter
        $i++;

        # Dequeue a path from the queue
        $path = $que.Dequeue()

        # Change the current directory to the path
        Set-Location $path;

        # Run git status and capture the output
        $output = git status

        # Check if the output is fatal
        if($output -like "fatal*")
        {
    # Print a message indicating fatal status
    Write-Output "fatal status for $Path"

    # Get the .git file or folder in that path
    $toRepair = Get-ChildItem -Path "$Path\*" -Force | Where-Object { $_.Name -eq ".git" }

    # Check if it is a file or a folder
    if( $toRepair -is [System.IO.FileInfo] )
    {
        # Get the module folder that matches the name of the parent directory
        $module = Get-ChildItem -Path $Modules -Directory | Where-Object { $_.Name -eq $toRepair.Directory.Name } | Select-Object -First 1

        # Move the module folder to replace the .git file
        Remove-Item -Path $toRepair -Force 
        Move-Item -Path $module.FullName -Destination $toRepair -Force 
    }
    elseif( $toRepair -is [System.IO.DirectoryInfo] )
    {
        # Get the path to the git config file
        $configFile = Join-Path -Path $toRepair -ChildPath "\config"

        # Check if it exists
        if (-not (Test-Path $configFile)) {
          Write-Error "Invalid folder path: $toRepair"  
        }
        else
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
    }
    else
    {
        # Print an error message if it is not a file or a folder
        Write-Error "not a .git file or folder: $toRepair"
    }
}

} while ($true )
}}