$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"
Write-Output "Verbose logging enabled: $VerbosePreference"

# Define packages that need checksum bypass (temporary workaround)
$ignoreChecksumPackages = @('sysinternals', 'network-miner')

# Define packages that may require reboot (exit code 3010 is success but needs reboot)
$rebootExpectedPackages = @('vagrant', 'virtualbox', 'vmware-workstation-player')

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

            # Execute installation
            choco @installArgs
            $exitCode = $LASTEXITCODE

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
            exit $exitCode
        }
    }
}

# Initialize reboot flag
$global:rebootRequired = $false

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
                          'treesizefree', 'virtualclonedrive')
    
    "Remote Access"    = @('putty', 'winscp', 'mremoteng', 
                          'filezilla', 'deluge', 'utorrent', 'openvpn')
    
    "Media"            = @('vlc', 'screamer', 'googleearth', 
                          'icloud', 'itunes')
    
    "Catalogues"       = @('calibre', 'zotero', 'keepass', 'mendeley')
    
    "Editors"          = @('foxitreader', 'notepadplusplus', 'libreoffice-still')
    
    "Development"      = @('vscode', 'git', 'tortoisegit', 'postman', 
                          'pycharm-community', 'eclipse', 'anaconda3', 'miniconda3')
    
    "Compilers"        = @('jdk11', 'jre8', 'ruby', 'golang', 'python')
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
else {
    Write-Host "`nAll packages installed successfully without reboot requirements!" -ForegroundColor Green
}

Write-Host "`nChocolatey installation completed!" -ForegroundColor Green
exit 0