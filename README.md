# SPT-Server-Monitor
This PowerShell script will automatically start your SPT server in high priority mode, monitor the program to see if it is open or crashed, relaunches when crashed, and automatically restarts the server at 12AM EST daily. 


This is a PowerShell script that you can configure, and run, on your SPT install that will monitor, launch, relaunch, and restart your SPT server daily. 

What It Does:
===============

- Launches the server in High Priority mode
- Monitors to see if the server is open or not
- Relaunches the server if the server has crashed
- Restarts the server daily at 12 AM EST


How-To:
========

1. Download the file
2. Open the file using Notepad, Notepad++, Visual Studio, or whatever you're comfortable with
3. Change the "Path\To\SPT.Server.exe" to the path where your SPT.Server.exe resides
4. Save changes
5. Right click on the script and "Run with PowerShell"
