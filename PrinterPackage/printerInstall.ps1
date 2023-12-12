# Define driver and printer parameters
$infPath = ".\null"
$ipAddress = "null"
$portName = "IP_$ipAddress"
$printerName = "null"
$driverName = "null"
$certificatePath = $null

# Define certificate stores
$certRootStore = "Cert:\LocalMachine\Root"
$certPublisherStore = "Cert:\LocalMachine\TrustedPublisher"

# Function to check and import the certificate
Function Import-CertificateIfMissing($CertPath, $StoreLocation) {
    $certThumbprint = (Get-PfxCertificate -FilePath $CertPath).Thumbprint
    $certExists = Get-ChildItem $StoreLocation | Where-Object { $_.Thumbprint -eq $certThumbprint }

    if (-Not $certExists) {
        Import-Certificate -FilePath $CertPath -CertStoreLocation $StoreLocation
        Write-Host "Certificate imported into $StoreLocation."
    } else {
        Write-Host "Certificate already exists in $StoreLocation."
    }
}

# Check for null or whitespace in $certificatePath before importing certificate
if (![string]::IsNullOrWhiteSpace($certificatePath)) {
    Import-CertificateIfMissing -CertPath $certificatePath -StoreLocation $certRootStore
    Import-CertificateIfMissing -CertPath $certificatePath -StoreLocation $certPublisherStore
} else {
    Write-Host "No certificate path provided. Skipping certificate import."
}

# Check if any printer is using the specified IP address
$printers = Get-Printer | Where-Object { $_.PortName -eq $portName }
if ($printers) {
    Write-Host "A printer is already installed at IP address $ipAddress. Installation cancelled."
    Exit
}

# Check if the driver is already installed
$driverInstalled = Get-PrinterDriver -Name $driverName -ErrorAction SilentlyContinue

# Install driver if not already installed
if (-Not $driverInstalled) {
    Write-Host "Driver not found. Installing driver..."
    pnputil.exe /add-driver $infPath /install
} else {
    Write-Host "Driver already installed. Skipping driver installation."
}

# Add printer port using prnport.vbs
Write-Host "Adding printer port..."
cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\Prnport.vbs -a -r $portName -h $ipAddress -o raw -n 9100

# Add printer using PrintUI
Write-Host "Installing printer using PrintUI..."
rundll32 printui.dll,PrintUIEntry /if /b "$printerName" /f "$infPath" /r "$portName" /m "$driverName"

Write-Host "Installation complete."


































