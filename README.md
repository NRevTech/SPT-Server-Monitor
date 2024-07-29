# SPT-Server-Monitor
This PowerShell script will automatically start your SPT server in high priority mode, monitor the program to see if it is open or crashed, relaunches when crashed, and automatically restarts the server at 12AM EST daily by default, or you can change the time zone if you wish.

Huge shoutout to Ekuland and Shynd for helping me out with minor problems! Much appreciated!

What It Does:
===============

- Launches the server in High Priority mode
- Monitors to see if the server is open or not
- Relaunches the server if the server has crashed
- Restarts the server daily at 12 AM


How-To:
========

1. Download the script
2. Place script in SPT install location
3. Open the script using Notepad, Notepad++, Visual Studio, or whatever you're comfortable with
4. Change the "Path\To\SPT.Server.exe" to the path where your SPT.Server.exe resides
5. Change the "Eastern Standard Time" to your time zone
6. Save changes
7. Open PowerShell as Administrator
8. Set ExecutionPolicy to Unrestricted using the following command "Set-ExecutionPolicy unrestricted"
9. Check ExecutionPolicy with this command "Get-ExecutionPolicy". If it says "Unrestricted" you can now run the script.
10. Go to the script, right click on the script and "Run with PowerShell"

To Get Time Zone:
==================
1. Open PowerShell
2. Type "Get-TimeZone"
3. The timezone ID that you will place in the [string]$TimeZoneId = "TimeZone Here" will be the "Id" output for example "Id: Eastern Standard Time"



v1.01 Changes:
=========
- Added the ability to change the time zone
- Set the script to run in High Priority (was set to Realtime)
- Changed the text to display "High Priority" instead of "Realtime"


v1.01.1 Changes:
=================
Changes and Fixes:

- Corrected Priority Setting Ensured the priority is set to High using [System.Diagnostics.ProcessPriorityClass]::High.

- Improved Time Zone Handling. Used a try-catch block to handle invalid time zone IDs gracefully.

- Monitoring in a Separate Session:

- Corrected the arguments for Start-Process to ensure the monitoring script starts correctly in a new PowerShell window.

- Ensured the Main Script Exits If Program Already Running. Checked for existing instances of the program and exited if found, to avoid multiple instances running simultaneously.

- Fixed Time Zone Conversion and Restart Logic. Simplified and corrected the logic to restart the program at the specified time.


v1.01.2 Changes:
=================
- "Log-CrashTime" function now accepts a reason parameter, which includes the reason for the crash.
- The "Monitor-Program" function captures any errors when trying to retrieve the process and logs those errors if the process is not found. This way, the log file will include both the timestamp and the reason for each crash. This, however, will not tell you what mod potentially crashed your server. It will explain other reasonings as to why it crashed.
