$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"
Write-Output "Verbose logging enabled: $VerbosePreference"

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
            choco install $package --yes --no-progress --acceptlicense --limitoutput
            if ($LASTEXITCODE -ne 0) {
                throw "Chocolatey installation failed for $package (Exit code: $LASTEXITCODE)"
            }
            Write-Host "$package installed successfully" -ForegroundColor Green
        }
        catch {
            Write-Host "ERROR: $_" -ForegroundColor Red
            exit $LASTEXITCODE
        }
    }
}

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
    if ($LASTEXITCODE -ne 0) { Write-Host "Package listing completed with warnings" -ForegroundColor Yellow }
}
catch {
    Write-Host "Package listing failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nChocolatey installation completed!" -ForegroundColor Green
exit 0