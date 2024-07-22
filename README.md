# SPT-Server-Monitor
This PowerShell script will automatically start your SPT server in high priority mode, monitor the program to see if it is open or crashed, relaunches when crashed, and automatically restarts the server at 12AM EST daily by default, or you can change the time zone if you wish.

Huge shoutout to Ekuland and Shynd for helping me out with minor problems! Much appreciated!

What It Does:
===============

- Launches the server in High Priority mode
- Monitors to see if the server is open or not
- Relaunches the server if the server has crashed
- Restarts the server daily at 12 AM EST


How-To:
========

1. Download the script
2. Open the script using Notepad, Notepad++, Visual Studio, or whatever you're comfortable with
3. Change the "Path\To\SPT.Server.exe" to the path where your SPT.Server.exe resides
4. Change the "Eastern Standard Time" to your time zone
5. Save changes
6. Set ExecutionPolicy to RemoteSigned using the following command "Set-ExecutionPolicy Unrestricted"
7. Check ExecutionPolicy with this command "Get-ExecutionPolicy". If it says "RemoteSigned" you can now run the script.
8. Right click on the script and "Run with PowerShell"



v1.01 Changes:
=========
- Added the ability to change the time zone
- Set the script to run in High Priority (was set to Realtime)
- Changed the text to display "High Priority" instead of "Realtime"
