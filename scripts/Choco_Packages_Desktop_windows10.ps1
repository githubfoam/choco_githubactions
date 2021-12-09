#--------------------------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug?view=powershell-7.1
Set-PSDebug -Trace 2 #turns script debugging features on and off, sets the trace level

$VerbosePreference = "continue"
Write-Output $VerbosePreference
#--------------------------------------------------------------------------------------------------------

# https://docs.chocolatey.org/en-us/choco/commands/install
choco upgrade chocolatey #Installing choco updates

Write-Host "####################################################################"
Write-Host "###################      system tools          #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check sysinternals `
    psscriptanalyzer osquery ChocolateyGUI packer `
    terraform vagrant virtualbox  vmware-powercli-psmodule

Write-Host "####################################################################"
Write-Host "###################      net tools            #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check wireshark

Write-Host "####################################################################"
Write-Host "###################      security              #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check zap burp-suite-free-edition

Write-Host "####################################################################"
Write-Host "###################      browsers              #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check googlechrome firefox `
    safari opera tor-browser
    
Write-Host "####################################################################"
Write-Host "###################      tools                 #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check 7zip etcher keepass `
    foxitreader putty rufus vlc winscp mremoteng treesizefree screamer

Write-Host "####################################################################"
Write-Host "###################      editors               #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check foxitreader projectlibre `
    notepadplusplus projectlibre

Write-Host "####################################################################"
Write-Host "###################      development           #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check pycharm vscode tortoisegit `
    postman

choco list --local-only