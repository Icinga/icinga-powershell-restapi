function Start-IcingaWindowsRESTApi()
{
    param(
        [int]$Port = 5668
    );

    # Our ScriptBlock for the code being executed inside the thread
    [ScriptBlock]$IcingaRestApiScript = {
        # Allow us to parse the framework global data to this thread
        param($IcingaGlobals, $Port);

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

        # Keep our code excuted as long as the PowerShell service is
        # being executed. This is required to ensure we will execute
        # the code frequently instead of only once
        while ($TRUE) {

        }
    }

    # Now create a new thread for our ScriptBlock, assign a name and
    # parse all required arguments to it. Last but not least start it
    # directly
    New-IcingaThreadInstance `
        -Name "Icinga_PowerShell_Module_REST_Api" `
        -ThreadPool $global:IcingaDaemonData.IcingaThreadPool.BackgroundPool `
        -ScriptBlock $IcingaRestApiScript `
        -Arguments @( $global:IcingaDaemonData, $Port ) `
        -Start;
}
