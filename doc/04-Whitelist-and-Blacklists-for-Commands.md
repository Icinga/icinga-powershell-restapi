# Whitelists and Blacklists for Commands

The REST-Api module allows to register multiple endpoints which can be accessed from either locally only or from remote hosts. In case you allow the execution of commands, we highly advice all developers to use the `Whitelist` and `Blacklist` feature for generic approaches, like our [Icinga for Windows Api-Checks](https://github.com/Icinga/icinga-powershell-apichecks/blob/master/doc/) module.

The idea is to give users the flexibility and security to restrict which commands can be executed.

## General

Within the configuration you can define whitelists and blacklists for multiple endpoints. If you installed our [Icinga for Windows Api-Checks](https://github.com/Icinga/icinga-powershell-apichecks/blob/master/doc/) module, the REST-Api endpoint for this is called `apichecks`. We will move forward with this module as example for this documentation.

In addition to add fixed commands, like `Invoke-IcingaCheckCPU` you can also use wildcards for filtering, like `Invoke-IcingaCheck*` or `*Framework*`. This works for both, whitelist and blacklist.

Regardless of your whitelist settings, blacklisted entries will always be processed prior to whitelists. If a whitelisted command is also added on the blacklist, it will not be executed. If a command is not matching a blacklist or a whitelist filter, it will not be executed as well and handled as being blacklisted.

## Add Whitelisted Command

To add a command to your whitelist, you can call the following command: `Add-IcingaRESTApiCommand`

As mentioned above, we can add a wildcard for commands, or single commands:

```powershell
Add-IcingaRESTApiCommand -Command 'Invoke-IcingaCheck*' -Endpoint 'apichecks';
Add-IcingaRESTApiCommand -Command 'Test-IcingaAgent' -Endpoint 'apichecks';
```

## Add Blacklisted Command

The command to manage your blacklist and whitelist are identical, with the exception of the `-Blacklist` argument at the end. Lets assume you do not want your certificate check to be executed:

```powershell
Add-IcingaRESTApiCommand -Command 'Invoke-IcingaCheckCertificate' -Endpoint 'apichecks' -Blacklist;
```

## Test Commands

In order to verify your configuration, you can use the `Test-IcingaRESTApicommand` Cmdlet with a given command and endpoint. The function will either return `1` if the command can be executed and `0` if the execution is forbidden.

```powershell
Test-IcingaRESTApiCommand -Command 'Invoke-IcingaCheckCertificate' -Endpoint 'apichecks';
```

## Remove Commands

Of course, you can also remove commands from an endpoint and the whitelist or blacklist. The process is similar to `Add-IcingaRESTApiCommand`, but we call `Remove-IcingaRESTApiCommand` instead. Lets assume we want to remove the `Test-IcingaAgent` Cmdlet from our whitelist we added in the first example:

```powershell
Remove-IcingaRESTApiCommand -Command 'Test-IcingaAgent' -Endpoint 'apichecks';
```

## Show Configured Commands

Last but not least you can get an overview on how the current configuration looks like by running:

```powershell
Show-IcingaApiCommands;
```

You will receive a list of all Api endpoints configured including commands added on the whitelist and blacklist.
