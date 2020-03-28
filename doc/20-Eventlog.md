# RESTApi Eventlog Documentation

Below you will find a list of EventId's which are exported by this module. The short and detailed message are both written directly into the eventlog. This documentation shall simply provide a summary of available EventId's

## Event Id 2000

| Category | Short Message | Detailed Message |
| --- | --- | --- |
| Error | Failed to start REST-Api daemon, as no valid provided SSL and Icinga 2 Agent certificate was found | While starting the Icinga for Windows REST-Api daemon, no valid certificate was found for usage. You can either share a valid certificate by defining the full path with `-CertFile` to a .crt, .cert or .pfx file, by using `-CertThumbprint` to lookup a certificate inside the Microsoft cert store and by default the Icinga 2 Agent certificates. Please note that only Icinga 2 Agent version 2.8.0 or later are supported |

## Event Id 2100

| Category | Short Message | Detailed Message |
| --- | --- | --- |
| Warning | Failed to add namespace configuration for executed commands, as previous commands are reporting identical namespace identifiers | This warning occures while the REST-Api is trying to auto-load different ressources automatically to provide for example inventory information or any other auto-loaded configurations. Please review your installed modules, check the detailed description which moules and Cmdllets caused this conflict and either resolve it or get in contact with the corresponding developers. |

## Event Id 2101

| Category | Short Message | Detailed Message |
| --- | --- | --- |
| Warning | Failed to add namespace configuration for command aliases, as an identical namespace was already added | This warning occures while the REST-Api is trying to auto-load different ressources automatically to provide for example command aliases for providing inventory information or any other auto-loaded configurations. Please review your installed modules, check the detailed description which moules and Cmdllets caused this conflict and either resolve it or get in contact with the corresponding developers. |
