function Start-IcingaWindowsRESTApi()
{
    param(
        [int]$Port              = 5668,
        [string]$CertFile       = $null,
        [string]$CertThumbprint = $null
    );

    $RootFolder = $PSScriptRoot;

    # Our ScriptBlock for the code being executed inside the thread
    [ScriptBlock]$IcingaRestApiScript = {
        # Allow us to parse the framework global data to this thread
        param($IcingaGlobals, $Port, $RootFolder, $CertFile, $CertThumbprint);

        # Import the framework library components and initialise it
        # as daemon
        Use-Icinga -LibOnly -Daemon;

        # Add a synchronized hashtable to the global data background
        # daemon hashtable to write data to. In addition it will
        # allow to share data collected from this daemon with others
        $IcingaGlobals.BackgroundDaemon.Add(
            'IcingaPowerShellRestApi',
            [hashtable]::Synchronized(@{})
        );

        # Map our Icinga globals to a shorter variable
        $RestDaemon = $IcingaGlobals.BackgroundDaemon.IcingaPowerShellRestApi;

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

        # Keep our code excuted as long as the PowerShell service is
        # being executed. This is required to ensure we will execute
        # the code frequently instead of only once
        while ($TRUE) {
            $Connection = Open-IcingaTCPClientConnection `
                -Client (New-IcingaTCPClient -Socket $Socket) `
                -Certificate $Certificate;

            Start-IcingaRESTClientCommunication -Connection $Connection -IcingaGlobals $IcingaGlobals;
        }
    }

    # Now create a new thread for our ScriptBlock, assign a name and
    # parse all required arguments to it. Last but not least start it
    # directly
    New-IcingaThreadInstance `
        -Name "Icinga_PowerShell_Module_REST_Api" `
        -ThreadPool $global:IcingaDaemonData.IcingaThreadPool.BackgroundPool `
        -ScriptBlock $IcingaRestApiScript `
        -Arguments @( $global:IcingaDaemonData, $Port, $RootFolder, $CertFile, $CertThumbprint ) `
        -Start;
}
