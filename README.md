### Usage:

Run this command in PowerShell Core 6.0.0 or higher:

```
# Module Requires PowerShell Core to run:
Import-Module OPNsense_MakeDocs

$Options = @{
    'Server'="https://test-server.local"
    'Key'= $key
    'Secret' = $secret
    'DocsPath'   = 'U:\opnsense\myfork\opnsense_docs\source\development\api'
    'CorePath'   = 'U:\opnsense\18.1\core\'
    'PluginPath' = 'U:\opnsense\18.1\plugins\'
}

Update-ApiReference @Options
```