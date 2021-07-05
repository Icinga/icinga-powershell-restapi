function Register-IcingaEventLogMessagesRESTApi()
{
    return @{
        'RESTApi' = @{
            2000 = @{
                'EntryType' = 'Error';
                'Message'   = 'Failed to start REST-Api daemon, as no valid provided SSL and Icinga 2 Agent certificate was found';
                'Details'   = 'While starting the Icinga for Windows REST-Api daemon, no valid certificate was found for usage. You can either share a valid certificate by defining the full path with `-CertFile` to a .crt, .cert or .pfx file, by using `-CertThumbprint` to lookup a certificate inside the Microsoft cert store and by default the Icinga 2 Agent certificates. Please note that only Icinga 2 Agent version 2.8.0 or later are supported';
                'EventId'   = 2000;
            };
            2050 = @{
                'EntryType' = 'Error';
                'Message'   = 'Failed to parse received REST-Api call';
                'Details'   = 'An API call send to the daemon could not be processed and caused an exception. Further details about the cause of this error can be found belowed.';
                'EventId'   = 2050;
            };
            2051 = @{
                'EntryType' = 'Error';
                'Message'   = 'Failed to execute API call';
                'Details'   = 'An API call could not be processed due to an internal exception.';
                'EventId'   = 2051;
            };
            2052 = @{
                'EntryType' = 'Error';
                'Message'   = 'Internal exception on calling API command';
                'Details'   = 'An internal command assigned to an API request could not be executed and caused an exception.';
                'EventId'   = 2052;
            };
            2100 = @{
                'EntryType' = 'Warning';
                'Message'   = 'Failed to add namespace configuration for executed commands, as previous commands are reporting identical namespace identifiers';
                'Details'   = 'This warning occurs while the REST-Api is trying to auto-load different resources automatically to provide for example inventory information or any other auto-loaded configurations. Please review your installed modules, check the detailed description which modules and Cmdlets caused this conflict and either resolve it or get in contact with the corresponding developers.';
                'EventId'   = 2100;
            };
            2101 = @{
                'EntryType' = 'Warning';
                'Message'   = 'Failed to add namespace configuration for command aliases, as an identical namespace was already added';
                'Details'   = 'This warning occurs while the REST-Api is trying to auto-load different resources automatically to provide for example command aliases for providing inventory information or any other auto-loaded configurations. Please review your installed modules, check the detailed description which modules and Cmdlets caused this conflict and either resolve it or get in contact with the corresponding developers.';
                'EventId'   = 2101;
            };
        }
    };
}
