# Installation

Like any other PowerShell module, the installation itself is very simple and straight forward. As of before, there are many ways to deploy a PowerShell module on a Windows host.

Regardless of the method: In order to make this module work properly, you will have to install it into the same folder as your [Icinga PowerShell Framework](https://icinga.com/docs/windows) module is installed to.

If you installed the Framework into

```text
C:\Program Files\WindowsPowerShell\Modules\
```

you will have to install this module there as well.

## General Note on Installation/Updates

You should always stick to one way of installing/updating any modules for the Icinga for Windows solution. It is **not** supported and **not** recommended to mix installation ways by using `PowerShell Gallery` initially and switch to the `Framework Component Installer` for example later on.

There might be various side effects by doing so.

### PowerShell Gallery

One of the simplier ways is to use PowerShell Gallery for the installation. For this we simply run the command

```powershell
Install-Module 'icinga-powershell-restapi';
```

### Icinga Framework Component Installer

If PowerShell Gallery is no option for you because it is not available or you prefer the installation from GitHub releases directly, you can use the component installer of the Icinga PowerShell Framework which was introduced with `v1.1.0`:

Install latest stable:

```powershell
Use-Icinga;
Install-IcingaFrameworkComponent -Name restapi -Stable;
```

Install latest snapshot

```powershell
Use-Icinga;
Install-IcingaFrameworkComponent -Name restapi -Snapshot;
```

Custom repository source

```powershell
Use-Icinga;
Install-IcingaFrameworkComponent -Name restapi -Url 'url to your .zip file';
```

### Manual Installation

For manual installation either download the [latest release .zip](https://github.com/Icinga/icinga-powershell-restapi/releases) or the [latest master .zip](https://github.com/Icinga/icinga-powershell-restapi) and extract the content into the correct PowerShell modules folder.

This could for example be:

```powershell
C:\Program Files\WindowsPowerShell\Modules
```

Please ensure that the folder name of the module is matching the `.psm1` file name inside the folder.

By downloading the latest master and unzipping it into above mentioned folder, you might end up like this:

```powershell
C:\Program Files\WindowsPowerShell\Modules\icinga-powershell-restapi-master
```

As our `.psm1` file is named `icinga-powershell-restapi.psm1` we will have to rename the folder to look like this:

```powershell
C:\Program Files\WindowsPowerShell\Modules\icinga-powershell-restapi
```

Once this is done, we might require to unblock the file content to be able to load and execute the module

```powershell
Get-Content -Path 'C:\Program Files\WindowsPowerShell\Modules\icinga-powershell-restapi' -Recurse | Unblock-File;
```

Now we can start a new PowerShell instance and the module should be ready to go. Otherwise we have to import it manually by using

```powershell
Import-Module 'icinga-powershell-restapi';
```

## Daemon Registration

In order make use of the REST-Api, you will have to register it into the background daemon of the [Icinga PowerShell Service](https://icinga.com/docs/windows/latest/service)  for the [Icinga PowerShell Framework](https://icinga.com/docs/windows).

### Arguments

The REST-Api daemon will provide a bunch of arguments for configuring it

| Argument       | Type    | Required | Default | Description |
| ---            | ---     | ---      | ---     | ---         |
| Port           | Integer | yes      | 5668    | The port the REST-Api will bind to |
| CertFile       | String  | no       | null    | The full path to a server certificate located on the local disk (.pfx, .crt, .cert) |
| CertThumbprint | String  | no       | null    | A thumbprint for a server certificate to use from the Windows Cert Store |

**Note:** `CertFile` and `CertThumbprint` are optional. By default the module will use the Icinga 2 Agent certificate which is located automatically. In case the Agent is not installed and/or certificates are not created yet, the daemon will not start.

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

## Restart the PowerShell Service

Once installed, we are ready to go and can simply restart our Icinga PowerShell daemon.

```powershell
Restart-Service icingapowershell;
```

Afterwards our API should start just fine and be reachable on the provided port.

## API documentation

As we are now ready and our service is restarted, we can start [using the API](03-API-Documentation.md)
