# Windows PowerShell script for running the video extraction
Write-Host "=== SN AI Video Extract Audio ==="
Write-Host "Starting application..."

# Check if Docker is installed
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-Error "Docker is not installed! Please install Docker Desktop for Windows first."
    exit 1
}

# Check if input file exists
if (-not (Test-Path "input_sn_ai_video_extract_audio.txt")) {
    Write-Error "Error: input_sn_ai_video_extract_audio.txt not found!"
    exit 1
}

# Build Docker image
Write-Host "Building Docker image..."
docker build -t video_extrc_cap .

if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker build failed!"
    exit 1
}

# Get current directory for volume mounting
$currentDir = (Get-Location).Path

# Convert Windows paths to Docker paths
$inputDir = Join-Path $currentDir "Input"
$outputDir = Join-Path $currentDir "output"

# Ensure directories exist
New-Item -ItemType Directory -Force -Path $inputDir | Out-Null
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

Write-Host "Running container..."
# Run Docker container with Windows-style volume mounts
docker run --rm `
    -v "${currentDir}\input_sn_ai_video_extract_audio.txt:/app/input_sn_ai_video_extract_audio.txt:ro" `
    -v "${inputDir}:/video:ro" `
    -v "${outputDir}:/output" `
    video_extrc_cap

if ($LASTEXITCODE -eq 0) {
    Write-Host "=== Process complete ==="
} else {
    Write-Error "Process failed!"
    exit 1
}