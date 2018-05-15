### Usage:

Run this command in PowerShell Core 6.0.0 or higher:

```
# Module Requires PowerShell Core to run:
Import-Module OPNsense_MakeDocs

$Options = @{
    'Server'     = "https://test-server.local"          # All example API commands are run against this server!
    'Key'        = $key
    'Secret'     = $secret
    'DocsPath'   = 'C:\opnsense\opnsense_docs\source\development\api'      # Write Files here!
    'CorePath'   = 'C:\opnsense\opnsense_core\'         # Read
    'PluginPath' = 'C:\opnsense\opnsense_plugins\'      # Read
}

Update-ApiReference @Options
```