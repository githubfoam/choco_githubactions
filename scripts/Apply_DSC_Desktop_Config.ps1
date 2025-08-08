Configuration DesktopPackages {
    # Import the necessary DSC resources
    Import-DscResource -ModuleName 'PSDscResources'
    Import-DscResource -ModuleName 'cChoco'
    
    # Define a node for the local machine
    Node 'localhost' {
        # A resource to ensure Chocolatey is installed
        # The 'Ensure' property has been removed as it is not a valid member.
        cChocoInstaller InstallChocolatey {
            InstallDir = 'C:\ProgramData\chocolatey'
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
    }
}