function Start-IcingaRESTClientCommunication()
{
    param(
        [Hashtable]$Connection = @{},
        $IcingaGlobals         = $null
    );

    # If we couldnt establish a proper SSL stream, close the connection
    # immediately without opening a client connection thread
    if ($null -eq $Connection.Stream) {
        Add-IcingaRESTClientBlacklistCount `
            -Client $Connection.Client `
            -ClientList $IcingaGlobals.BackgroundDaemon.IcingaPowerShellRestApi.ClientBlacklist;
        Write-IcingaEventMessage -EventId 1501 -Namespace 'Framework' -Objects $Connection.Client.Client;
        Close-IcingaTCPConnection -Client $Connection.Client;
        $Connection = $null;
        return;
    }

    # Our ScriptBlock for the code being executed inside the thread
    [ScriptBlock]$IcingaRestClientScript = {
        # Allow us to parse the framework global data to this thread
        param($IcingaGlobals, $Connection);

        # Import the framework library components and initialise it
        # as daemon
        Use-Icinga -Daemon;

        # Map our Icinga globals to a shorter variable
        $RestDaemon = $IcingaGlobals.BackgroundDaemon.IcingaPowerShellRestApi;

        # Read the received message from the stream by using our smart functions
        [string]$RestMessage = Read-IcingaTCPStream -Client $Connection.Client -Stream $Connection.Stream;
        # Now properly translate the entire rest message to a parseable hashtable
        $RESTRequest         = Read-IcingaRestMessage -RestMessage $RestMessage -Connection $Connection;

        if ($null -ne $RESTRequest) {
            # We should remove clients from the blacklist who are sending valid requests
            Remove-IcingaRESTClientBlacklist -Client $Connection.Client -ClientList $RestDaemon.ClientBlacklist;
            switch (Get-IcingaRESTPathElement -Request $RESTRequest -Index 0) {
                'v1' {
                    Invoke-IcingaRESTAPIv1Calls -Request $RESTRequest -Connection $Connection -IcingaGlobals $IcingaGlobals;
                    break;
                };
                default {
                    # Todo: Add client response for invalid request
                    Write-IcingaDebugMessage -Message ('Invalid API call - no version specified' + ($RESTRequest.RequestPath | Out-String));
                    Send-IcingaTCPClientMessage -Message (
                        New-IcingaTCPClientRESTMessage `
                            -HTTPResponse ($IcingaHTTPEnums.HTTPResponseType.'Not Found') `
                            -ContentBody 'Invalid API call received. No version specified.'
                    ) -Stream $Connection.Stream;
                };
            }
        }

        # Finally close the clients connection as we are done here and
        # ensure this thread will close by simply leaving the ScriptBlock
        Close-IcingaTCPConnection -Client $Connection.Client;
    }

    # Now create a new thread for our ScriptBlock, assign a name and
    # parse all required arguments to it. Last but not least start it
    # directly
    New-IcingaThreadInstance `
        -Name ([string]::Format("Icinga_PowerShell_Module_REST_Client_{0}", (Get-IcingaTCPClientRemoteEndpoint -Client $Connection.Client))) `
        -ThreadPool $IcingaGlobals.IcingaThreadPool.BackgroundPool `
        -ScriptBlock $IcingaRestClientScript `
        -Arguments @( $IcingaGlobals, $Connection ) `
        -Start;
}
