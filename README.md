#IIS

[![Build status](https://ci.appveyor.com/api/projects/status/uy8wcyj44iwmxi7o/branch/master?svg=true)](https://ci.appveyor.com/project/matthewhatch/iis/branch/master)

[![Join the chat at https://gitter.im/matthewhatch/IIS](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/matthewhatch/IIS?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

##Cmdlets

```powershell  
Get-IISAppPool
Get-IISAppPoolConfig
Get-IISAppPoolCredential
Get-IISAppPoolPassword
New-IISAppPool
Set-IISAppPool
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

###New-IISAppPool
Adds a new Application Pool, if no parameters are passed then the apppool is created with the deault settings

```powershell
New-IISAppPool -Name 'SomeAppPool' -Enable32Bit $true
```

Available settings to pass as parameters

* autoStart
* managedRuntimeVersion
* managedPipelineMode
* startMode
* identityType
* userName
* password
* loadUserProfile
* Enable32Bit
* queueLength
* managedRuntimeLoader
* enableConfigurationOverride
* CLRConfigFile
* passAnonymousToken
* logonType
* manualGroupMembership
* idleTimeout
* maxProcesses
* shutdownTimeLimit
* startupTimeLimit
* pingingEnabled
* pingInterval
* pingResponseTime
* disallowOverlappingRotation
* disallowRotationOnConfigChange
* logEventOnRecycle
* restartMemoryLimit
* restartPrivateMemoryLimit
* restartRequestsLimit
* restartTimeLimit
* restartSchedule
* loadBalancerCapabilities
* orphanWorkerProcess
* orphanActionExe
* orphanActionParams
* rapidFailProtection
* rapidFailProtectionInterval
* rapidFailProtectionMaxCrashes
* autoShutdownExe
* autoShutdownParams
* cpuLimit
* cpuAction
* cpuResetInterval
* cpuSmpAffinitized
* cpuSmpProcessorAffinityMask
* cpuSmpProcessorAffinityMask2

###Set-IISAppPool

```powershell
Set-IISAppPool -Name 'SomeAppPool' -maxProcesses 10
```
