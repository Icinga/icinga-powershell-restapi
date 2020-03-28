# API Documentation

The REST-Api will only provide the actuall endpoint to communicate with in general. Every single endpoint for fetching data has to be provided by modules which are installed separately.

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
