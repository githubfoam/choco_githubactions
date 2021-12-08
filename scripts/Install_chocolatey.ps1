#--------------------------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug?view=powershell-7.1
Set-PSDebug -Trace 2 #turns script debugging features on and off, sets the trace level

$VerbosePreference = "continue"
Write-Output $VerbosePreference
#--------------------------------------------------------------------------------------------------------

# https://gist.github.com/githubfoam/80647016e3955c5820f8a61cc630708e
Set-ExecutionPolicy Bypass -Scope Process -Force
Get-ExecutionPolicy
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 
choco 
choco upgrade chocolatey
choco list --local-only