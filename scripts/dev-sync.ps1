# scripts/dev-sync.ps1
#
# Dev-mode helper for the domain-experts monorepo when consumed as a git
# submodule inside a venture project (e.g., TaxFlow, Member Plus, Turif).
#
# Why this exists:
#   Claude Code's `claude plugin install` COPIES plugin files into its own
#   cache. Editing files in the submodule does NOT live-update Claude Code
#   -- you must uninstall + install to push changes into the cache. This
#   script automates that one step plus a few others.
#
# Commands:
#   .\scripts\dev-sync.ps1 sync     -> reload the domain-experts plugin
#                                      from the submodule into Claude Code
#                                      (run this after editing any file in
#                                       plugins/domain-experts/)
#   .\scripts\dev-sync.ps1 pull     -> git pull in the submodule then sync
#   .\scripts\dev-sync.ps1 status   -> show submodule commit + local changes
#                                      + commits ahead of origin
#   .\scripts\dev-sync.ps1 help     -> show this header
#
# Daily dev workflow (from inside any venture that uses this submodule):
#   1. Edit a file in plugins/domain-experts/skills/... (or any other
#      plugin in the monorepo).
#   2. .\scripts\dev-sync.ps1 sync
#   3. Test by invoking the affected skill in Claude Code.
#   4. When the change is solid:
#        git add -A; git commit -m "..."; git push
#      (this happens inside the submodule -- pushes to onestudio-exp/
#       domain-experts directly, NOT to the venture's repo.)
#   5. In the venture's repo root:
#        git add <path-to-submodule>; git commit -m "..."
#      (updates the submodule pointer so teammates pick up your version.)
#
# Teammate workflow (after a colleague pushes a plugin improvement):
#   1. git pull (in their venture's repo)
#   2. git submodule update --init --recursive
#   3. .\scripts\dev-sync.ps1 sync (in their venture)
#
# Cross-platform: a bash equivalent (dev-sync.sh) lives next to this file.

param(
    [Parameter(Position = 0)]
    [ValidateSet('sync', 'pull', 'status', 'help')]
    [string]$Command = 'help'
)

$ErrorActionPreference = 'Continue'

# Submodule root = parent of the directory this script lives in.
# i.e., scripts/dev-sync.ps1 -> submodule root is $PSScriptRoot/..
$submodulePath = (Get-Item $PSScriptRoot).Parent.FullName

# Sanity check: make sure we are actually inside a git checkout of the
# domain-experts monorepo (look for the marketplace manifest).
$manifest = Join-Path $submodulePath '.claude-plugin/marketplace.json'
if (-not (Test-Path $manifest)) {
    Write-Host "ERROR: this script must live inside the domain-experts monorepo." -ForegroundColor Red
    Write-Host "Expected manifest at: $manifest" -ForegroundColor Yellow
    exit 1
}

function Invoke-Sync {
    Write-Host "[1/2] uninstalling current plugin..." -ForegroundColor Cyan
    & claude plugin uninstall domain-experts@domain-experts 2>&1 | Select-Object -First 1

    Write-Host "[2/2] installing from submodule..." -ForegroundColor Cyan
    & claude plugin install domain-experts@domain-experts 2>&1 | Select-Object -First 1

    Write-Host ""
    Write-Host "OK - sync complete. Claude Code now uses the current submodule state." -ForegroundColor Green
}

function Invoke-Pull {
    Push-Location $submodulePath
    try {
        Write-Host "pulling latest from upstream..." -ForegroundColor Cyan
        & git pull origin main
    } finally {
        Pop-Location
    }
    Write-Host ""
    Invoke-Sync
}

function Invoke-Status {
    Push-Location $submodulePath
    try {
        Write-Host "=== submodule state ===" -ForegroundColor Cyan
        Write-Host "path:   $submodulePath"
        Write-Host "remote: $(& git config --get remote.origin.url)"
        Write-Host "branch: $(& git rev-parse --abbrev-ref HEAD)"
        Write-Host "commit: $(& git log -1 --oneline)"
        Write-Host ""
        Write-Host "=== local changes ===" -ForegroundColor Cyan
        $changes = & git status --short
        if ($changes) {
            $changes
        } else {
            Write-Host "(clean - no local edits)" -ForegroundColor DarkGray
        }
        Write-Host ""
        Write-Host "=== commits ahead of origin/main ===" -ForegroundColor Cyan
        $ahead = & git log origin/main..HEAD --oneline 2>$null
        if ($ahead) {
            $ahead
            Write-Host ""
            Write-Host "TIP: run 'git push' inside $submodulePath to share with the team." -ForegroundColor Yellow
        } else {
            Write-Host "(up to date with origin/main)" -ForegroundColor DarkGray
        }
    } finally {
        Pop-Location
    }
}

function Show-Help {
    Get-Content $MyInvocation.MyCommand.Path | Select-Object -First 45
}

switch ($Command) {
    'sync'   { Invoke-Sync }
    'pull'   { Invoke-Pull }
    'status' { Invoke-Status }
    'help'   { Show-Help }
}

exit 0
