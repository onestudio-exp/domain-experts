# scripts/install-telemetry-hook.ps1
#
# Installs the Agent Edit Telemetry post-commit hook into the venture's
# git repository. Run this ONCE per venture per developer.
#
# Usage:
#   .\install-telemetry-hook.ps1            # install
#   .\install-telemetry-hook.ps1 -Uninstall # remove
#   .\install-telemetry-hook.ps1 -Status    # check
#
# What gets installed:
#   <venture-root>/.git/hooks/post-commit  (copy of scripts/hooks/post-commit)
#   <venture-root>/.telemetry/             (directory, gitignored)
#   <venture-root>/.gitignore              (entry added: .telemetry/)
#
# Idempotent: re-running install is safe.

param(
    [switch]$Uninstall,
    [switch]$Status
)

$ErrorActionPreference = 'Continue'

# Find paths
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$hookSource = Join-Path $scriptDir 'hooks/post-commit'

# Find venture git root (walk up from current dir)
$ventureRoot = & git rev-parse --show-toplevel 2>$null
if (-not $ventureRoot) {
    Write-Host "ERROR: not inside a git repository. cd into your venture first." -ForegroundColor Red
    exit 1
}
$ventureRoot = $ventureRoot.Trim()

$hookTarget = Join-Path $ventureRoot '.git/hooks/post-commit'
$telemetryDir = Join-Path $ventureRoot '.telemetry'
$gitignorePath = Join-Path $ventureRoot '.gitignore'

if ($Status) {
    Write-Host "=== Telemetry hook status ===" -ForegroundColor Cyan
    Write-Host "Venture root:   $ventureRoot"
    Write-Host "Hook installed: $(if (Test-Path $hookTarget) { 'YES' } else { 'NO' })"
    Write-Host "Telemetry dir:  $(if (Test-Path $telemetryDir) { 'EXISTS' } else { 'NOT YET' })"

    $editsFile = "$telemetryDir/edits.jsonl"
    $classifiedFile = "$telemetryDir/classified.jsonl"

    if (Test-Path $editsFile) {
        $editsCount = (Get-Content $editsFile | Measure-Object -Line).Lines
        Write-Host "Edits captured: $editsCount"
    }
    if (Test-Path $classifiedFile) {
        $classifiedCount = (Get-Content $classifiedFile | Measure-Object -Line).Lines
        Write-Host "Edits classified: $classifiedCount"
        $unclassified = $editsCount - $classifiedCount
        if ($unclassified -gt 0) {
            Write-Host ""
            Write-Host "NEXT: $unclassified unclassified edits. Run: /domain-experts:classify-edit" -ForegroundColor Yellow
        }
    } elseif (Test-Path $editsFile -and $editsCount -gt 0) {
        Write-Host ""
        Write-Host "NEXT: $editsCount unclassified edits. Run: /domain-experts:classify-edit" -ForegroundColor Yellow
    }

    # Latest learn-report if any
    $reports = Get-ChildItem -Path $telemetryDir -Filter "learn-report-*.md" -ErrorAction SilentlyContinue | Sort-Object Name -Descending
    if ($reports.Count -gt 0) {
        Write-Host ""
        Write-Host "Latest learn-report: $($reports[0].Name)" -ForegroundColor Cyan
        Write-Host "TIP: /domain-experts:propose-pr --pattern <N> --report $($reports[0].FullName)" -ForegroundColor DarkGray
    }
    exit 0
}

if ($Uninstall) {
    if (Test-Path $hookTarget) {
        Remove-Item $hookTarget
        Write-Host "OK - removed: $hookTarget" -ForegroundColor Green
    } else {
        Write-Host "(no hook installed)" -ForegroundColor DarkGray
    }
    Write-Host "Note: .telemetry/ directory preserved (delete manually if desired)." -ForegroundColor Yellow
    exit 0
}

# Install
if (-not (Test-Path $hookSource)) {
    Write-Host "ERROR: hook source not found at $hookSource" -ForegroundColor Red
    exit 1
}

# Copy hook
Copy-Item $hookSource $hookTarget -Force
Write-Host "OK - installed hook: $hookTarget" -ForegroundColor Green

# Create telemetry dir
if (-not (Test-Path $telemetryDir)) {
    New-Item -ItemType Directory -Path $telemetryDir | Out-Null
    Write-Host "OK - created: $telemetryDir" -ForegroundColor Green
}

# Add to .gitignore if not already there
$gitignoreEntry = ".telemetry/"
$currentGitignore = if (Test-Path $gitignorePath) { Get-Content $gitignorePath -Raw } else { "" }
if ($currentGitignore -notmatch [regex]::Escape($gitignoreEntry)) {
    Add-Content $gitignorePath -Value "`n# Agent Edit Telemetry (do not commit)`n$gitignoreEntry`n"
    Write-Host "OK - added .telemetry/ to .gitignore" -ForegroundColor Green
} else {
    Write-Host "(.gitignore already excludes .telemetry/)" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "Done. Every future commit that touches agent files will be captured." -ForegroundColor Green
Write-Host "Run with -Status to inspect, -Uninstall to remove." -ForegroundColor DarkGray

exit 0
