 
$WorkDir = "./nats-server"

git clone https://github.com/nats-io/nats-server.git $WorkDir
$Tag = "2.11.3"

cd $WorkDir
git checkout tags/v$Tag
cd ..


# Get the path to the overlay folder (assuming it's at the same level as the 'work' folder)

$currentLocation = Get-Location
Write-Host $currentLocation

$OverlayFolder = Join-Path -Path $currentLocation -ChildPath "overlay"
Write-Host "Overlay folder '$OverlayFolder'"
 
$BuildFolder = Join-Path -Path $currentLocation -ChildPath "build"

# Check if the overlay folder exists
if (!(Test-Path -Path $OverlayFolder -PathType Container)) {
    Write-Error "Overlay folder '$OverlayFolder' not found."
    exit 1
}

# Use Copy-Item with -Force and -Recurse to copy and overwrite
try {
    Copy-Item -Path $OverlayFolder\* -Destination "$WorkDir" -Force -Recurse -Container -PassThru | ForEach-Object {
        Write-Host "Copied/Overwritten: $_"
    }
    Write-Host "Overlay applied successfully."
}
catch {
    Write-Error "Error applying overlay: $_"
    exit 1
}



cd $WorkDir
 

# Store the original environment variables
$OriginalGOOS = $env:GOOS
$OriginalGOARCH = $env:GOARCH

try {
    # Set the new environment variables
    $env:GOOS = "linux"
    $env:GOARCH = "amd64"

    # ... (Your code that needs the modified environment variables) ...
    Write-Host "GOOS: $($env:GOOS)"
    Write-Host "GOARCH: $($env:GOARCH)"
    # ... (Your code that needs the modified environment variables) ...
    go mod tidy 
    go build .
}
finally {
    # Use a 'finally' block to *always* restore
    # Restore the original environment variables, even if errors occur
    if ($null -ne $OriginalGOOS ) { $env:GOOS = $OriginalGOOS } else { Remove-Item Env:\GOOS }
    if ($null -ne $OriginalGOARCH ) { $env:GOARCH = $OriginalGOARCH } else { Remove-Item Env:\GOARCH }

    Write-Host "GOOS (restored): $($env:GOOS)"
    Write-Host "GOARCH (restored): $($env:GOARCH)"

}

cd ..

try {
    Copy-Item -Path $WorkDir/nats-server -Destination "$BuildFolder/nats-server" -Force -Recurse -Container -PassThru | ForEach-Object {
        Write-Host "Copied/Overwritten: $_"
    }
    Write-Host "Overlay applied successfully."
}
catch {
    Write-Error "Error applying overlay: $_"
    exit 1
}

docker build --build-arg NATSSERVERVERSION=$Tag --file .\build\Dockerfile . --tag ghstahl/nats:$Tag
