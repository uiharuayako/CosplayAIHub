# SPDX-License-Identifier: GPL-3.0-or-later
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$source = Get-Item -LiteralPath $SourcePath -ErrorAction Stop
if ($source.PSIsContainer) { throw 'SourcePath must point to one source image file.' }
$allowedExtensions = @('.jpg', '.jpeg', '.png', '.webp', '.tif', '.tiff', '.heic', '.heif', '.avif', '.bmp', '.dng', '.cr2', '.cr3', '.nef', '.arw', '.raf', '.rw2', '.orf', '.pef', '.srw')
if ($source.Extension.ToLowerInvariant() -notin $allowedExtensions) {
    throw 'Unsupported source extension. Select an original photo, not a project or script.'
}
if ($source.Directory.Name -ieq 'aifix') {
    throw 'Select the original source outside aifix to avoid nested output folders.'
}
$repoRoot = Split-Path -Parent $PSScriptRoot
$privateRoot = Join-Path $repoRoot 'workspace'
# Existing junctions/symlinks must not silently redirect private jobs elsewhere.
if (Test-Path -LiteralPath $privateRoot) {
    $privateItem = Get-Item -LiteralPath $privateRoot -Force
    if (-not $privateItem.PSIsContainer -or ($privateItem.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        throw 'workspace must be a regular directory, not a file or reparse point.'
    }
}
$jobId = '{0}-{1}' -f (Get-Date -Format 'yyyyMMdd-HHmmss'), ([guid]::NewGuid().ToString('N').Substring(0, 8))
$jobRoot = Join-Path $privateRoot $jobId
$null = New-Item -ItemType Directory -Path $jobRoot
foreach ($folder in @('projects', 'intermediates', 'masks', 'generated', 'previews', 'scripts', 'logs')) {
    $null = New-Item -ItemType Directory -Path (Join-Path $jobRoot $folder)
}
$outputDirectory = Join-Path $source.Directory.FullName 'aifix'
$manifest = [ordered]@{
    schema_version = 1
    job_id = $jobId
    created_at = [DateTimeOffset]::Now.ToString('o')
    status = 'initialized'
    source_path = $source.FullName
    source_size_bytes = $source.Length
    source_sha256 = (Get-FileHash -LiteralPath $source.FullName -Algorithm SHA256).Hash
    output_directory = $outputDirectory
    project_directory = Join-Path $jobRoot 'projects'
    outputs = @()
}
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $jobRoot 'job.json') -Encoding utf8
Copy-Item -LiteralPath (Join-Path $repoRoot 'templates/job.example.md') -Destination (Join-Path $jobRoot 'job.md')
[pscustomobject]@{
    JobId = $jobId
    JobDirectory = $jobRoot
    SourcePath = $source.FullName
    OutputDirectory = $outputDirectory
}
