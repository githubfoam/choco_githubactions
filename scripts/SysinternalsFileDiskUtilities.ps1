#--------------------------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-psdebug?view=powershell-7.1
Set-PSDebug -Trace 2 #turns script debugging features on and off, sets the trace level

$VerbosePreference = "continue"
Write-Output $VerbosePreference
#--------------------------------------------------------------------------------------------------------

# https://docs.microsoft.com/en-us/sysinternals/downloads/file-and-disk-utilities
whoami /all

# https://docs.microsoft.com/en-us/sysinternals/downloads/accesschk
accesschk "power users" c:\windows\system32
#see what Registry keys under HKLM\CurrentUser a specific account has no access to
accesschk -kns austin\mruss hklm\software 
#see the security on the HKLM\Software key
accesschk -k hklm\software
# see all global objects that Everyone can modify
accesschk -wuo everyone \basednamedobjects