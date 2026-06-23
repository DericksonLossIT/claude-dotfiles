# setup.ps1 — Link Claude Code skills into ~/.claude/skills (Windows)
# Uses a directory junction (no admin / Developer Mode required).
#
# Usage:
#   1. Clone this repo
#   2. Open PowerShell
#   3. Run: .\setup.ps1

$ErrorActionPreference = "Stop"
$dotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

$skillsSrc = Join-Path $dotfilesRoot ".claude\skills"
$skillsDst = Join-Path $env:USERPROFILE ".claude\skills"
$claudeDir = Join-Path $env:USERPROFILE ".claude"

if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir | Out-Null
    Write-Host "Criado $claudeDir"
}

if (Test-Path $skillsDst) {
    $item = Get-Item $skillsDst -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        $target = $item.Target
        if ($target -eq $skillsSrc) {
            Write-Host "$skillsDst ja aponta para $skillsSrc — nada a fazer."
            exit 0
        }
        Write-Host "Removendo junction existente: $skillsDst -> $target"
        cmd /c "rmdir `"$skillsDst`"" 2>$null
    } else {
        $backup = "$skillsDst.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Write-Host "Diretorio real encontrado. Backup em $backup"
        Move-Item $skillsDst $backup
    }
}

cmd /c "mklink /J `"$skillsDst`" `"$skillsSrc`""
Write-Host "OK: $skillsDst -> $skillsSrc"
