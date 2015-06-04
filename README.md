#IIS

[![Join the chat at https://gitter.im/matthewhatch/IIS](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/matthewhatch/IIS?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

##Cmdlets

```powershell  
Get-IISAppPool -Name TestAppPool
Get-IISAppPoolConfig -Name TestAppPool
Get-IISAppPoolCredential -Name TestAppPool
Get-IISAppPoolPassword -Name TestAppPool
```

##Installation
Option 1
- Download zip file
- Extract to c:\program files\WindowsPowershell\Modules
- Rename Directory from IIS-master to IIS

Option 2
- Fork the project
- Clone It
- Move to c:\program files\WindowsPowershell\Modules

```powershell
Import-Module IIS
```

##Usage
###Get-IISAppPool
Returns Details AppPool Configuration Data
```powershell
Get-IISAppPool -Name 'TheNameOfYourPool'
```

###Get-IISAppPoolCredential
Returns PSCredential for the AppPool Identity
```powershell
Get-IISAppPoolCredential -Name 'TheNameOfYourPool'
```

###Get-IISAppPoolConfig
Returns the Apppool Configuration as an XML Document
```powershell
Get-IISAppPoolConfig -Name 'TheNameOfYourPool'
```

###Get-IISAppPoolPassword
Returns the clear text password used for the Apppool Identity
```powershell
Get-IISAppPoolPassword -Name 'TheNameOfYourPool'
```
