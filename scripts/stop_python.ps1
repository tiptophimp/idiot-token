$ErrorActionPreference = 'Stop'

param(
    [string]$ReportDir = 'reports'
)

$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
if (!(Test-Path -LiteralPath $ReportDir)) {
    New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
}
$reportPath = Join-Path -Path $ReportDir -ChildPath ("python_shutdown_{0}.txt" -f $timestamp)

function Write-Log {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )
    $Message | Out-File -FilePath $reportPath -Append -Encoding utf8
}

Write-Log ("Python Shutdown Report - {0}" -f (Get-Date))
Write-Log 'Enumerating Python processes...'

# Collect Python-related processes
$processes = Get-Process -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -match '^(python|pythonw|py|uvicorn|daphne|celery|ray|jupyter|ipython|pytest|gunicorn)$' -or
    ($_.Path -and $_.Path -match 'python')
}

if (!$processes -or $processes.Count -eq 0) {
    Write-Log 'No Python-related processes found.'
} else {
    foreach ($p in $processes) {
        try {
            Write-Log ("Attempting graceful stop: PID {0} Name {1}" -f $p.Id, $p.Name)
            Stop-Process -Id $p.Id -ErrorAction Stop
            Start-Sleep -Milliseconds 500
        } catch {
            Write-Log ("Graceful stop failed for PID {0}: {1}" -f $p.Id, $_.Exception.Message)
        }
    }

    Start-Sleep -Seconds 1

    $remaining = @()
    foreach ($p in $processes) {
        $exists = Get-Process -Id $p.Id -ErrorAction SilentlyContinue
        if ($exists) { $remaining += $p }
    }

    if ($remaining.Count -gt 0) {
        Write-Log 'Forcing remaining processes...'
        foreach ($p in $remaining) {
            try {
                Write-Log ("Force stop: PID {0} Name {1}" -f $p.Id, $p.Name)
                Stop-Process -Id $p.Id -Force -ErrorAction Stop
            } catch {
                Write-Log ("Force stop failed for PID {0}: {1}" -f $p.Id, $_.Exception.Message)
            }
        }
    }
}

Write-Log 'Final process check...'
$final = Get-Process -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -match '^(python|pythonw|py|uvicorn|daphne|celery|ray|jupyter|ipython|pytest|gunicorn)$' -or
    ($_.Path -and $_.Path -match 'python')
}
if (!$final -or $final.Count -eq 0) {
    Write-Log 'All Python processes terminated.'
} else {
    foreach ($f in $final) {
        Write-Log ("Still running: PID {0} Name {1}" -f $f.Id, $f.Name)
    }
}

Write-Log ("Done at {0}" -f (Get-Date))

# Copy pointer to latest
Copy-Item -Path $reportPath -Destination (Join-Path -Path $ReportDir -ChildPath 'python_shutdown_latest.txt') -Force

# Emit report path for caller
$reportPath


