@{
    ModuleVersion = '1.0.0'
    GUID = '264ff2cd-7587-4b21-9d86-af8274a6e2e2'
    ModuleToProcess = 'icinga-powershell-restapi.psm1'
    Author = 'Lord Hepipud, Crited'
    CompanyName = 'Icinga GmbH'
    Copyright = '(c) 2020 Icinga GmbH | GPLv2'
    Description = 'A REST-Api daemon for the Icinga PowerShell Framework'
    PowerShellVersion = '4.0'
    RequiredModules   = @(@{ModuleName = 'icinga-powershell-framework'; ModuleVersion = '1.1.0' })
    NestedModules = @(
        '.\lib\eventlog\Register-IcingaEventLogMessagesRESTApi.psm1',
        '.\lib\client\Invoke-IcingaRESTAPIv1Calls.psm1',
        '.\lib\client\Start-IcingaRESTClientCommunication.psm1',
        '.\lib\client\Add-IcingaRESTClientBlacklistCount.psm1',
        '.\lib\client\Remove-IcingaRESTClientBlacklist.psm1',
        '.\lib\client\Test-IcingaRESTClientBlacklisted.psm1',
        '.\lib\daemon\Start-IcingaWindowsRESTApi.psm1'
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
        Version = 'v1.0.0';
    }
    HelpInfoURI = 'https://github.com/Icinga/icinga-powershell-restapi'
}
