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
    vmware-powercli-psmodule docker-desktop

Write-Host "####################################################################"
Write-Host "###################      net tools            #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check wireshark winpcap

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

choco install --yes --no-progress --virus-check 7zip etcher  `
    rufus treesizefree skype  virtualclonedrive thunderbird

Write-Host "####################################################################"
Write-Host "###################      remote conn           #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check putty winscp `
     mremoteng filezilla deluge openvpn wget  

Write-Host "####################################################################"
Write-Host "###################      visual video audio    #####################"
Write-Host "####################################################################"
choco install --yes --no-progress --virus-check vlc screamer googleearth freemind `


Write-Host "####################################################################"
Write-Host "###################      catalogues            #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check calibre zotero keepass mendeley

Write-Host "####################################################################"
Write-Host "###################      editors               #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check foxitreader libreoffice-still `
    notepadplusplus 

Write-Host "####################################################################"
Write-Host "###################      development           #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check vscode git tortoisegit `
    postman PyCharm-community eclipse atom python

Write-Host "####################################################################"
Write-Host "###################      compilers             #####################"
Write-Host "####################################################################"

choco install --yes --no-progress --virus-check jdk11 `
    ruby golang python
#Chocolatey v2.3.0
#Invalid argument --local-only. This argument has been removed from the list command and cannot be used.
#choco list --local-only
