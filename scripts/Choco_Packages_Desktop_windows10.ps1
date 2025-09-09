$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"
Write-Output "Verbose logging enabled: $VerbosePreference"

# Define packages that need checksum bypass (temporary workaround)
$ignoreChecksumPackages = @('sysinternals', 'network-miner', 'googlechrome')

# Define packages that may require reboot (exit code 3010 is success but needs reboot)
$rebootExpectedPackages = @('vagrant', 'virtualbox', 'vmware-workstation-player')

# Define packages that might have network issues
$networkSensitivePackages = @('vmware-workstation-player', 'virtualbox', 'vagrant')

# Function to install packages with error handling
function Install-ChocoPackages {
    param(
        [string]$Category,
        [string[]]$Packages
    )

    Write-Host "`n####################################################################"
    Write-Host "###################   $($Category.PadRight(15))   #####################"
    Write-Host "####################################################################"

    foreach ($package in $Packages) {
        try {
            Write-Host "Installing $package..." -ForegroundColor Cyan
            
            # Build argument array
            $installArgs = @(
                'install', $package,
                '--yes',
                '--no-progress',
                '--accept-license',
                '--limitoutput'
            )
            
            # Add --ignore-checksums if needed
            if ($ignoreChecksumPackages -contains $package) {
                $installArgs += '--ignore-checksums'
                Write-Host "WARNING: Installing $package with checksums ignored" -ForegroundColor Yellow
            }

            # Execute installation with retry for network-sensitive packages
            $attempts = 1
            $maxAttempts = if ($networkSensitivePackages -contains $package) { 3 } else { 1 }
            
            while ($true) {
                try {
                    choco @installArgs
                    $exitCode = $LASTEXITCODE
                    break
                }
                catch {
                    if ($attempts -lt $maxAttempts) {
                        $attempts++
                        Write-Host "WARNING: Installation attempt $attempts/$maxAttempts for $package" -ForegroundColor Yellow
                        Start-Sleep -Seconds (10 * $attempts)  # Exponential backoff
                    }
                    else {
                        throw
                    }
                }
            }

            # Handle expected reboot requirements
            if ($rebootExpectedPackages -contains $package -and $exitCode -eq 3010) {
                Write-Host "SUCCESS: $package installed but requires reboot (Exit code: 3010)" -ForegroundColor Yellow
                $global:rebootRequired = $true
            }
            # Handle standard success
            elseif ($exitCode -eq 0) {
                Write-Host "$package installed successfully" -ForegroundColor Green
            }
            # Handle failure
            else {
                throw "Chocolatey installation failed for $package (Exit code: $exitCode)"
            }
        }
        catch {
            Write-Host "ERROR: $_" -ForegroundColor Red
            if ($networkSensitivePackages -contains $package) {
                Write-Host "WARNING: This failure might be due to network issues. Continuing with other packages..." -ForegroundColor Yellow
                $global:networkSensitiveFailures = $true
            }
            else {
                exit $exitCode
            }
        }
    }
}

# Initialize global flags
$global:rebootRequired = $false
$global:networkSensitiveFailures = $false

# Upgrade Chocolatey first
try {
    Write-Host "Upgrading Chocolatey..." -ForegroundColor Magenta
    choco upgrade chocolatey --yes --no-progress --limitoutput
    if ($LASTEXITCODE -ne 0) { throw "Chocolatey upgrade failed (Exit code: $LASTEXITCODE)" }
}
catch {
    Write-Host "CRITICAL ERROR: $_" -ForegroundColor Red
    exit 1
}

# Refresh environment after Chocolatey upgrade
try {
    Write-Host "Refreshing environment variables..." -ForegroundColor Cyan
    refreshenv
}
catch {
    Write-Host "WARNING: Environment refresh failed - $($_.Exception.Message)" -ForegroundColor Yellow
}

# Define package categories
$packageGroups = @{
    "System Tools"     = @('sysinternals', 'psscriptanalyzer', 'osquery', 
                          'ChocolateyGUI', 'packer', 'terraform', 
                          'vagrant', 'virtualbox', 'vmware-workstation-player')
    
    "Net Tools"        = @('wireshark', 'network-miner', 'angryip', 'advanced-ip-scanner')
    
    "Security"         = @('zap', 'burp-suite-free-edition', 'fiddler')
    
    "Browsers"         = @('googlechrome', 'firefox', 'safari', 
                          'opera', 'tor-browser', 'thunderbird')
    
    "Utilities"        = @('7zip', 'etcher', 'rufus', 
                          'virtualclonedrive')
    
    "Remote Access"    = @('winscp', 'mremoteng', 
                          'filezilla', 'deluge', 'openvpn')
    
    "Media"            = @('vlc', 'screamer', 'googleearth', 
                          'icloud', 'itunes')
    
    "Catalogues"       = @('calibre', 'zotero', 'keepass', 'mendeley')
    
    "Editors"          = @('foxitreader', 'notepadplusplus', 'libreoffice-still')
    
    "Development"      = @('vscode', 'git', 'tortoisegit', 'postman', 
                          'pycharm-community', 'eclipse', 'anaconda3', 'miniconda3')
    
    "Compilers"        = @('jre8', 'ruby', 'golang', 'python')
}

# Install all package groups
foreach ($group in $packageGroups.GetEnumerator()) {
    Install-ChocoPackages -Category $group.Key -Packages $group.Value
}

# Final system check
Write-Host "`n####################################################################"
Write-Host "###################   INSTALLATION SUMMARY   #####################"
Write-Host "####################################################################"

try {
    Write-Host "Listing installed packages..." -ForegroundColor Cyan
    choco list --local-only --limitoutput
    if ($LASTEXITCODE -ne 0) { 
        Write-Host "Package listing completed with warnings" -ForegroundColor Yellow
        Write-Host "Full package list:"
        choco list --local-only
    }
}
catch {
    Write-Host "Package listing failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Handle reboot notification
if ($global:rebootRequired) {
    Write-Host "`nWARNING: Some packages require a system reboot to function properly!" -ForegroundColor Yellow
    Write-Host "Packages requiring reboot: $($rebootExpectedPackages -join ', ')" -ForegroundColor Yellow
    Write-Host "CI environment note: Automatic reboot not performed. Manual reboot may be required." -ForegroundColor Yellow
}

# Handle network-sensitive failures
if ($global:networkSensitiveFailures) {
    Write-Host "`nWARNING: Some network-sensitive packages failed to install!" -ForegroundColor Yellow
    Write-Host "This might be due to temporary network issues or regional restrictions." -ForegroundColor Yellow
    Write-Host "Consider running this workflow again later or using a different network environment." -ForegroundColor Yellow
    Write-Host "Affected packages: $($networkSensitivePackages -join ', ')" -ForegroundColor Yellow
}

# Final success message
if (-not $global:networkSensitiveFailures) {
    Write-Host "`nAll packages installed successfully!" -ForegroundColor Green
}

Write-Host "`nChocolatey installation completed!" -ForegroundColor Green
exit 0
