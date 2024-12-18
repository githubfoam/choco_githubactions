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
    terraform vagrant virtualbox  vmware-workstation-player `
    vmware-powercli-psmodule docker-desktop rvtools

Write-Host "####################################################################"
Write-Host "###################      net tools            #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check wireshark network-miner angryip advanced-ip-scanner  

Write-Host "####################################################################"
Write-Host "###################      security              #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check zap burp-suite-free-edition fiddler

Write-Host "####################################################################"
Write-Host "###################      browsers              #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check googlechrome firefox `
    safari opera tor-browser thunderbird
    
Write-Host "####################################################################"
Write-Host "###################      tools                 #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check 7zip etcher  `
    rufus treesizefree virtualclonedrive

Write-Host "####################################################################"
Write-Host "###################      remote conn           #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check putty winscp `
     mremoteng filezilla deluge utorrent openvpn   

Write-Host "####################################################################"
Write-Host "###################      visual video audio    #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check vlc screamer `
    googleearth icloud itunes


Write-Host "####################################################################"
Write-Host "###################      catalogues            #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check calibre zotero keepass

Write-Host "####################################################################"
Write-Host "###################      editors               #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check foxitreader `
    notepadplusplus libreoffice-still

Write-Host "####################################################################"
Write-Host "###################      development           #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check vscode git tortoisegit `
    postman PyCharm-community eclipse atom anaconda3 miniconda3

Write-Host "####################################################################"
Write-Host "###################      compilers             #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check jdk11 `
    ruby golang python

choco list --local-only
