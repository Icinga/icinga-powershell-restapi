function Register-IcingaRESTAPIEventLog()
{
    $global:IcingaEventLogEnums.Add(
        'RESTApi', @{
            2000 = @{
                'EntryType' = 'Error';
                'Message'   = 'Failed to start REST-Api daemon, as no valid provided SSL and Icinga 2 Agent certificate was found';
                'Details'   = 'While starting the Icinga for Windows REST-Api daemon, no valid certificate was found for usage. You can either share a valid certificate by defining the full path with `-CertFile` to a .crt, .cert or .pfx file, by using `-CertThumbprint` to lookup a certificate inside the Microsoft cert store and by default the Icinga 2 Agent certificates. Please note that only Icinga 2 Agent version 2.8.0 or later are supported';
                'EventId'   = 2000;
            };
        }
    );
}
