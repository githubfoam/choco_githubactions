#--------------------------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug?view=powershell-7.1
Set-PSDebug -Trace 2 #turns script debugging features on and off, sets the trace level

$VerbosePreference = "continue"
Write-Output $VerbosePreference
#--------------------------------------------------------------------------------------------------------

Write-Host "####################################################################"
Write-Host "###################### whoami ######################################"
Write-Host "####################################################################"

Write-Host "current user:"
Write-Host $(whoami)

whoami /all

Write-Host "####################################################################"
Write-Host "################### install choco sysinternals #####################"
Write-Host "####################################################################"

# https://docs.chocolatey.org/en-us/choco/commands/install
choco install --yes --no-progress --virus-check sysinternals 

# https://docs.microsoft.com/en-us/sysinternals/downloads/file-and-disk-utilities

Write-Host "####################################################################" -ForegroundColor red -BackgroundColor white
Write-Host "################### contig #########################################" -ForegroundColor red -BackgroundColor white
Write-Host "####################################################################" -ForegroundColor red -BackgroundColor white

# # https://docs.microsoft.com/en-us/sysinternals/downloads/contig
# # https://en.wikipedia.org/wiki/Contig_(defragmentation_utility)
# # the wildcard symbol * allows whole directories and drives to be defragmented
contig -s -accepteula C:\* 
# contig -v -s C:\*
# # When the filesystem is NTFS, contig can also analyse and defragment
contig -v -s $mft