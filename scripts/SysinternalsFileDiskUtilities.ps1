#--------------------------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug?view=powershell-7.1
Set-PSDebug -Trace 2 #turns script debugging features on and off, sets the trace level

$VerbosePreference = "continue"
Write-Output $VerbosePreference
#--------------------------------------------------------------------------------------------------------

Write-Host "###################### whoami ######################################"

Write-Host "current user:"
Write-Host $(whoami)

whoami /all
Write-Host "################### install choco sysinternals ################################################"

# https://docs.chocolatey.org/en-us/choco/commands/install
choco install --yes --no-progress --virus-check sysinternals 

# https://docs.microsoft.com/en-us/sysinternals/downloads/file-and-disk-utilities

Write-Host "################### accesschk ################################################"

# https://docs.microsoft.com/en-us/sysinternals/downloads/accesschk
# reports the accesses that the Power Users account has to files and directories in \Windows\System32
# accesschk "power users" c:\windows\system32
# shows which Windows services members of the Users group have write access to
# accesschk users -cw *
#see what Registry keys under HKLM\CurrentUser a specific account has no access to
accesschk -kns $(whoami) hklm\software 
#see the security on the HKLM\Software key
# accesschk -k hklm\software
# see all global objects that Everyone can modify
# accesschk -wuo everyone \basednamedobjects

Write-Host "################### contig ################################################"


# # https://docs.microsoft.com/en-us/sysinternals/downloads/contig
# # https://en.wikipedia.org/wiki/Contig_(defragmentation_utility)
# # the wildcard symbol * allows whole directories and drives to be defragmented
# contig -s -accepteula C:\* 
# contig -v -s C:\*
# # for /R /D %a in (*.*) do start /b contig -q "%a" > nul
# # When the filesystem is NTFS, contig can also analyse and defragment
# contig -v -s $mft