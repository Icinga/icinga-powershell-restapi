@{
    ModuleVersion = '1.3.0'
    GUID = '264ff2cd-7587-4b21-9d86-af8274a6e2e2'
    ModuleToProcess = 'icinga-powershell-restapi.psm1'
    Author = 'Lord Hepipud, Crited'
    CompanyName = 'Icinga GmbH'
    Copyright = '(c) 2021 Icinga GmbH | MIT'
    Description = 'A REST-Api daemon for Icinga for Windows. It allows you to register daemon endpoints which can be accessed over web calls to fetch information or execute checks for example.'
    PowerShellVersion = '4.0'
    RequiredModules   = @(@{ModuleName = 'icinga-powershell-framework'; ModuleVersion = '1.6.0' })
    NestedModules = @(
        '.\lib\eventlog\Register-IcingaEventLogMessagesRESTApi.psm1',
        '.\lib\client\Invoke-IcingaRESTAPIv1Calls.psm1',
        '.\lib\client\Add-IcingaRESTClientBlacklistCount.psm1',
        '.\lib\client\Remove-IcingaRESTClientBlacklist.psm1',
        '.\lib\client\Test-IcingaRESTClientBlacklisted.psm1',
        '.\lib\client\Test-IcingaRESTClientConnection.psm1',
        '.\lib\daemon\New-IcingaForWindowsRESTApi.psm1',
        '.\lib\daemon\Start-IcingaWindowsRESTApi.psm1',
        '.\lib\threads\Get-IcingaNextRESTApiThreadId.psm1',
        '.\lib\threads\New-IcingaForWindowsRESTThread.psm1',
        '.\lib\threads\Start-IcingaForWindowsRESTThread.psm1',
        '.\lib\tools\Add-IcingaRESTApiCommand.psm1',
        '.\lib\tools\Remove-IcingaRESTApiCommand.psm1',
        '.\lib\tools\Show-IcingaApiCommands.psm1',
        '.\lib\tools\Test-IcingaRESTApiCommand.psm1'
    )
    FunctionsToExport = @('*')
    CmdletsToExport = @('*')
    VariablesToExport = '*'
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @( 'icinga','icinga2','restapi','rest','windowsrest','icingawindows')
            LicenseUri = 'https://github.com/Icinga/icinga-powershell-restapi/blob/master/LICENSE'
            ProjectUri = 'https://github.com/Icinga/icinga-powershell-restapi'
            ReleaseNotes = 'https://github.com/Icinga/icinga-powershell-restapi/releases'
        };
        Version  = 'v1.3.0';
        Name     = 'REST-Api';
        Type     = 'daemon';
        Function = 'Start-IcingaWindowsRESTApi';
    }
    HelpInfoURI = 'https://github.com/Icinga/icinga-powershell-restapi'
}
