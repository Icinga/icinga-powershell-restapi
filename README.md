# Deprecation Notice

This repository is deprecated and no longer required, as starting with Icinga for Windows v1.7.0 the REST-Api is a core module of the [icinga-powershell-framework](https://github.com/Icinga/icinga-powershell-framework) and natively included.

If you have Icinga for Windows v1.7.0 or later installed, you can uninstall the component by using

```powershell
Uninstall-IcingaComponent -Name 'restapi'
```

# Icinga PowerShell RESTApi

This repository provides a REST-Api module for the [Icinga PowerShell Framework](https://icinga.com/docs/windows). In combination with other PowerShell Modules you can register endpoints to fetch information, to execute checks or trigger additional actions.

Before you continue, please take a look on the [installation guide](doc/02-Installation.md)

## Documentation

Please take a look on the following content for installation and documentation:

* [Introduction](doc/01-Introduction.md)
* [Installation Guide](doc/02-Installation.md)
* [API documentation](doc/03-API-Documentation.md)
* [Whitelists and Blacklists for Commands](doc/04-Whitelist-and-Blacklists-for-Commands.md)
* [Eventlog](doc/20-Eventlog.md)
* [Changelog](doc/31-Changelog.md)

## Contributing

The Icinga for Windows solution is an Open Source project and lives from your contributions. No matter whether these are feature requests, issues, translations, documentation or code.

* Please check whether a related issue already exists on our [Issue Tracker](https://github.com/Icinga/icinga-powershell-restapi/issues)
* Send a [Pull Request](https://github.com/Icinga/icinga-powershell-restapi/pulls)
* The master branch shall never be corrupt!
