<#
    .SYNOPSIS
        Create New AppPool

    .DESCRIPTION
        Creates New AppPool with provided settings; AutoStart, Managed Runtime Version, Managed Pipeline Mode,
        Start Mode, Identity Type, Credential used for the identity, Load User Profile, Enable 32 Bit

    .PARAMETER Name
        Name of the application pool to add

    .PARAMETER AutoStart
        The app pool autostart setting. Valid value are true or false, defaults to true

    .PARAMETER ManagedRunTimeVersion
        The Version of the .net Runtime. Default value is v4.0

    .PARAMETER ManagedPipelineMode
        Valid Values Integrated, Classic
    
    .PARAMETER StartMode
        Application Pool Start Mode, valid values are AlwaysRunning or OnDemand. Default is OnDemand

    .PARAMETER IdentityType
        The identity type the application pool will run as

    .PARAMETER Credential
        The Credential if the identity type is SpecificUser

    .PARAMETER LoadUserProfile
        Load User Profile setting for the app pool, Default is True

    .PARAMETER Enable32Bit
        Set the Enable 32 Bit Setting for the app pool. Default value is False

    .NOTES
        Create a better way to create apppools with custom settings
        4/3/2015 - Initial 
     
#>
Function New-IISAppPool{
    [CmdletBinding()]
    param(
            [parameter(Mandatory = $true)]
		    [System.String[]]
		    $Name,

		    [ValidateSet("true","false")]
		    [System.String]
		    $AutoStart,

		    [System.String]
		    $managedRuntimeVersion,

		    [ValidateSet("Integrated","Classic")]
		    [System.String]
		    $managedPipelineMode,

		    [ValidateSet("AlwaysRunning","OnDemand")]
		    [System.String]
		    $startMode,

		    [ValidateSet("ApplicationPoolIdentity","LocalSystem","LocalService","NetworkService","SpecificUser")]
		    [System.String]
		    $identityType,

		    [System.Management.Automation.PSCredential]
		    $Credential,

		    [ValidateSet("true","false")]
		    [System.String]
		    $loadUserProfile,

		    [ValidateSet("true","false")]
		    [System.String]
		    $Enable32Bit,

            [string]$queueLength,

            [string]$managedRuntimeLoader,

            [ValidateSet("true","false")]
            [string]$enableConfigurationOverride,

            [string]$CLRConfigFile,

            [ValidateSet("true","false")]
            [string]$passAnonymousToken,

            [ValidateSet("LogonBatch","LogonService")]
            [string]$logonType,

            [ValidateSet("true","false")]
            [string]$manualGroupMembership,

            #Format 00:20:00
            [string]$idleTimeout,

            [string]$maxProcesses,

            #Format 00:20:00
            [string]$shutdownTimeLimit,

            #Format 00:20:00
            [string]$startupTimeLimit,

            [ValidateSet("true","false")]
            [string]$pingingEnabled,

            #Format 00:20:00
            [string]$pingInterval,

            #Format 00:20:00
            [string]$pingResponseTime,

            [ValidateSet("true","false")]
            [string]$disallowOverlappingRotation,

            [ValidateSet("true","false")]
            [string]$disallowRotationOnConfigChange,

            #format "Time, Memory, PrivateMemory"
            [string]$logEventOnRecycle,

            [string]$restartMemoryLimit,

            [string]$restartPrivateMemoryLimit,

            [string]$restartRequestsLimit,

            [string]$restartTimeLimit,
        
            #Format 00:00:00 24hr clock and must have 00 for seconds
            [string[]]$restartSchedule = @(""),

            [ValidateSet("HttpLevel","TcpLevel")]
            [string]$loadBalancerCapabilities,

            [ValidateSet("true","false")]
            [string]$orphanWorkerProcess,

            [string]$orphanActionExe,

            [string]$orphanActionParams,

            [ValidateSet("true","false")]
            [string]$rapidFailProtection,

            #Format 00:20:00
            [string]$rapidFailProtectionInterval,

            [string]$rapidFailProtectionMaxCrashes,

            [string]$autoShutdownExe,

            [string]$autoShutdownParams,

            [string]$cpuLimit,

            [ValidateSet("NoAction","KillW3wp","Throttle","ThrottleUnderLoad")]
            [string]$cpuAction,

            #Format 00:20:00
            [string]$cpuResetInterval,

            [ValidateSet("true","false")]
            [string]$cpuSmpAffinitized,

            [string]$cpuSmpProcessorAffinityMask,

            [string]$cpuSmpProcessorAffinityMask2


        
    )
    $Name | Foreach {
        New-WebAppPool $_ | Out-Null

        #Stop-WebAppPool $_ 
        Set-IISAppPool @PSBoundParameters
        
    }
    

}

<#
    .SYNOPSIS
        Get application pool details

    .DESCRIPTION
        Get application pool details from a specified app pool, an array of app pools, or all application pools

    .NOTES
        Create a better more detailed result set of application pools.
        4/3/2015 - Initial
#>
Function Get-IISAppPool{
[CmdletBinding()]
	param
	(
		[System.String[]]
		$Name
	)
 
    # if no Apppool name is passed get all apppools
    if(!($PSBoundParameters.ContainsKey('Name'))){$Name = Get-ChildItem iis:\apppools | Select-Object -ExpandProperty Name}

    $Name | Foreach {
        $AppPools = & $env:SystemRoot\system32\inetsrv\appcmd.exe list apppool $_

        if (-not($AppPools -match $_)) # No AppPool exists with this name.
        {
            $errorId = "AppPoolDiscoveryFailure"
            $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidResult
            $errorMessage = "AppPool $Name not found"
            $exception = New-Object System.InvalidOperationException $errorMessage 
            $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $errorCategory, $null

            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }
      
        [xml]$PoolConfig = & $env:SystemRoot\system32\inetsrv\appcmd.exe list apppool $_ /config:*
        if($PoolConfig.add.processModel.userName){
            $AppPoolPassword = $PoolConfig.add.processModel.password | ConvertTo-SecureString -AsPlainText -Force
            $AppPoolCred = new-object -typename System.Management.Automation.PSCredential -argumentlist $PoolConfig.add.processModel.userName,$AppPoolPassword   
        }else{
            $AppPoolCred = $null
        }
        
        $properties = @{
            Name = $PoolConfig.add.name 
            autoStart = $PoolConfig.add.autoStart
            managedRuntimeVersion = $PoolConfig.add.managedRuntimeVersion
            managedPipelineMode = $PoolConfig.add.managedPipelineMode
            startMode = $PoolConfig.add.startMode
            identityType = $PoolConfig.add.processModel.identityType
            userName = $PoolConfig.add.processModel.userName
            password = $AppPoolCred
            loadUserProfile = $PoolConfig.add.processModel.loadUserProfile
            Enable32Bit = $PoolConfig.Add.Enable32BitAppOnWin64
            queueLength = $PoolConfig.add.queueLength
            managedRuntimeLoader = $PoolConfig.add.managedRuntimeLoader
            enableConfigurationOverride = $PoolConfig.add.enableConfigurationOverride
            CLRConfigFile = $PoolConfig.add.CLRConfigFile
            passAnonymousToken = $PoolConfig.add.passAnonymousToken
            logonType = $PoolConfig.add.processModel.logonType
            manualGroupMembership = $PoolConfig.add.processModel.manualGroupMembership
            idleTimeout = $PoolConfig.add.processModel.idleTimeout
            maxProcesses = $PoolConfig.add.processModel.maxProcesses
            shutdownTimeLimit = $PoolConfig.add.processModel.shutdownTimeLimit
            startupTimeLimit = $PoolConfig.add.processModel.startupTimeLimit
            pingingEnabled = $PoolConfig.add.processModel.pingingEnabled
            pingInterval = $PoolConfig.add.processModel.pingInterval
            pingResponseTime = $PoolConfig.add.processModel.pingResponseTime
            disallowOverlappingRotation = $PoolConfig.add.recycling.disallowOverlappingRotation
            disallowRotationOnConfigChange = $PoolConfig.add.recycling.disallowRotationOnConfigChange
            logEventOnRecycle = $PoolConfig.add.recycling.logEventOnRecycle
            restartMemoryLimit = $PoolConfig.add.recycling.periodicRestart.memory
            restartPrivateMemoryLimit = $PoolConfig.add.recycling.periodicRestart.privateMemory
            restartRequestsLimit = $PoolConfig.add.recycling.periodicRestart.requests
            restartTimeLimit = $PoolConfig.add.recycling.periodicRestart.time
            restartSchedule = $PoolConfig.add.recycling.periodicRestart.schedule
            loadBalancerCapabilities = $PoolConfig.add.failure.loadBalancerCapabilities
            orphanWorkerProcess = $PoolConfig.add.failure.orphanWorkerProcess
            orphanActionExe = $PoolConfig.add.failure.orphanActionExe
            orphanActionParams = $PoolConfig.add.failure.orphanActionParams
            rapidFailProtection = $PoolConfig.add.failure.rapidFailProtection
            rapidFailProtectionInterval = $PoolConfig.add.failure.rapidFailProtectionInterval
            rapidFailProtectionMaxCrashes = $PoolConfig.add.failure.rapidFailProtectionMaxCrashes
            autoShutdownExe = $PoolConfig.add.failure.autoShutdownExe
            autoShutdownParams = $PoolConfig.add.failure.autoShutdownParams
            cpuLimit = $PoolConfig.add.cpu.limit
            cpuAction = $PoolConfig.add.cpu.action
            cpuResetInterval = $PoolConfig.add.cpu.resetInterval
            cpuSmpAffinitized = $PoolConfig.add.cpu.smpAffinitized
            cpuSmpProcessorAffinityMask = $PoolConfig.add.cpu.smpProcessorAffinityMask
            cpuSmpProcessorAffinityMask2 = $PoolConfig.add.cpu.smpProcessorAffinityMask2

        }
        
        Write-Output (New-Object -TypeName PSOBject -Property $properties)
    }
    
}
<#
    .SYNOPIS
        Updates settings for an apppool

    .DESCRIPTION
        Updates the specific setting or settings for an apppool thats passed to Name parameter.
    
    .PARAMETER Name
        Name of the application pool to add

    .PARAMETER AutoStart
        The app pool autostart setting. Valid value are true or false, defaults to true

    .PARAMETER ManagedRunTimeVersion
        The Version of the .net Runtime. Default value is v4.0

    .PARAMETER ManagedPipelineMode
        Valid Values Integrated, Classic
    
    .PARAMETER StartMode
        Application Pool Start Mode, valid values are AlwaysRunning or OnDemand. Default is OnDemand

    .PARAMETER IdentityType
        The identity type the application pool will run as

    .PARAMETER Credential
        The Credential if the identity type is SpecificUser

    .PARAMETER LoadUserProfile
        Load User Profile setting for the app pool, Default is True

    .PARAMETER Enable32Bit
        Set the Enable 32 Bit Setting for the app pool. Default value is False

    .Notes
        Looking to create Cmdlet to update settings of an existing apppool
        4/3/2015 - Initial 
#>
Function Set-IISAppPool{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
            [parameter(Mandatory = $true)]
		    [System.String[]]
		    $Name,

		    [ValidateSet("true","false")]
		    [System.String]
		    $AutoStart,

		    [System.String]
		    $managedRuntimeVersion,

		    [ValidateSet("Integrated","Classic")]
		    [System.String]
		    $managedPipelineMode,

		    [ValidateSet("AlwaysRunning","OnDemand")]
		    [System.String]
		    $startMode,

		    [ValidateSet("ApplicationPoolIdentity","LocalSystem","LocalService","NetworkService","SpecificUser")]
		    [System.String]
		    $identityType,

		    [System.Management.Automation.PSCredential]
		    $Credential,

		    [ValidateSet("true","false")]
		    [System.String]
		    $loadUserProfile,

		    [ValidateSet("true","false")]
		    [System.String]
		    $Enable32Bit,

            [string]$queueLength = "1000",

            [string]$managedRuntimeLoader = "webengine4.dll",

            [ValidateSet("true","false")]
            [string]$enableConfigurationOverride = "true",

            [string]$CLRConfigFile = "",

            [ValidateSet("true","false")]
            [string]$passAnonymousToken = "true",

            [ValidateSet("LogonBatch","LogonService")]
            [string]$logonType = "LogonBatch",

            [ValidateSet("true","false")]
            [string]$manualGroupMembership = "false",

            #Format 00:20:00
            [string]$idleTimeout = "00:20:00",

            [string]$maxProcesses = "1",

            #Format 00:20:00
            [string]$shutdownTimeLimit = "00:01:30",

            #Format 00:20:00
            [string]$startupTimeLimit = "00:01:30",

            [ValidateSet("true","false")]
            [string]$pingingEnabled = "true",

            #Format 00:20:00
            [string]$pingInterval = "00:00:30",

            #Format 00:20:00
            [string]$pingResponseTime = "00:01:30",

            [ValidateSet("true","false")]
            [string]$disallowOverlappingRotation = "false",

            [ValidateSet("true","false")]
            [string]$disallowRotationOnConfigChange = "false",

            #format "Time, Memory, PrivateMemory"
            [string]$logEventOnRecycle = "Time, Memory, PrivateMemory",

            [string]$restartMemoryLimit = "0",

            [string]$restartPrivateMemoryLimit = "0",

            [string]$restartRequestsLimit = "0",

            [string]$restartTimeLimit = "1.05:00:00",
        
            #Format 00:00:00 24hr clock and must have 00 for seconds
            [string[]]$restartSchedule = @(""),

            [ValidateSet("HttpLevel","TcpLevel")]
            [string]$loadBalancerCapabilities = "HttpLevel",

            [ValidateSet("true","false")]
            [string]$orphanWorkerProcess = "false",

            [string]$orphanActionExe = "",

            [string]$orphanActionParams = "",

            [ValidateSet("true","false")]
            [string]$rapidFailProtection = "true",

            #Format 00:20:00
            [string]$rapidFailProtectionInterval = "00:05:00",

            [string]$rapidFailProtectionMaxCrashes = "5",

            [string]$autoShutdownExe = "",

            [string]$autoShutdownParams = "",

            [string]$cpuLimit = "0",

            [ValidateSet("NoAction","KillW3wp","Throttle","ThrottleUnderLoad")]
            [string]$cpuAction = "NoAction",

            #Format 00:20:00
            [string]$cpuResetInterval = "00:05:00",

            [ValidateSet("true","false")]
            [string]$cpuSmpAffinitized = "false",

            [string]$cpuSmpProcessorAffinityMask = "4294967295",

            [string]$cpuSmpProcessorAffinityMask2 = "4294967295"

    )

    $Name | Foreach {
        if($PSBoundParameters.ContainsKey('AutoStart')){
            Write-Verbose "Setting autostart to $AutoStart"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /autoStart:$autoStart | Out-Null
        }

        if($PSBoundParameters.ContainsKey('ManagedRuntimeVersion')){
            Write-Verbose "Setting Managed Runtime Version $managedRuntimeVersion"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /managedRuntimeVersion:$managedRuntimeVersion | Out-Null    
        }

        if($PSBoundParameters.ContainsKey('ManagedPipelineMode')){
            Write-Verbose "Setting Managed Pipeline Mode $managedPipelineMode"        
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /managedPipelineMode:$managedPipelineMode | Out-Null
        }

        if($PSBoundParameters.ContainsKey('StartMode')){       
            Write-Verbose "Setting Start Mode to $startMode"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /startMode:$startMode | Out-Null
        }  
        
        if($PSBoundParameters.ContainsKey('IdentityType')){
            Write-Verbose "Setting Identity Type to $identityType"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.identityType:$identityType | Out-Null    
        }
        
        if($PSBoundParameters.ContainsKey('Credential')){
            
            #if Credential is passed then we'll change the IdentityType to Specific User
            Write-Verbose "Setting Identity Type to SpecificUser"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.identityType:SpecificUser | Out-Null    
            
            $userName = ($Credential.UserName)
            Write-Verbose "Setting User Name to $($Credential.UserName)"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.userName:$userName | Out-Null

            $clearTextPassword = $Credential.GetNetworkCredential().Password
            Write-Verbose "Setting password $clearTextPassword"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.password:$clearTextPassword | Out-Null
                
        }
        
        if($PSBoundParameters.ContainsKey('LoadUserProfile')){        
            Write-Verbose "Setting Load User Profile to $loadUserProfile"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.loadUserProfile:$loadUserProfile | Out-Null
        }
        
        if($PSBoundParameters.ContainsKey('Enable32Bit')){        
            Write-Verbose "Setting Enable32Bit to $Enable32Bit"
            & $env:SystemRoot\System32\inetsrv\appcmd.exe set apppool $_ /enable32BitAppOnWin64:$Enable32Bit | Out-Null  
        }

        if($PSBoundParameters.ContainsKey('queueLength')){
            Write-Verbose "Setting the queueLength to $queueLength"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /queueLength:$queueLength | Out-Null
        }

        If($PSBoundParameters.ContainsKey('managedRuntimeLoader')){
            Write-Verbose "Setting managedRuntimeloader to $managedRuntimeLoader"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /managedRuntimeLoader:$managedRuntimeLoader | Out-Null
        }

        If($PSBoundParameters.ContainsKey('enableConfigurationOverride')){
            Write-Verbose "Setting enableConfigurationOverride to $enableConfigurationOverride"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /enableConfigurationOverride:$enableConfigurationOverride | Out-Null
        }

        If($PSBoundParameters.ContainsKey('CLRConfigFile')){
            Write-Verbose "Setting CLRConfigFile to $CLRConfigFile"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /CLRConfigFile:$CLRConfigFile | Out-Null
        }

        If($PSBoundParameters.ContainsKey('passAnonymousToken')){
            Write-Verbose "Setting passAnonymousToken to $passAnonymousToken"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /passAnonymousToken:$passAnonymousToken | Out-Null
        }

        If($PSBoundParameters.ContainsKey('logonType')){
            Write-Verbose "Setting the logonType to $logonType"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.logonType:$logonType | Out-Null
        }

        If($PSBoundParameters.ContainsKey('manualGroupMembership')){
            Write-Verbose "Setting manualGroupMembership to $manualGroupMembership"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.manualGroupMembership:$manualGroupMembership
        }

        If($PSBoundParameters.ContainsKey('idleTimeout')){
            Write-Verbose "Setting idleTimeout to $idleTimeout"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.idleTimeout:$idleTimeout
        }
        
        If($PSBoundParameters.ContainsKey('maxProcesses')){
            Write-Verbose "Setting maxProcesses to $maxProcesses"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.maxProcesses:$maxProcesses
        }

        If($PSBoundParameters.ContainsKey('shutdownTimeLimit')){
            Write-Verbose "Setting shutdownTimeLimit to $shutdownTimeLimit"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.shutdownTimeLimit:$shutdownTimeLimit
        }

        If($PSBoundParameters.ContainsKey('startupTimeLimit')){
            Write-Verbose "Setting startupTimeLimit to $startupTimeLimit"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.startupTimeLimit:$startupTimeLimit
        }

        If($PSBoundParameters.ContainsKey('pingingEnabled')){
            Write-Verbose "Setting pingingEnabled to $pingingEnabled"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.pingingEnabled:$pingingEnabled
        }

        If($PSBoundParameters.ContainsKey('pingInterval')){
            Write-Verbose "Setting pingInterval to $pingInterval"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.pingInterval:$pingInterval
        }

        If($PSBoundParameters.ContainsKey('pingResponseTime')){
            Write-Verbose "Setting pingResponseTime to $pingResponseTime"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /processModel.pingResponseTime:$pingResponseTime
        }

        If($PSBoundParameters.ContainsKey('disallowOverlappingRotation')){
            Write-Verbose "Setting disallowOverlappingRotation  to $disallowOverlappingRotation "
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /recycling.disallowOverlappingRotation:$disallowOverlappingRotation 
        }

        If($PSBoundParameters.ContainsKey('disallowRotationOnConfigChange')){
            Write-Verbose "Setting disallowRotationOnConfigChange to $disallowRotationOnConfigChange"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /recycling.disallowRotationOnConfigChange:$disallowRotationOnConfigChange
        }

        If($PSBoundParameters.ContainsKey('logEventOnRecycle')){
            Write-Verbose "Setting logEventOnRecycle to $logEventOnRecycle"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /recycling.logEventOnRecycle:$logEventOnRecycle
        }

        If($PSBoundParameters.ContainsKey('restartMemoryLimit')){
            Write-Verbose "Setting restartMemoryLimit to $restartMemoryLimit"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /recycling.periodicRestart.memory:$restartMemoryLimit
        }

        If($PSBoundParameters.ContainsKey('restartPrivateMemoryLimit')){
            Write-Verbose "Setting restartPrivateMemoryLimit to $restartPrivateMemoryLimit"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /recycling.periodicRestart.privateMemory:$restartPrivateMemoryLimit
        }

        If($PSBoundParameters.ContainsKey('restartRequestsLimit')){
            Write-Verbose "Setting restartRequestsLimit to $restartRequestsLimit"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /recycling.periodicRestart.requests:$restartRequestsLimit
        }

        If($PSBoundParameters.ContainsKey('restartTimeLimit')){
            Write-Verbose "Setting restartTimeLimit to $restartTimeLimit"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /recycling.periodicRestart.time:$restartTimeLimit
        }

        If($PSBoundParameters.ContainsKey('restartSchedule')){
            foreach($time in $restartSchedule)
            {
                & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ "/+recycling.periodicRestart.schedule.[value='$time']"                
            }
        }
        
        If($PSBoundParameters.ContainsKey('loadBalancerCapabilities')){
            Write-Verbose "Setting loadBalancerCapabilities to $loadBalancerCapabilities"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /failure.loadBalancerCapabilities:$loadBalancerCapabilities
        }

        If($PSBoundParameters.ContainsKey('orphanWorkerProcess')){
            Write-Verbose "Setting orphanWorkerProcess to $orphanWorkerProcess"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /failure.orphanWorkerProcess:$orphanWorkerProcess
        }

        If($PSBoundParameters.ContainsKey('OrphanActionExe')){
            Write-Verbose "Setting orphanWorkerProcess to $orphanWorkerProcess"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_ /failure.orphanActionExe:$orphanActionExe
        }

        
        If ($PSBoundParameters.ContainsKey('orphanActionParams')){
             Write-Verbose "Setting orphanActionParams to $orphanActionParams"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /failure.orphanActionParams:$orphanActionParams
        }

        If ($PSBoundParameters.ContainsKey('rapidFailProtection')){
             Write-Verbose "Setting rapidFailProtection to $rapidFailProtection"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /failure.rapidFailProtection:$rapidFailProtection
        }

        If ($PSBoundParameters.ContainsKey('rapidFailProtectionInterval')){
             Write-Verbose "Setting rapidFailProtectionInterval to $rapidFailProtectionInterval"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /failure.rapidFailProtectionInterval:$rapidFailProtectionInterval
        }

        If ($PSBoundParameters.ContainsKey('rapidFailProtectionMaxCrashes')){
             Write-Verbose "Setting rapidFailProtectionMaxCrashes to $rapidFailProtectionMaxCrashes"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /failure.rapidFailProtectionMaxCrashes:$rapidFailProtectionMaxCrashes
        }

        If ($PSBoundParameters.ContainsKey('autoShutdownExe')){
             Write-Verbose "Setting autoShutdownExe to $autoShutdownExe"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /failure.autoShutdownExe:$autoShutdownExe
        }

        If ($PSBoundParameters.ContainsKey('autoShutdownParams')){
             Write-Verbose "Setting autoShutdownParams to $autoShutdownParams"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /failure.autoShutdownParams:$autoShutdownParams
        }

        If ($PSBoundParameters.ContainsKey('cpuLimit')){
             Write-Verbose "Setting cpuLimit to $cpuLimit"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /cpu.limit:$cpuLimit
        }

        If ($PSBoundParameters.ContainsKey('cpuAction')){
             Write-Verbose "Setting cpuAction to $cpuAction"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /cpu.action:$cpuAction
        }

        If ($PSBoundParameters.ContainsKey('cpuResetInterval')){
             Write-Verbose "Setting cpuResetInterval to $cpuResetInterval"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /cpu.resetInterval:$cpuResetInterval
        }

        If ($PSBoundParameters.ContainsKey('cpuSmpAffinitized')){
             Write-Verbose "Setting cpuSmpAffinitized to $cpuSmpAffinitized"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /cpu.smpAffinitized:$cpuSmpAffinitized
        }

        If ($PSBoundParameters.ContainsKey('cpuSmpProcessorAffinityMask')){
             Write-Verbose "Setting cpuSmpProcessorAffinityMask to $cpuSmpProcessorAffinityMask"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /cpu.smpProcessorAffinityMask:$cpuSmpProcessorAffinityMask
        }

         If ($PSBoundParameters.ContainsKey('cpuSmpProcessorAffinityMask2')){
             Write-Verbose "Setting cpuSmpProcessorAffinityMask2 to $cpuSmpProcessorAffinityMask2"
            & $env:SystemRoot\system32\inetsrv\appcmd.exe set apppool $_  /cpu.smpProcessorAffinityMask2:$cpuSmpProcessorAffinityMask2
        }
    }
    
}
<#
    .SYNOPSIS
        Returns a PSCredential object representaion of the AppPool Identity

    .DESCRIPTION
        Returns a PSCredential object representaion of the AppPool Identity. If there is no Identity set it will return $null

    .PARAMETER Name
        Name of the AppPool
#>
Function Get-IISAppPoolCredential{
    [CmdletBinding()]
    param(
        [System.String[]]
        $Name
    )
    
    $Name | Foreach{
        $PoolConfig = Get-IISAppPoolConfig -Name $_

        if($PoolConfig.add.processModel.userName){
            $AppPoolPassword = $PoolConfig.add.processModel.password | ConvertTo-SecureString -AsPlainText -Force
            $AppPoolCred = new-object -typename System.Management.Automation.PSCredential -argumentlist $PoolConfig.add.processModel.userName,$AppPoolPassword   
        }else{
            $AppPoolCred = $null
        }

        Write-Output $AppPoolCred
    }
    
}

<#
    .SYNOPSIS
        Returns palintext password configured for the apppool Identity

    .DESCRIPTION

    .PARAMETER Name
        Name of the AppPool

#>
Function Get-IISAppPoolPassword{
    [CmdletBinding()]
    param(
        [System.String]
        $Name
    )

    $PoolConfig = Get-IISAppPoolConfig -Name $Name
    $PoolConfig.add.processModel.password
}


<#
    .SYNOPSIS
        Returns the AppPoolConfig as an XML Document Object

    .PARAMETER Name 
        Name of the AppPool
#>
Function Get-IISAppPoolConfig{
    [CmdletBinding()]
    param(
        [System.String]
        $Name
    )
    
    [xml]$PoolConfig = & $env:SystemRoot\system32\inetsrv\appcmd.exe list apppool $Name /config:*
    Write-Output $PoolConfig
}