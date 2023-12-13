# Uninstall-KonicaDriverAndPrinter.ps1

# Define printer parameters
$ipAddress = "null"
$portName = "IP_$ipAddress"
$printerName = "null"
$driverName = "null"

# Remove printer using PrintUI
Write-Host "Removing printer using PrintUI..."
rundll32 printui.dll,PrintUIEntry /dl /n "$printerName"

# Wait for the printer removal to complete
Start-Sleep -Seconds 10

# Remove printer port
Write-Host "Removing printer port..."
cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\Prnport.vbs -d -r $portName

# Check if any printer is using the driver
$driverInUse = Get-Printer | Where-Object { $_.DriverName -eq $driverName }

# Remove driver if not in use
if (-Not $driverInUse) {
    Write-Host "Driver no longer in use. Removing driver..."
    Remove-PrinterDriver -Name $driverName -ErrorAction SilentlyContinue
} else {
    Write-Host "Driver is still in use by another printer. Skipping driver removal."
}

Write-Host "Uninstallation complete."




































