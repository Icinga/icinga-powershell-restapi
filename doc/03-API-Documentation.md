# API Documentation

The REST-Api will only provide the actual endpoint to communicate with in general. Every single endpoint for fetching data has to be provided by modules which are installed separately.

## Untrusted/Self-Signed Certificates

Using Self-Signed or Untrusted Certificates for running the API is in general supported and by default applied once the Icinga 2 Agent certificates are being used.

However, you will have to ensure your clients either trust the certificate or you enable insecure connections. This applies to web-toolkits, applications and browsers. Clients connecting with certificate validation checks will be invalidated, resulting in a terminated connection. After `6` corrupt connection attempts the remote client will be `blacklisted` and `banned` from accessing the API.

## REST-Api with JEA profile

If you are running Icinga for Windows v1.6.0 or later and use the JEA profile, you will have to use `Install-IcingaForWindowsCertificate` to either install the Icinga Agent certificate as API certificate or a custom one. Your REST-Api certificate configuration is then ignored. This command provides the arguments `CertFile` and `CertThumbprint` with the same behavior as the REST daemon, but will always enforce the local installed certificate over your REST daemon configuration.

### Clear Blacklist Cache

To clear the blacklist to allow blocked clients to connect again, you will have to restart the PowerShell daemon:

```powershell
Restart-IcingaWindowsService;
```

### Common Client examples

#### Curl with --insecure

To use curl with Self-Signed/Untrusted Certificates, use the `--insecure` argument:

```bash
curl -X GET "/v1/checker?command=cpu" --insecure
```

#### PowerShell without Validation

PowerShell is by default very strict when it comes to insecure connections. Within the PowerShell Framework itself, there is a Cmdlet available for this, allowing you to enable untrusted certificates within the current PowerShell session:

```powershell
Use-Icinga;
Enable-IcingaUntrustedCertificateValidation;

Invoke-WebRequest -Method GET -UseBasicParsing -Uri '/v1/checker?command=cpu';
```

## API Versioning

All API calls are defined behind the API version. Once changes to the API handler itself are made, the versioning will change, allowing full backward compatibility

```text
/v1/<endpoint>
```

## Query Endpoints

To view a list of available endpoints, simply query them by only using the API version on your web path

### Query

```text
/v1/
```

### Output

```json
{
    "Endpoints": [
        "<list of registered endpoints>"
    ]
}
```
