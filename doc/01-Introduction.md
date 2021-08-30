Introduction
===

This PowerShell module will provide a REST-Api for the [Icinga PowerShell Framework](https://icinga.com/docs/windows). By installing this module, you can access information over simple REST-Calls from your browser or other webtools, once corresponding modules to provide these information are installed.

The following requirements have to be fulfilled:

* Windows 7 / Windows 2008 R2 or later
* PowerShell Version 4.x or higher
* [Icinga PowerShell Framework](https://icinga.com/docs/windows) (>= 1.1.0) installed
* [Icinga PowerShell Service](https://icinga.com/docs/windows/latest/service) installed
* Additional modules actually providing REST endpoints

**Important Notice**

If you are running Icinga for Windows v1.6.0 or later and use the JEA profile, you will have to use `Install-IcingaForWindowsCertificate` to either install the Icinga Agent certificate as API certificate or a custom one. Your REST-Api certificate configuration is then ignored.

If you are ready to get started, take a look at the [installation guide](02-Installation.md).
