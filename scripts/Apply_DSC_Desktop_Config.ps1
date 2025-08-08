Configuration DesktopPackages {
    # Import the necessary DSC resources
    Import-DscResource -ModuleName 'PSDscResources'
    Import-DscResource -ModuleName 'cChoco'
    
    # Define a node for the local machine
    Node 'localhost' {
        # A resource to ensure Chocolatey is installed
        cChocoInstaller InstallChocolatey {
            Ensure = 'Present'
        }

        # A resource to install multiple packages using cChoco
        cChocoPackageInstallerSet InstallTools {
            DependsOn = '[cChocoInstaller]InstallChocolatey'
            Name = @('sysinternals', 'git', 'notepadplusplus', '7zip')
            Ensure = 'Present'
        }

        # Another resource for a different set of packages
        cChocoPackageInstallerSet InstallBrowsers {
            DependsOn = '[cChocoInstaller]InstallChocolatey'
            Name = @('googlechrome', 'firefox')
            Ensure = 'Present'
        }
        
        # Example of installing an MSI package directly
        # You would need to provide the path to the MSI and the ProductId
        # Package LibreOffice {
        #    Name = 'libreoffice'
        #    Path = 'C:\path\to\libreoffice.msi'
        #    ProductId = 'PRODUCT-ID-GUID'
        #    Ensure = 'Present'
        # }
    }
}