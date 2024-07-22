# Replace the "Path\To\SPT.Server.exe" with your SPT install location
# Do not remove the quotation marks
param(
    [string]$ProgramPath = "Path\To\SPT.Server.exe",
    [string]$ProgramName = "SPT.Server"
)

# Function to start the program with real-time priority
function Start-Program {
    $process = Get-Process -Name $ProgramName -ErrorAction SilentlyContinue
    if (-not $process) {
        Write-Output "Starting $ProgramName with real-time priority..."
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $ProgramPath
        $startInfo.Arguments = ""
        $startInfo.UseShellExecute = $true
        $startInfo.CreateNoWindow = $false
        $process = [System.Diagnostics.Process]::Start($startInfo)
        Start-Sleep -Seconds 5
        if ($process) {
            $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::RealTime
            Write-Output "$ProgramName started and set to real-time priority."
        } else {
            Write-Output "Failed to start $ProgramName."
        }
    } else {
        Write-Output "$ProgramName is already running."
    }
    return $process
}

# Function to monitor the program and restart if it crashes
function Monitor-Program {
    $lastRestart = $null

    while ($true) {
        $process = Get-Process -Name $ProgramName -ErrorAction SilentlyContinue
        if (-not $process) {
            Write-Output "$ProgramName is not running. Restarting..."
            Start-Program
        }

        # Get the current Eastern Time
        $easternTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
        $currentTime = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date).ToUniversalTime(), $easternTimeZone)

        # Check if it's 12 AM ET for daily restart
        if ($currentTime.Hour -eq 0 -and $currentTime.Minute -eq 0 -and ($lastRestart -eq $null -or $lastRestart.Date -ne $currentTime.Date)) {
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