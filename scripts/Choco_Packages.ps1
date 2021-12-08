#--------------------------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug?view=powershell-7.1
Set-PSDebug -Trace 2 #turns script debugging features on and off, sets the trace level

$VerbosePreference = "continue"
Write-Output $VerbosePreference
#--------------------------------------------------------------------------------------------------------

# https://docs.chocolatey.org/en-us/choco/commands/install
choco upgrade chocolatey #Installing choco updates

choco install --yes --no-progress --virus-check sysinternals psscriptanalyzer osquery ChocolateyGUI packer keepass 

choco install --yes --no-progress --virus-check googlechrome microsoft-edge 7zip

choco install --yes --no-progress --virus-check ant bazel cmake git gradle maven sbt tortoisesvn

choco install --yes --no-progress --virus-check apache-httpd nginx php postgresql jq julia 

choco install --yes --no-progress --virus-check kubernetes-cli kubernetes-helm Minikube docker-compose 

choco install --yes --no-progress --virus-check packer terraform vagrant virtualbox

choco upgrade vagrant #Upgrade software with choco

choco list --local-only