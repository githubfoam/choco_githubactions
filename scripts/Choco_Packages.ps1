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
choco install --yes --no-progress --virus-check sysinternals |
    psscriptanalyzer osquery ChocolateyGUI packer |
    packer terraform vagrant virtualbox 

# Write-Host "####################################################################"
# Write-Host "###################      browsers              #####################"
# Write-Host "####################################################################"

# choco install --yes --no-progress --virus-check googlechrome firefox microsoft-edge \
#     7zip
    
# Write-Host "####################################################################"
# Write-Host "###################      tools                 #####################"
# Write-Host "####################################################################"

# choco install --yes --no-progress --virus-check 7zip etcher keepass foxitreader

# Write-Host "####################################################################"
# Write-Host "###################      build tools           #####################"
# Write-Host "####################################################################"

# choco install --yes --no-progress --virus-check ant bazel cmake git gradle |
#     maven sbt tortoisesvn

# Write-Host "####################################################################"
# Write-Host "###################      servers               #####################"
# Write-Host "####################################################################"

# choco install --yes --no-progress --virus-check apache-httpd nginx php postgresql jq julia 

# Write-Host "####################################################################"
# Write-Host "###################      cloud               #####################"
# Write-Host "####################################################################"

# choco install --yes --no-progress --virus-check kubernetes-cli kubernetes-helm Minikube docker-compose 


choco list --local-only