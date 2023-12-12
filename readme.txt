Directions

0. Download the win32 content prop tool from https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool, place the IntuneWinAppUtil.exe in this folder.

1. Place all required drivers and/or certificates in the PrinterPackage directory, they should be included with the installation scripts that are in there.

2. Run the helper.ps1 script in an Admin terminal with "powershell.exe -ExecutionPolicy Bypass -File helper.ps1" from the working directory. Input the requested variables. The .inf file contains the driver names, you can also find them with Get-PrinterDriver on a device that has them installed.

3. Run IntuneWinAppUtil.exe with admin permissions. Set the source directory as C:\Users\YourUser\PrinterPackageHelper\PrinterPackage, the setup file should be printerInstall.ps1. The output directory can be C:\Users\YourUser\PrinterPackageHelper\Output, this is where the intunewin file will go.

4. Deploy the package by going to Intune > Apps. Add an app Win32 app.

5. Select an app package file, this is the output file.

6. Continue through the setup process. Name publisher and all that.

7. When you get to program, set the install command to be 

powershell.exe -ExecutionPolicy Bypass -File "printerInstall.ps1"

Uninstall command is

powershell.exe -ExecutionPolicy Bypass -File "printerUninstall.ps1"

8. It should not allow uninstall. Install behavior System. No specific action for device restart behavior.

9. Requirements, 64 bit. Minimum operating system is the top.

10. Rules format. Manually configure detection rules

Rule type: Registry

Key path: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\Printer Name\

Value Name: Port

Detection method: string comparison

Operator: Equals

Value: IP_printerIp

11. Continue, ignore dependencies, supercedence. Assign it to groups. You're good.