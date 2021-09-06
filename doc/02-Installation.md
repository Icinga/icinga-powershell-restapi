# Installation

To install this [Icinga for Windows](https://icinga.com/docs/icinga-for-windows) component, you can use the [official Icinga repositories](https://packages.icinga.com/IcingaForWindows/). You can read more about this on how to [install components](https://icinga.com/docs/icinga-for-windows/latest/doc/110-Installation/20-Install-Components/) for adding existing repositories or [create own repositories](https://icinga.com/docs/icinga-for-windows/latest/doc/110-Installation/07-Create-Own-Repositories/).

## General Note on Installation/Updates

You should always stick to one way of installing/updating any modules for the [Icinga for Windows](https://icinga.com/docs/icinga-for-windows) solution. It is **not** supported and **not** recommended to mix different installation methods.

## Install Stable Version

```powershell
Install-IcingaComponent -Name 'restapi';
```

## Install Snapshot Version

```powershell
Install-IcingaComponent -Name 'restapi' -Snapshot;
```

## Install Stable Updates

```powershell
Update-Icinga -Name 'restapi';
```

## Install Snapshot Updates

```powershell
Update-Icinga -Name 'restapi' -Snapshot;
```

## Daemon Registration

In order make use of the REST-Api, you will have to register it into the background daemon of the [Icinga PowerShell Service](https://icinga.com/docs/windows/latest/service)  for the [Icinga PowerShell Framework](https://icinga.com/docs/windows).

### Arguments

The REST-Api daemon will provide a bunch of arguments for configuring it

| Argument       | Type    | Required | Default | Description |
| ---            | ---     | ---      | ---     | ---         |
| Address        | String  | no       | ''      | Allows to specify on which Address a socket should be created on. Defaults to `loopback` if empty
| Port           | Integer | yes      | 5668    | The port the REST-Api will bind to |
| CertFile       | String  | no       | null    | The full path to a server certificate located on the local disk (.pfx, .crt, .cert) |
| CertThumbprint | String  | no       | null    | A thumbprint for a server certificate to use from the Windows Cert Store |
| RequireAuth    | Bool    | no       | False    | Enables or disables basic auth for accessing the API. To login you will either have to use a local Windows account or a Domain account. Domain account usernames have to be provided as `domain\user` while trying to login |

**Note:** `CertFile` and `CertThumbprint` are optional. By default the module will use the Icinga 2 Agent certificate which is located automatically. In case the Agent is not installed and/or certificates are not created yet, the daemon will not start.

### Important Notice

If you are running Icinga for Windows v1.6.0 or later and use the JEA profile, you will have to use `Install-IcingaForWindowsCertificate` to either install the Icinga Agent certificate as API certificate or a custom one. Your REST-Api certificate configuration is then ignored. This command provides the arguments `CertFile` and `CertThumbprint` with the same behavior as the REST daemon, but will always enforce the local installed certificate over your REST daemon configuration.

### Registration

To register the REST-Api as background daemon, you can use the PowerShell Frameworks integrated Cmdlet

```powershell
Use-Icinga;
Register-IcingaBackgroundDaemon -Command 'Start-IcingaWindowsRESTApi';
```

To modify the arguments during startup of the daemon, you can provide them as hashtable

```powershell
Use-Icinga;
Register-IcingaBackgroundDaemon -Command 'Start-IcingaWindowsRESTApi' -Arguments @{ '-Port' = 5669; '-CertFile' = 'path/to/your/cert/file' };
```

## Enable Basic Auth

To enable the basic auth for using the API you will have to set the `RequireAuth` argument to true while registering the daemon

```powershell
Use-Icinga;
Register-IcingaBackgroundDaemon -Command 'Start-IcingaWindowsRESTApi' -Arguments @{ '-RequireAuth' = $TRUE };
```

Once activated users will have to authenticate with either a local Windows machine account or by using domain credentials. The username for using domain accounts have to follow the following syntax: `domain\user`.

Please note that by using domain accounts your Windows host will require to be in the same domain or has access to the used domain for authentication.

## Restart the PowerShell Service

Once installed, we are ready to go and can simply restart our Icinga PowerShell daemon.

```powershell
Restart-IcingaWindowsService;
```

Afterwards our API should start just fine and be reachable on the provided port.

## API documentation

As we are now ready and our service is restarted, we can start [using the API](03-API-Documentation.md)
