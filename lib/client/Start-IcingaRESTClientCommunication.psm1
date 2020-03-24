function Start-IcingaRESTClientCommunication()
{
    param(
        [Hashtable]$Connection = @{},
        $IcingaGlobals         = $null
    );

    # Our ScriptBlock for the code being executed inside the thread
    [ScriptBlock]$IcingaRestClientScript = {
        # Allow us to parse the framework global data to this thread
        param($IcingaGlobals, $Connection);

        # Import the framework library components and initialise it
        # as daemon
        Use-Icinga -LibOnly -Daemon;

        # Map our Icinga globals to a shorter variable
        $RestDaemon = $IcingaGlobals.BackgroundDaemon.IcingaPowerShellRestApi;

        # Read the received message from the stream by using our smart functions
        [string]$RestMessage = Read-IcingaTCPStream -Client $Connection.Client -Stream $Connection.Stream;
        # Now properly translate the entire rest message to a parseable hashtable
        $RESTRequest         = Read-IcingaRestMessage -RestMessage $RestMessage;

        # TODO: Add dynamic REST-Endpoint registering and invocation of commands
        #       for doing the intended work

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
