# OPNsenseMakeDocs

This PowerShell Module compiles an API Reference for OPNsense based on the source code.
The output is written as reStructuredText *(\*.rst)* files that can be compiled into html using Sphinx.

## Prerequisites

You need to have these packages installed on your system:
* PowerShell Core 6.0 or higher
* Git

Optional packages:
* Docker

## Setup

### Clone the PowerShell Module:

```
cd tmp
git clone https://github.com/fvanroie/opnsense_MakeDocs.git OPNsense_MakeDocs
```

### Clone the OPNsense Core, Plugins and Docs repos:
```
git clone https://github.com/opnsense/core.git
git clone https://github.com/opnsense/plugins.git
git clone https://github.com/opnsense/docs.git
```

## Usage:

Start PowerShell Core 6.0.0 or higher:
```
pwsh

PS >
```

Save the script below to build.ps1 while setting the option parameters to the correct settings for your build environment.

Use a **TEST server** for running the API examples. Changes can be made to the evironment while running the build!
*(like stopping or restarting services...)*

On Windows: .\build.ps1
```
# This Module Requires PowerShell Core to run:
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

On Linux: ./build.ps1
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

Optionally run a Sphinx build of the html pages using docker:
```
sudo docker run --rm -v "$pwd/docs:/docs" alphakilo/opnsense-sphinx-doc:latest

ls -laR $pwd/docs/build/html/development/api
```