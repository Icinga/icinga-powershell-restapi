function Invoke-IcingaRESTAPIv1Calls()
{
    param (
        [Hashtable]$Request = @{},
        [Hashtable]$Connection = @{},
        $IcingaGlobals
    );

    [string]$ModuleToLoad = Get-IcingaRESTPathElement -Request $RESTRequest -Index 1;

    if ([string]::IsNullOrEmpty($ModuleToLoad)) {
        # TDOO: Send message reponse to client for invalid message
        Write-IcingaDebugMessage -Message 'Module for execution was NULL';
        return;
    }

    # Map our Icinga globals to a shorter variable
    $RestDaemon = $IcingaGlobals.BackgroundDaemon.IcingaPowerShellRestApi;

    if ($RestDaemon.RegisteredEndpoints.ContainsKey($ModuleToLoad) -eq $FALSE) {
        # TDOO: Send message reponse to client for invalid message
        Write-IcingaDebugMessage -Message 'Module for execution not found';
        return;
    }

    [string]$Command = $RestDaemon.RegisteredEndpoints[$ModuleToLoad];

    Write-IcingaDebugMessage -Message ('Command to execute' + $Command);

    if ($null -eq (Get-Command $Command)) {
        # TDOO: Send message reponse to client for invalid message
        Write-IcingaDebugMessage -Message ('Unknown command for execution found' + $Command);
        return;
    }

    [hashtable]$CommandArguments = @{
        '-Request'       = $Request;
        '-Connection'    = $Connection;
        '-IcingaGlobals' = $IcingaGlobals;
    };

    Invoke-Command -ScriptBlock { &$Command @CommandArguments };
}
