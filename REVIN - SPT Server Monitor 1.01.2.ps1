# This code belongs to Revin and it is licensed under GNU GPLv3.
# This script is open source but I would like to receive credit if any alternate versions are released.
# Replace the "Drive:\Path\To\SPT.Server.exe" with your SPT install location
# Change your time zone on line 9 in the quotation marks
# Do not remove the quotation marks
param(
    [string]$ProgramPath = "D:\SPT\SPT.Server.exe",
    [string]$ProgramName = "SPT.Server",
    [string]$TimeZoneId = "Eastern Standard Time",
    [string]$LogFilePath = "D:\SPT\SPT_Server_CrashLog.txt" # Path to the log file
)

# Function to start the program with high priority
# Please do not put to real-time priority
function Start-Program {
    $process = Get-Process -Name $ProgramName -ErrorAction SilentlyContinue
    if (-not $process) {
        Write-Output "Starting $ProgramName with high priority..."
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $ProgramPath
        $startInfo.Arguments = ""
        $startInfo.UseShellExecute = $true
        $startInfo.CreateNoWindow = $false
        $process = [System.Diagnostics.Process]::Start($startInfo)
        Start-Sleep -Seconds 5
        if ($process) {
            $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
            Write-Output "$ProgramName started and set to high priority."
        } else {
            Write-Output "Failed to start $ProgramName."
        }
    } else {
        Write-Output "$ProgramName is already running."
    }
    return $process
}

# Function to log the crash time and reason
function Log-CrashTime {
    param (
        [string]$reason
    )
    $currentTime = Get-Date
    Add-Content -Path $LogFilePath -Value "[$currentTime] $ProgramName crashed and was restarted. Reason: $reason"
}

# Function to monitor the program and restart if it crashes
# Function also works when accidentally closing the server window
function Monitor-Program {
    $lastRestart = $null

    # Attempt to find the specified time zone
    try {
        $timeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($TimeZoneId)
    } catch {
        Write-Output "Error: The specified time zone '$TimeZoneId' is not valid. Exiting script."
        exit
    }

    while ($true) {
        $process = $null
        $errorReason = $null
        try {
            $process = Get-Process -Name $ProgramName -ErrorAction Stop
        } catch {
            $errorReason = $_.Exception.Message
        }

        if (-not $process) {
            $reason = if ($errorReason) { $errorReason } else { "Unknown" }
            Write-Output "$ProgramName is not running. Restarting..."
            Log-CrashTime -reason $reason # Log the crash time and reason before restarting
            Start-Program
        }

        # Get the current time in the specified time zone
        $currentTime = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date).ToUniversalTime(), $timeZone)

        # Check if it's 12 AM in the specified time zone for daily restart
        if ($currentTime.Hour -eq 0 -and $currentTime.Minute -eq 1 -and ($lastRestart -eq $null -or $lastRestart.Date -ne $currentTime.Date)) {
            Write-Output "Restarting $ProgramName for daily restart..."
            Stop-Process -Name $ProgramName -Force -ErrorAction SilentlyContinue
            Start-Program
            $lastRestart = $currentTime
            Start-Sleep -Seconds 60  # Wait a minute to avoid multiple restarts within the same minute
        }

        Start-Sleep -Seconds 10
    }
}

# Function to launch the monitoring script in a new PowerShell terminal window
function Launch-MonitoringSession {
    $scriptPath = $PSCommandPath
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -WindowStyle Normal
}

# Ensure no existing instances of the program are running
$existingProcess = Get-Process -Name $ProgramName -ErrorAction SilentlyContinue
if ($existingProcess) {
    Write-Output "$ProgramName is already running. Exiting script."
    exit
}

# Start the program immediately in a separate window
Start-Program

# Launch the monitoring process in a new PowerShell window
Launch-MonitoringSession

# Start monitoring the program
Monitor-Program
