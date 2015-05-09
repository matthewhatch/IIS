Import-Module IIS -Force

New-IISAppPool -Name Pester

Describe 'New-IISAppPool' {
    
    $Pool = Get-IISAppPool -Name Pester
    
    Context 'AppPool Properties for default settings'{
        
        It 'Should have a Name property of Pester'{
            $Pool.Name | Should Be 'Pester'
        }

        It 'Should have an autostart property equal to true'{
            $Pool.autostart | Should Be 'True'
        }

        It 'Should have a managedRuntime property equal to v2.0'{
            $Pool.managedRuntimeVersion | Should Be 'v2.0'
        }

        It 'Should have a managedPipelinemode property equal to Integrated'{
            $Pool.managedPipelinemode | Should Be 'Integrated'
        }

        It 'Should have a startMode property equal to OnDemand'{
            $Pool.StartMode | Should Be 'OnDemand'
        }

        It 'Should have an IdentityType property equal to ApplicationPoolIdentity'{
            $Pool.IdentityType | Should Be 'ApplicationPoolIdentity'
        }

        It 'Should have a Credential that is null' {
            $Pool.Credential | Should Be $null
        }

        It 'Should have LoadUserProfile set to true'{
            $Pool.LoadUserProfile | Should Be 'true'
        }

        It 'Should have Enable32Bit Set to false' {
            $Pool.Enable32Bit | Should Be 'false'
        }

        It 'Should have queueLength set to 1000'{
            $pool.queueLength | Should Be '1000'
        }

        It 'Should have managedRuntimeLoader set to webengine4.dll'{
            $Pool.managedRuntimeLoader | Should Be 'webengine4.dll'
        }

        It 'Should have enableConfigurationOverride set to true' {
            $Pool.enableConfigurationOverride | Should Be 'true'
        }

        It 'Should have CLRConfigFile should be empty'{
            $Pool.CLRConfigFile | Should Be ""
        }

        It 'Should have passAnonymousToken set to true'{
            $pool.passAnonymousToken | Should Be 'true'
        }

        It 'Should have logonType set to LogonBatch'{
            $pool.logonType | Should Be 'LogonBatch'
        }

        It 'Should have manualGroupMembership set to false' {
            $pool.manualGroupMembership | Should Be 'false'
        }

        It 'Should have $idleTimeout set to 00:20:00'{
            $pool.idleTimeout | Should Be '00:20:00'
        }

        It 'Should have maxProcesses set to 1'{
            $pool.maxProcesses | Should Be '1'
        }

        It 'Should have shutdownTimeLimit set to 00:01:30'{
            $pool.shutdownTimeLimit | Should Be "00:01:30"
        }

        It 'Should have startupTimeLimit set to 00:01:30' {
            $pool.startupTimeLimit | Should Be '00:01:30'
        }

        It 'Should have pingingEnabled set to true' {
            $pool.pingingEnabled | Should be 'true'
        }

        It 'Should have pingInterval set to 00:00:30'{
            $pool.pingInterval | Should Be '00:00:30'
        }

        It 'Should have pingResponseTime set to 00:01:30'{
            $pool.pingResponseTime | Should Be '00:01:30'
        }

        It 'Should have disallowOverlappingRotation set to false'{
            $pool.disallowOverlappingRotation | Should Be 'false'
        }

        It 'Should have disallowRotationOnConfigChange set to false'{
            $pool.disallowRotationOnConfigChange | Should Be 'false'
        }

        It 'Should have logEventOnRecycle set to "Time, Memory, PrivateMemory"'{
            $pool.logEventOnRecycle | Should be "Time, Memory, PrivateMemory"
        }

        It 'Should have restartMemoryLimit set to 0'{
            $pool.restartMemoryLimit | Should Be '0'
        }

        It 'Should have restartPrivateMemoryLimit set to 0'{
            $pool.restartPrivateMemoryLimit | Should Be '0'
        }

        It 'Should have restartRequestsLimit set to 0'{
            $pool.restartRequestsLimit | Should Be '0'
        }

        It 'Should have restartTimeLimit set to 1.05:00:00'{
            $pool.restartTimeLimit | Should Be '1.05:00:00'
        }

        It 'Should have restartSchedule set to empty'{
            $pool.restartSchedule | Should Be ""
        }

        It 'Should have loadBalancerCapabilities set to HttpLevel'{
            $pool.loadBalancerCapabilities | Should Be 'HttpLevel'
        }

        It 'Should have orphanWorkerProcess set to false'{
            $pool.orphanWorkerProcess | Should Be 'false'
        }

        It 'Should have orphanActionExe set to empty'{
            $pool.orphanActionExe | Should Be ''
        }

        It 'Should have orphanActionParams set to empty'{
            $pool.orphanActionParams | Should Be ''
        }

        It 'Should have rapidFailProtection set to true'{
            $pool.rapidFailProtection | Should Be 'true'
        }

        It 'Should have rapidFailProtectionInterval set to 00:05:00'{
            $pool.rapidFailProtectionInterval | Should Be '00:05:00'
        }

        It 'Should have rapidFailProtectionMaxCrashes set to 5'{
            $Pool.rapidFailProtectionMaxCrashes | Should Be '5'
        }

        It 'Should have autoShutdownExe set to empty'{
            $Pool.autoShutdownExe | Should Be ''
        }

        It 'Should have autoShutdownParams set to empty'{
            $Pool.autoShutdownParams | Should Be ''
        }

        It 'Should have cpuLimit set to 0'{
            $Pool.cpuLimit | Should Be '0'
        }

        It 'Should have cpuAction set to NoAction'{
            $Pool.cpuAction | Should Be 'NoAction'
        }

        It 'Should have cpuResetInterval set to 00:05:00'{
            $Pool.cpuResetInterval | Should Be '00:05:00'
        }

        It 'Should have cpuSmpAffinitized set to false'{
            $pool.cpuSmpAffinitized | Should Be 'false'
        }

        It 'Should have cpuSmpProcessorAffinityMask set to 4294967295'{
            $pool.cpuSmpProcessorAffinityMask | Should Be '4294967295'
        }

        It 'Should have cpuSmpProcessorAffinityMask2 set to 4294967295'{
            $pool.cpuSmpProcessorAffinityMask2 | Should Be '4294967295'
        }
    }

    Context 'passing custom parameters'{
        AfterEach {
            Remove-Item IIS:\AppPools\Pester40 -Force -Recurse    
        }
        It 'Should create a new apppool with managedRuntimeVersion set to v4.0'{
            New-IISAppPool -Name Pester40 -managedRuntimeVersion 'v4.0'
            (Get-IISAppPool -Name Pester40).managedRuntimeVersion | Should Be 'v4.0'
        }

        It 'Should create a new apppool with autostart set to false'{
            New-IISAppPool -Name Pester40 -AutoStart false
            (Get-IISAppPool -Name Pester40).AutoStart | Should Be 'false'
        }

        It 'Should create a new apppool with managedPipelineMode set to Classic'{
            New-IISAppPool -Name Pester40 -managedPipelineMode Classic
            (Get-IISAppPool -Name Pester40).managedPipelineMode | Should Be 'Classic'  
        }

        It 'Should create a new apppool with startMode set to AlwaysRunning'{
            New-IISAppPool -Name Pester40 -startMode AlwaysRunning
            (Get-IISAppPool -Name Pester40).startMode | Should Be 'AlwaysRunning'
        }

        It 'Should create a new apppool with IdentityType set to LocalSystem'{
            New-IISAppPool -Name Pester40 -identityType LocalSystem
            (Get-IISAppPool -Name Pester40).identityType | Should Be 'LocalSystem'
        }
        
        It 'Should create a new apppool with IdentityType set to LocalService'{
            New-IISAppPool -Name Pester40 -identityType LocalService
            (Get-IISAppPool -Name Pester40).identityType | Should Be 'LocalService'
        }

        It 'Should create a new apppool with IdentityType set to NetworkService'{
            New-IISAppPool -Name Pester40 -identityType NetworkService
            (Get-IISAppPool -Name Pester40).identityType | Should Be 'NetworkService'
        }

        It 'Should create a new apppool with loadUserProfile set to false' {
            New-IISAppPool -Name Pester40 -loadUserProfile false
            (Get-IISAppPool -Name Pester40).loadUserProfile | Should Be 'false'
        }

        It 'Should create a new apppool with Enable32Bit set to true' {
            New-IISAppPool -Name Pester40 -Enable32Bit true
            (Get-IISAppPool -Name Pester40).Enable32Bit | Should Be 'true'
        }

        It 'Should create a new apppool with queueLength set to 1111' {
            New-IISAppPool -Name Pester40 -queueLength 1111
            (Get-IISAppPool -Name Pester40).queueLength | Should Be '1111'
        }

        It 'Should create a new apppool with managedRuntimeLoader set to testEngine.dll' {
            New-IISAppPool -Name Pester40 -managedRuntimeLoader testEngine.dll
            (Get-IISAppPool -Name Pester40).managedRuntimeLoader | Should Be 'testEngine.dll'
        }

        It 'Should create a new apppool with enableConfigurationOverride set to false' {
            New-IISAppPool -Name Pester40 -enableConfigurationOverride 'false'
            (Get-IISAppPool -Name Pester40).enableConfigurationOverride | Should Be 'false'
        }

        It 'Should create a new apppool with CLRConfigFile set to test.config' {
            New-IISAppPool -Name Pester40 -CLRConfigFile 'test.config'
            (Get-IISAppPool -Name Pester40).CLRConfigFile | Should Be 'test.config'
        }

        It 'Should create a new apppool with passAnonymousToken set to false' {
            New-IISAppPool -Name Pester40 -passAnonymousToken 'false'
            (Get-IISAppPool -Name Pester40).passAnonymousToken | Should Be 'false'
        }

        It 'Should create a new apppool with logonType set to LogonService' {
            New-IISAppPool -Name Pester40 -logonType 'LogonService'
            (Get-IISAppPool -Name Pester40).logonType | Should Be 'LogonService'
        }

        It 'Should create a new apppool with manualGroupMembership set to true' {
            New-IISAppPool -Name Pester40 -manualGroupMembership 'true'
            (Get-IISAppPool -Name Pester40).manualGroupMembership | Should Be 'true'
        }

        It 'Should create a new apppool with idleTimeout set to 00:30:00' {
            New-IISAppPool -Name Pester40 -idleTimeout '00:30:00'
            (Get-IISAppPool -Name Pester40).idleTimeout | Should Be '00:30:00'
        }

        It 'Should create a new apppool with maxprocesses set to 2' {
            New-IISAppPool -Name Pester40 -maxprocesses '2'
            (Get-IISAppPool -Name Pester40).maxprocesses | Should Be '2'
        }

        It 'Should create a new apppool with shutdownTimeLimit set to 00:02:00' {
            New-IISAppPool -Name Pester40 -shutdownTimeLimit '00:02:00'
            (Get-IISAppPool -Name Pester40).shutdownTimeLimit | Should Be '00:02:00'
        }

        It 'Should create a new apppool with startupTimeLimit set to 00:02:00' {
            New-IISAppPool -Name Pester40 -startupTimeLimit '00:02:00'
            (Get-IISAppPool -Name Pester40).startupTimeLimit | Should Be '00:02:00'
        }

        It 'Should create a new apppool with pingingEnabled set to false' {
            New-IISAppPool -Name Pester40 -pingingEnabled 'false'
            (Get-IISAppPool -Name Pester40).pingingEnabled | Should Be 'false'
        }

        It 'Should create a new apppool with pingInterval set to 00:00:25' {
            New-IISAppPool -Name Pester40 -pingInterval '00:00:25'
            (Get-IISAppPool -Name Pester40).pingInterval | Should Be '00:00:25'
        }

        It 'Should create a new apppool with pingResponseTime set to 00:02:00' {
            New-IISAppPool -Name Pester40 -pingResponseTime '00:02:00'
            (Get-IISAppPool -Name Pester40).pingResponseTime | Should Be '00:02:00'
        }

        It 'Should create a new apppool with disallowOverlappingRotation set to true' {
            New-IISAppPool -Name Pester40 -disallowOverlappingRotation 'true'
            (Get-IISAppPool -Name Pester40).disallowOverlappingRotation | Should Be 'true'
        }
             
        It 'Should create a new apppool with disallowRotationOnConfigChange set to true' {
            New-IISAppPool -Name Pester40 -disallowRotationOnConfigChange 'true'
            (Get-IISAppPool -Name Pester40).disallowRotationOnConfigChange | Should Be 'true'
        }

        It 'Should create a new apppool with logEventOnRecycle set to Time, Memory' {
            New-IISAppPool -Name Pester40 -logEventOnRecycle 'Time, Memory'
            (Get-IISAppPool -Name Pester40).logEventOnRecycle | Should Be 'Time, Memory'
        }

        It 'Should create a new apppool with restartMemoryLimit set to 1024' {
            New-IISAppPool -Name Pester40 -restartMemoryLimit '1024'
            (Get-IISAppPool -Name Pester40).restartMemoryLimit | Should Be '1024'
        }

        It 'Should create a new apppool with restartPrivateMemoryLimit set to 1024' {
            New-IISAppPool -Name Pester40 -restartPrivateMemoryLimit '1024'
            (Get-IISAppPool -Name Pester40).restartPrivateMemoryLimit | Should Be '1024'
        }

        It 'Should create a new apppool with restartRequestsLimit set to 2' {
            New-IISAppPool -Name Pester40 -restartRequestsLimit '2'
            (Get-IISAppPool -Name Pester40).restartRequestsLimit | Should Be '2'
        }

        It 'Should create a new apppool with restartTimeLimit set to 1.10:00:00' {
            New-IISAppPool -Name Pester40 -restartTimeLimit '1.10:00:00'
            (Get-IISAppPool -Name Pester40).restartTimeLimit | Should Be '1.10:00:00'
        }

        It 'Should create a new apppool with restartSchedule set to 07:00:00,19:00:00' {
            New-IISAppPool -Name Pester40 -restartSchedule '07:00:00','19:00:00'
            (Get-IISAppPool -Name Pester40).restartSchedule.add.value | Should Be '07:00:00','19:00:00'
        }
        
        It 'Should create a new apppool with loadBalancerCapabilities set to TcpLevel' {
            New-IISAppPool -Name Pester40 -loadBalancerCapabilities 'TcpLevel'
            (Get-IISAppPool -Name Pester40).loadBalancerCapabilities | Should Be 'TcpLevel'
        }

        It 'Should create a new apppool with orphanWorkerProcess set to true'{
            New-IISAppPool -Name Pester40 -orphanWorkerProcess 'true'
            (Get-IISAppPool -Name Pester40).orphanWorkerProcess | Should Be 'true'    
        }

        It 'Should create a new apppool with orphanActionExe set to test.exe'{
            New-IISAppPool -Name Pester40 -orphanActionExe 'test.exe'
            (Get-IISAppPool -Name Pester40).orphanActionExe | Should Be 'test.exe'    
        }

        It 'Should create a new apppool with rapidFailProtection set to false'{
            New-IISAppPool -Name Pester40 -rapidFailProtection 'false'
            (Get-IISAppPool -Name Pester40).rapidFailProtection | Should Be 'false'    
        }

        It 'Should create a new apppool with rapidFailProtectionInterval set to 00:01:00'{
            New-IISAppPool -Name Pester40 -rapidFailProtectionInterval '00:01:00'
            (Get-IISAppPool -Name Pester40).rapidFailProtectionInterval | Should Be '00:01:00'    
        }

        It 'Should create a new apppool with rapidFailProtectionMaxCrashes set to 2'{
            New-IISAppPool -Name Pester40 -rapidFailProtectionMaxCrashes '2'
            (Get-IISAppPool -Name Pester40).rapidFailProtectionMaxCrashes | Should Be '2'    
        }

        It 'Should create a new apppool with autoShutdownExe set to test.exe'{
            New-IISAppPool -Name Pester40 -autoShutdownExe 'test.exe'
            (Get-IISAppPool -Name Pester40).autoShutdownExe | Should Be 'test.exe'    
        }

        It 'Should create a new apppool with autoShutdownParams set to TestParam'{
            New-IISAppPool -Name Pester40 -autoShutdownParams 'TestParam'
            (Get-IISAppPool -Name Pester40).autoShutdownParams | Should Be 'TestParam'    
        }

        It 'Should create a new apppool with cpuLimit set to 85'{
            New-IISAppPool -Name Pester40 -cpuLimit '85'
            (Get-IISAppPool -Name Pester40).cpuLimit | Should Be '85'    
        }

        It 'Should create a new apppool with cpuAction set to KillW3wp'{
            New-IISAppPool -Name Pester40 -cpuAction 'KillW3wp'
            (Get-IISAppPool -Name Pester40).cpuAction | Should Be 'KillW3wp'    
        }

        It 'Should create a new apppool with cpuResetInterval set to 00:06:00'{
            New-IISAppPool -Name Pester40 -cpuResetInterval '00:06:00'
            (Get-IISAppPool -Name Pester40).cpuResetInterval | Should Be '00:06:00'    
        }

        It 'Should create a new apppool with cpuSmpAffinitized set to true'{
            New-IISAppPool -Name Pester40 -cpuSmpAffinitized 'true'
            (Get-IISAppPool -Name Pester40).cpuSmpAffinitized | Should Be 'true'    
        }

        It 'Should create a new apppool with cpuSmpProcessorAffinityMask set to 4294967291'{
            New-IISAppPool -Name Pester40 -cpuSmpProcessorAffinityMask '4294967291'
            (Get-IISAppPool -Name Pester40).cpuSmpProcessorAffinityMask | Should Be '4294967291'    
        }

         It 'Should create a new apppool with cpuSmpProcessorAffinityMask2 set to 4294967291'{
            New-IISAppPool -Name Pester40 -cpuSmpProcessorAffinityMask2 '4294967291'
            (Get-IISAppPool -Name Pester40).cpuSmpProcessorAffinityMask2 | Should Be '4294967291'    
        }

    }
}

Describe 'Set-IISAppPool'{
    It 'should update queueLength'{
        Set-IISAppPool -Name 'Pester' -queueLength '1111'
        (Get-IISAppPool -Name 'Pester').queueLength | Should Be '1111'
    }

    It 'Should update managedRuntimeLoader'{
        Set-IISAppPool -Name 'Pester' -managedRuntimeLoader 'notepad.exe'
        (Get-IISAppPool -Name 'Pester').managedRuntimeLoader | Should Be 'notepad.exe'
    }

    It 'Should update enableConfigurationOverride'{
        Set-IISAppPool -Name 'Pester' -enableConfigurationOverride false
        (Get-IISAppPool -Name 'Pester').enableConfigurationOverride | Should be 'false'
    }

    It 'Should update CLRConfigFile'{
        Set-IISAppPool -Name 'Pester' -CLRConfigFile 'test.config'
        (Get-IISAppPool -Name 'Pester').CLRConfigFile | Should Be 'test.config'    
    }

    It 'Should update passAnonymousToken to false'{
        Set-IISAppPool -Name 'Pester' -passAnonymousToken false
        (Get-IISAppPool -Name 'Pester').passAnonymousToken | Should Be 'false'
    }

    It 'Should update logonType to LogonService'{
        Set-IISAppPool -Name 'Pester' -logonType LogonService
        (Get-IISAppPool -Name 'Pester').logonType | Should Be 'LogonService'
    }

    It 'Should update manualGroupMembership to true'{
        Set-IISAppPool -Name 'Pester' -manualGroupMembership true
        (Get-IISAppPool -Name 'Pester').manualGroupMembership | Should Be 'true'
    }

    It 'Should update idleTimeout to 00:40:00'{
        Set-IISAppPool -Name 'Pester' -idleTimeout '00:40:00'
        (Get-IISAppPool -Name 'Pester').idleTimeout | Should Be '00:40:00'
    }

    It 'Should update maxProcesses to 2'{
        Set-IISAppPool -Name 'Pester' -maxProcesses '2'
        (Get-IISAppPool -Name 'Pester').maxProcesses | Should Be '2' 
    }

    It 'Should update shutdownTimeLimit to 00:02:00'{
        Set-IISAppPool -Name 'Pester' -shutdownTimeLimit '00:02:00'
        (Get-IISAppPool -Name 'Pester').shutdownTimeLimit | Should Be '00:02:00' 
    }

    It 'Should update startupTimeLimit to 00:02:00'{
        Set-IISAppPool -Name 'Pester' -startupTimeLimit '00:02:00'
        (Get-IISAppPool -Name 'Pester').startupTimeLimit | Should Be '00:02:00'
    }

    It 'Should update pingingEnabled to false'{
        Set-IISAppPool -Name 'Pester' -pingingEnabled 'false'
        (Get-IISAppPool -Name 'Pester').pingingEnabled | Should Be 'false'
    }

    It 'Should update pingInterval to 00:05:00' {
        Set-IISAppPool -Name 'Pester' -pingInterval '00:05:00'
        (Get-IISAppPool -Name 'Pester').pingInterval | Should Be '00:05:00'
    }

    It 'Should update pingResponseTime to 00:01:00' {
        Set-IISAppPool -Name 'Pester' -pingResponseTime '00:01:00'
        (Get-IISAppPool -Name 'Pester').pingResponseTime | Should Be '00:01:00'
    }

    It 'Should update disallowOverlappingRotation to true'{
        Set-IISAppPool -Name 'Pester' -disallowOverlappingRotation 'true'
        (Get-IISAppPool -Name 'Pester').disallowOverlappingRotation | Should Be 'true'
    }

    It 'Should update disallowRotationOnConfigChange to true' {
        Set-IISAppPool -Name 'Pester' -disallowRotationOnConfigChange 'true'
        (Get-IISAppPool -Name 'Pester').disallowRotationOnConfigChange | Should Be 'true'
    }

    It 'Should update logEventOnRecycle to Time, Memory' {
        Set-IISAppPool -Name 'Pester' -logEventOnRecycle 'Time, Memory'
        (Get-IISAppPool -Name 'Pester').logEventOnRecycle | Should Be 'Time, Memory'
    }

    It 'Should update restartMemoryLimit to 1024' {
        Set-IISAppPool -Name 'Pester' -restartMemoryLimit '1024'
        (Get-IISAppPool -Name 'Pester').restartMemoryLimit | Should Be '1024'
    }

    It 'Should update restartPrivateMemoryLimit to 1024'{
        Set-IISAppPool -Name 'Pester' -restartPrivateMemoryLimit '1024'
        (Get-IISAppPool -Name 'Pester').restartPrivateMemoryLimit | Should Be '1024'
    }

    It 'Should update restartRequestsLimit to 1000'{
        Set-IISAppPool -Name 'Pester' -restartRequestsLimit '1000'
        (Get-IISAppPool -Name 'Pester').restartRequestsLimit | Should Be '1000'
    }

    It 'Should update restartTimeLimit to 1.10:00:00'{
        Set-IISAppPool -Name 'Pester' -restartTimeLimit '1.10:00:00'
        (Get-IISAppPool -Name 'Pester').restartTimeLimit | Should Be '1.10:00:00'
    }

    It 'Should update restartSchedule to 07:00:00'{
        Set-IISAppPool -Name 'Pester' -restartSchedule '07:00:00'
        (Get-IISAppPool -Name 'Pester').restartSchedule.add.value | Should Be '07:00:00'
    }

    It 'Should update restartSchedule to 07:00:00,19:00:00'{
        Set-IISAppPool -Name 'Pester' -restartSchedule '07:00:00','19:00:00'
        (Get-IISAppPool -Name 'Pester').restartSchedule.add.value | Should Be '07:00:00','19:00:00'
    }

    It 'Should update loadBalancerCapabilities to TcpLevel'{
        Set-IISAppPool -Name 'Pester' -loadBalancerCapabilities TcpLevel
        (Get-IISAppPool -Name 'Pester').loadBalancerCapabilities | Should Be 'TcpLevel'
    }

    It 'Should update orphanWorkerProcess to true'{
        Set-IISAppPool -Name 'Pester' -orphanWorkerProcess true
        (Get-IISAppPool -Name 'Pester').orphanWorkerProcess | Should Be 'true'
    }

    It 'Should update orphanActionParams to Test'{
        Set-IISAppPool -Name 'Pester' -orphanActionParams 'test'
        (Get-IISAppPool -Name 'Pester').orphanActionParams | Should be 'test'
    }

    It 'Should update rapidFailProtection to false'{
        Set-IISAppPool -Name 'Pester' -rapidFailProtection 'false'
        (Get-IISAppPool -Name 'Pester').rapidFailProtection | Should Be 'false'
    }

    It 'Should update rapidFailProtectionInterval to 00:04:00'{
        Set-IISAppPool -Name 'Pester' -rapidFailProtectionInterval '00:04:00'
        (Get-IISAppPool -Name 'Pester').rapidFailProtectionInterval | Should Be '00:04:00'
    }

    It 'Should update rapidFailProtectionMaxCrashes to 10'{
        Set-IISAppPool -Name 'Pester' -rapidFailProtectionMaxCrashes '10'
        (Get-IISAppPool -Name 'Pester').rapidFailProtectionMaxCrashes | Should Be '10'
    }

    It 'Should update autoShutdownExe to true'{
        Set-IISAppPool -Name 'Pester' -autoShutdownExe 'true'
        (Get-IISAppPool -Name 'Pester').autoShutdownExe | Should Be 'true'
    }

    It 'Should update autoShutdownParams to test'{
        Set-IISAppPool -Name 'Pester' -autoShutdownParams 'test'
        (Get-IISAppPool -Name 'Pester').autoShutdownParams | Should Be 'test'
    }

    It 'Should update cpuLimit to 11'{
        Set-IISAppPool -Name 'Pester' -cpuLimit '11'
        (Get-IISAppPool -Name 'Pester').cpuLimit | Should Be '11'
    }

    It 'Should update cpuAction to KillW3wp'{
        Set-IISAppPool -Name 'Pester' -cpuAction KillW3wp
        (Get-IISAppPool -Name 'Pester').cpuAction | Should Be 'KillW3wp'
    }

    It 'Should update cpuResetInterval to 00:02:00'{
        Set-IISAppPool -Name 'Pester' -cpuResetInterval '00:02:00'
        (Get-IISAppPool -Name 'Pester').cpuResetInterval | Should Be '00:02:00'
    }

    It 'Should update cpuSmpAffinitized to true'{
        Set-IISAppPool -Name 'Pester' -cpuSmpAffinitized 'true'
        (Get-IISAppPool -Name 'Pester').cpuSmpAffinitized | Should Be 'true'
    }

    It 'Should update cpuSmpProcessorAffinityMask to 4294967294'{
        Set-IISAppPool -Name 'Pester' -cpuSmpProcessorAffinityMask '4294967294'
        (Get-IISAppPool -Name 'Pester').cpuSmpProcessorAffinityMask | Should be '4294967294'
    }

    It 'Should update cpuSmpProcessorAffinityMask2 to 4294967294'{
        Set-IISAppPool -Name 'Pester' -cpuSmpProcessorAffinityMask2 '4294967294'
        (Get-IISAppPool -Name 'Pester').cpuSmpProcessorAffinityMask2 | Should be '4294967294'
    }
}

Remove-Item iis:\apppools\PEster -force -Recurse