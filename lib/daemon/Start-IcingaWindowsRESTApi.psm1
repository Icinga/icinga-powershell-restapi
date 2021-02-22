function Start-IcingaWindowsRESTApi()
{
    param (
        [int]$Port              = 5668,
        [string]$CertFile       = $null,
        [string]$CertThumbprint = $null,
        [bool]$RequireAuth      = $FALSE,
        [int]$ConcurrentThreads = 5
    );

    $RootFolder = $PSScriptRoot;

    # Our ScriptBlock for the code being executed inside the thread
    [ScriptBlock]$IcingaRestApiScript = {
        # Allow us to parse the framework global data to this thread
        param($IcingaDaemonData, $Port, $RootFolder, $CertFile, $CertThumbprint, $RequireAuth);

        # Import the framework library components and initialise it
        # as daemon
        Use-Icinga -LibOnly -Daemon;

        # Add a synchronized hashtable to the global data background
        # daemon hashtable to write data to. In addition it will
        # allow to share data collected from this daemon with others
        $IcingaDaemonData.BackgroundDaemon.Add(
            'IcingaPowerShellRestApi',
            [hashtable]::Synchronized(@{})
        );

        # Map our Icinga globals to a shorter variable
        $RestDaemon = $IcingaDaemonData.BackgroundDaemon.IcingaPowerShellRestApi;

        # This will add another hashtable to our previous
        # IcingaPowerShellRestApi hashtable to store actual
        # endpoint configurations for the API
        $RestDaemon.Add(
            'RegisteredEndpoints',
            [hashtable]::Synchronized(@{})
        );

        # This will add another hashtable to our previous
        # IcingaPowerShellRestApi hashtable to store actual
        # command aliases for execution for the API
        $RestDaemon.Add(
            'CommandAliases',
            [hashtable]::Synchronized(@{})
        );

        # This will add another hashtable to our previous
        # IcingaPowerShellRestApi hashtable to store actual
        # command aliases for execution for the API
        $RestDaemon.Add(
            'ClientBlacklist',
            [hashtable]::Synchronized(@{})
        );

        # Make the root folder of our rest daemon module available
        # for every possible thread we require
        $RestDaemon.Add(
            'RootFolder', $RootFolder
        );

        $RESTEndpoints = Invoke-IcingaNamespaceCmdlets -Command 'Register-IcingaRESTAPIEndpoint*';
        Write-IcingaDebugMessage -Message (
            [string]::Format(
                'Loading configuration for REST-Endpoints{0}{1}',
                (New-IcingaNewLine),
                ($RESTEndpoints | Out-String)
            )
        );

        Write-IcingaDebugMessage -Message ($RestDaemon | Out-String);

        foreach ($entry in $RESTEndpoints.Values) {
            [bool]$Success = Add-IcingaHashtableItem -Hashtable $RestDaemon.RegisteredEndpoints `
                                                     -Key $entry.Alias `
                                                     -Value $entry.Command;
            
            if ($Success -eq $FALSE) {
                Write-IcingaEventMessage `
                    -EventId 2100 `
                    -Namespace 'RESTApi' `
                    -Objects ([string]::Format('Adding duplicated REST endpoint "{0}" with command "{1}', $entry.Alias, $entry.Command)), $RESTEndpoints;
            }
        }

        $CommandAliases = Invoke-IcingaNamespaceCmdlets -Command 'Register-IcingaRESTApiCommandAliases*';

        foreach ($entry in $CommandAliases.Values) {
            foreach ($component in $entry.Keys) {
                [bool]$Success = Add-IcingaHashtableItem -Hashtable $RestDaemon.CommandAliases `
                                                         -Key $component `
                                                         -Value $entry[$component];
            
                if ($Success -eq $FALSE) {
                    Write-IcingaEventMessage `
                        -EventId 2101 `
                        -Namespace 'RESTApi' `
                        -Objects ([string]::Format('Adding duplicated REST command aliases "{0}" for namespace "{1}', $entry[$component], $component)), $CommandAliases;
                }
            }
        }

        Write-IcingaDebugMessage -Message ($RestDaemon.RegisteredEndpoints | Out-String);
        $Certificate = Get-IcingaSSLCertForSocket -CertFile $CertFile -CertThumbprint $CertThumbprint;

        if ($null -eq $Certificate) {
            Write-IcingaEventMessage -EventId 2000 -Namespace 'RESTApi';
            return;
        }

        $Socket = New-IcingaTCPSocket -Port $Port -Start;

        # Keep our code executed as long as the PowerShell service is
        # being executed. This is required to ensure we will execute
        # the code frequently instead of only once
        while ($TRUE) {
            $Connection = Open-IcingaTCPClientConnection `
                -Client (New-IcingaTCPClient -Socket $Socket) `
                -Certificate $Certificate;

            if (Test-IcingaRESTClientBlacklisted -Client $Connection.Client -ClientList $RestDaemon.ClientBlacklist) {
                Write-IcingaDebugMessage -Message 'A remote client which is trying to connect was blacklisted' -Objects $Connection.Client.Client;
                Close-IcingaTCPConnection -Client $Connection.Client;
                continue;
            }

            if ((Test-IcingaRESTClientConnection -Connection $Connection) -eq $FALSE) {
                return;
            }

            try {
                $IcingaDaemonData.IcingaThreadContent.RESTApi.ApiRequests.Add(
                    @{
                        'ThreadId'   = (Get-IcingaNextRESTApiThreadId);
                        'Connection' = $Connection;
                    }
                );
            } catch {
                $ExMsg = $_.Exception.Message;
                Write-IcingaEventMessage -Namespace 'RESTApi' -EvenId 2050 -Objects $ExMsg;
            }
        }
    }

    [System.Collections.ArrayList]$ApiRequests = @();
    $global:IcingaDaemonData.IcingaThreadContent.Add('RESTApi', ([hashtable]::Synchronized(@{})));
    $global:IcingaDaemonData.IcingaThreadPool.Add('IcingaRESTApi', (New-IcingaThreadPool -MaxInstances ($ThreadId + 3)));
    $global:IcingaDaemonData.IcingaThreadContent.RESTApi.Add('ApiRequests', $ApiRequests);
    $global:IcingaDaemonData.IcingaThreadContent.RESTApi.Add('ApiCallThreadAssignment', ([hashtable]::Synchronized(@{})));
    $global:IcingaDaemonData.IcingaThreadContent.RESTApi.Add('TotalThreads', $ConcurrentThreads);
    $global:IcingaDaemonData.IcingaThreadContent.RESTApi.Add('LastThreadId', 0);

    # Now create a new thread for our ScriptBlock, assign a name and
    # parse all required arguments to it. Last but not least start it
    # directly
    New-IcingaThreadInstance `
        -Name "Icinga_for_Windows_REST_Api" `
        -ThreadPool $global:IcingaDaemonData.IcingaThreadPool.IcingaRESTApi `
        -ScriptBlock $IcingaRestApiScript `
        -Arguments @( $global:IcingaDaemonData, $Port, $RootFolder, $CertFile, $CertThumbprint, $RequireAuth ) `
        -Start;

    $ThreadId = 0;

    while ($ConcurrentThreads -gt 0) {
        $ConcurrentThreads = $ConcurrentThreads - 1;
        Start-IcingaWindowsRESTThread -ThreadId $ThreadId -RequireAuth:$RequireAuth;
        $ThreadId += 1;

        Start-Sleep -Seconds 1;
    }
}
