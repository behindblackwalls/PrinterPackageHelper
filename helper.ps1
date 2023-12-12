# PowerShell Helper Script for Modifying printerInstall.ps1 and printerUninstall.ps1

# Function to ensure path has .\ if not absolute
Function Format-RelativePath($path) {
    if (-Not [System.IO.Path]::IsPathRooted($path)) {
        return ".\" + $path
    }
    return $path
}

# Function to write text slowly
Function Write-Slowly($text, $delayMilliseconds = 20) {
    $chars = $text.ToCharArray()
    foreach ($char in $chars) {
        Write-Host $char -NoNewline -ForegroundColor Red
        Start-Sleep -Milliseconds $delayMilliseconds
    }
    Write-Host # New line after complete text
}


# Function to display ASCII Art - Replace with your ASCII art
Function Display-AsciiArt() {
    $asciiArt = @"
    ⠀⠀⠀⠀⢀⡤⠒⠋⠉⠉⠉⠒⢤⡀⠀⠀⠀⠀
    ⠀⠀⢠⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⡄⠀⠀
    ⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢆⠀
    ⢠⠃⠀⠀⠀⠀⣴⠀⠀⠀⠀⣶⠀⠀⠀⠀⠘⡄
    ⢸⠀⠀⠀⠀⠀⠀⠀⠦⠴⠀⠀⠀⠀⠀⠀⠀⡇
    ⠈⢇⡀⠀⠀⢀⠀⢀⠀⠀⡀⠀⠀⠀⢀⠀⡰⠁
    ⠀⠀⢹⠉⢹⡏⠙⠉⢹⢿⠉⢹⢹⠉⢫⠉⠀⠀
    ⠀⠀⠈⣇⠘⡇⢰⢀⡾⡎⠀⡾⠘⡄⢸⡀⠀⠀
    ⠀⠀⠀⢸⡀⡇⡎⢸⡇⢇⠀⡇⢰⢹⠀⡇⠀⠀
    ⠀⠀⠀⢸⢃⢷⣇⢸⡇⢸⡀⣇⡎⢸⢠⠇⠀⠀
    ⠀⠀⠀⣜⣼⢸⠘⢌⣇⡇⠱⣜⣇⣎⠞⠀⠀⠀
    ⠀⠀⠀⠉⠈⡎⡆⠈⡏⢇⠀⢳⢹⠁⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠘⠾⠀⢱⣸⡀⠀⠣⠧⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⠇⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠠⠤⠴⡤⠤⠤⠴⠠⠤⠄⠀⠢⠶⠶⠲⠠⠀⠴
    
"@
    Write-Slowly $asciiArt
    Write-Slowly "Current-borne, wave-flung, tugged hugely by the whole might of ocean, the jellyfish drifts in the tidal abyss. The light shines through it, and the dark enters it. Borne, flung, tugged from anywhere to anywhere, for in the deep sea there is no compass but nearer and farther, higher and lower, the jellyfish hangs and sways; pulses move slight and quick within it, as the vast diurnal pulses beat in the moondriven sea. Hanging, swaying, pulsing, the most vulnerable and insubstantial creature, it has for its defense the violence and power of the whole ocean, to which it has entrusted its being, its going, and its will.

But here rise the stubborn continents. The shelves of gravel and the cliffs of rock break from water baldly into air, that dry, terrible outerspace of radiance and instability, where there is no support for life. And now, now the currents mislead and the waves betray, breaking their endless circle, to leap up in loud foam against rock and air, breaking....

What will the creature made all of seadrift do on the dry sand of daylight; what will the mind do, each morning, waking?"

}


# Function to display main menu
Function Display-MainMenu() {
    Clear-Host
    Write-Host "`nWelcome to the Printer Script Helper!" -ForegroundColor Green
    Write-Host "`nPress Enter to begin or CTRL+C to exit." -ForegroundColor Yellow
    Read-Host
}

# Main Script Execution

$randomNumber = Get-Random -Minimum 1 -Maximum 11
if ($randomNumber -eq 1) {
    Display-AsciiArt
    Start-Sleep 5
}

Display-MainMenu
# Prompt for input parameters
$infPath = Read-Host "`nEnter the filename of the INF file"
$ipAddress = Read-Host "`nEnter the IP address of the printer"
$printerName = Read-Host "`nEnter the name of the printer"
$driverName = Read-Host "`nEnter the name of the printer driver"
$certificateRequired = Read-Host "`nDo you have a certificate? (yes/no)"

# Format paths
$infPath = Format-RelativePath $infPath
if ($certificateRequired -eq "yes") {
    $certificatePath = Format-RelativePath $certificatePath
}

# Update printerInstall.ps1
$installScriptPath = ".\PrinterPackage\printerInstall.ps1"
$installContent = Get-Content $installScriptPath -Raw

# Handle the certificate path based on user input
if ($certificateRequired -eq "yes") {
    $certificatePath = Read-Host "`nEnter the filename of the certificate"
    $certificatePath = Format-RelativePath $certificatePath
    # Replace the entire line for $certificatePath in install script
    $installContent = $installContent -replace '(\$certificatePath = ).*', "`$1`"$certificatePath`""
} else {
    # Set $certificatePath to null and replace the line in install script
    $installContent = $installContent -replace '(\$certificatePath = ).*', "`$1`$null"
}

# Replace variables in install script
$installContent = $installContent -replace '\$infPath = ".*?"', "`$infPath = `"$infPath`""
$installContent = $installContent -replace '\$ipAddress = ".*?"', "`$ipAddress = `"$ipAddress`""
$installContent = $installContent -replace '\$printerName = ".*?"', "`$printerName = `"$printerName`""
$installContent = $installContent -replace '\$driverName = ".*?"', "`$driverName = `"$driverName`""

# Save the updated install script
Set-Content -Path $installScriptPath -Value $installContent

# Update printerUninstall.ps1
$uninstallScriptPath = ".\PrinterPackage\printerUninstall.ps1"
$uninstallContent = Get-Content $uninstallScriptPath -Raw

# Replace variables in uninstall script
$uninstallContent = $uninstallContent -replace '\$infPath = ".*?"', "`$infPath = `"$infPath`""
$uninstallContent = $uninstallContent -replace '\$ipAddress = ".*?"', "`$ipAddress = `"$ipAddress`""
$uninstallContent = $uninstallContent -replace '\$printerName = ".*?"', "`$printerName = `"$printerName`""
$uninstallContent = $uninstallContent -replace '\$driverName = ".*?"', "`$driverName = `"$driverName`""
if ($certificateRequired -eq "yes") {
    $uninstallContent = $uninstallContent -replace '\$certificatePath = ".*?"', "`$certificatePath = `"$certificatePath`""
}

# Save the updated uninstall script
Set-Content -Path $uninstallScriptPath -Value $uninstallContent

# Display a completion message
Write-Host "`nScripts updated successfully. Remember to clear out the old drivers when you're done."

