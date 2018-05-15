## Prerequisites

* PowerShell Core needs to be installed on your system.

### Clone the PowerShell Module:

```
cd tmp
git clone https://github.com/fvanroie/opnsense_MakeDocs.git
```

### Clone the OPNsense Core, Plugins and Docs repos:
```
git clone https://github.com/opnsense/core.git
git clone https://github.com/opnsense/plugins.git
git clone https://github.com/opnsense/docs.git
```

### Usage:

Run this command in PowerShell Core 6.0.0 or higher:
```
pwsh

PS >
```

On Windows:
```
# Module Requires PowerShell Core to run:
Import-Module .\opnsense_MakeDocs\OPNsense_MakeDocs.psd1

$Options = @{
    'Server'     = "https://test-server.local"    # All example API commands are run against this server!
    'Key'        = $key
    'Secret'     = $secret
    'DocsPath'   = 'docs\source\development\api'  # Write rST Files here!
    'CorePath'   = 'core'                         # Read Sources
    'PluginPath' = 'plugins'                      # Read Sources
}

Update-ApiReference @Options
```

On Linux:
```
Import-Module ./opnsense_MakeDocs/OPNsense_MakeDocs.psd1

$Options = @{
    'Server'     = "https://test-server.local"     # All example API commands are run against this server!
    'Key'        = $key
    'Secret'     = $secret
    'DocsPath'   = 'docs/source/development/api/'  # Write rST Files here!
    'CorePath'   = 'core'                          # Read Sources
    'PluginPath' = 'plugins'                       # Read Sources
}

Update-ApiReference @Options
```

Optionally add a build of the html pages using docker:
```
sudo docker run --rm -v "$pwd/docs:/docs" alphakilo/opnsense-sphinx-doc:latest

ls -laR $pwd/docs/build/html/development/api
```