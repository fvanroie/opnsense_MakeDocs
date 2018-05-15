Function Update-ApiReference {
    [CmdletBinding()]Param (
        [String]$DocsPath = 'C:\opnsense\opnsense_docs',
        [String]$CorePath = 'C:\opnsense\opnsense_core',
        [String]$PluginPath = 'C:\opnsense\opnsense_plugins',
        [String]$Server = 'https://opnsense.localdomain',
        [String]$Key,
        [String]$Secret
    )

    # Model XML for schemas
    $files = Find-ModelFile $CorePath, $PluginPath |
        Where-Object { 
        $_ -like '*models*' -and $_ -notlike '*tests*' -and 
        ($_ -notlike '*net\frr*' -or $_ -notlike '*net/frr*') } |
        Where-Object {
        $_ -notlike "sysutils\monit\src\opnsense\mvc\app\models\OPNsense\Monit\Monit.xml" -or
        $_ -notlike "sysutils/monit/src/opnsense/mvc/app/models/OPNsense/Monit/Monit.xml" }       # Duplicate Monit !!
    $params = Get-ModelParameter $files
    
    # Form XML for descriptions
    $files = Find-FormFiles $CorePath, $PluginPath
    $forms = Get-FormFields $files


    $Modules = Get-NoteProperty $OPNsenseItemMap
    $Modules += Get-NoteProperty $OPNsenseSettingMap.Settings
    $Modules += Get-NoteProperty $OPNsenseServiceMap.Services
    $Modules = $modules | Group-Object | Select-Object -ExpandProperty Name | Sort-Object   # Unique modules

    foreach ($Module in $Modules) {
        if ($module -in 'minimumversion', 'maximumversion', 'settings', 'services', 'items') { continue }
 
        # Initialize the RST page data
        $Object = ""
        $rstdata = @()
        $divider = $false

        # Page Title
        $rstdata += Get-RSTtitle $Module '~'

        # Module has Services
        if ($OPNsenseServiceMap.Services.$Module) {
            # Services Headers
            $rstdata += Get-RSTtitle 'Service' '='

            #$rstdata += Get-RSTtitle 'Service Endpoints' '-'
            $rstdata += Get-RSTapis '' $OPNsenseServiceMap.Services.$Module.commands
            $rstdata += Get-RSTexample $OPNsenseServiceMap.Services.$Module.commands '-' $server $key $secret

            $divider = $true        # Start next section with divider if needed
        }

        # Module has Settings
        if ($OPNsenseSettingMap.Settings.$Module) {
            if ($divider) {
                $rstdata += "------------------------------`n`n"
            }

            # Settings Header
            $rstdata += Get-RSTtitle 'Settings' '='
        
            foreach ($Object in (Get-NoteProperty $OPNsenseSettingMap.Settings.$Module)) {
                if ($Object -in 'plugin') { continue }

                $OPNobject = $OPNsenseSettingMap.Settings.$Module.$Object
                #$objectname = $OPNobject.objectname
                $mount = $OPNsenseSettingMap.Settings.$Module.$Object.mountpoint

                # Subtitle
                $rstdata += Get-RSTtitle $Object '-'
                $rstdata += Get-RSTapis $Object $OPNsenseSettingMap.Settings.$Module.$Object.commands        
                
                $parameters = $params | Where-Object { $_.mount -eq $mount }  #Get-ModelParameter $modelfile
                $formfields = $Forms | Where-Object { $_.module -eq $Module -And $_.Object -eq $Object }
                $rstdata += Get-RSTdefinition $parameters $Mount $formfields '^'

                $rstdata += Get-RSTexample $OPNsenseSettingMap.Settings.$Module.$Object.commands '^' $server $key $secret
            }
            $divider = $true        # Start next section with divider if needed
        }

        # Module has Items
        if ($OPNsenseItemMap.$Module) {
            if ($divider) {
                $rstdata += "------------------------------`n`n"
            }

            # Items Header
            $rstdata += Get-RSTtitle 'Resource Items' '='
        
            foreach ($Object in (Get-NoteProperty $OPNsenseItemMap.$Module)) {
                $namespace = "$Module`.$Object"
                $OPNobject = $OPNsenseItemMap.$Module.$Object
                #$objectname = $OPNobject.objectname
                $mount = $OPNsenseItemMap.$Module.$Object.mountpoint

                # Subtitle
                $rstdata += Get-RSTtitle $Object '-'
                $rstdata += Get-RSTapis $NameSpace $OPNsenseItemMap.$Module.$Object #.commands          
                
                $parameters = $params | Where-Object { $_.mount -eq $mount }  #Get-ModelParameter $modelfile
                $formfields = $Forms | Where-Object { $_.module -eq $Module -And $_.Object -eq $Object }
                $rstdata += Get-RSTdefinition $parameters $Mount $formfields '^'

                $rstdata += Get-RSTexample $OPNsenseItemMap.$Module.$Object '^' $server $key $secret   #.commands
            }
        }

        if ($Module -in 'Firmware', 'CaptivePortal', 'Cron', 'Diagnostics', 'IDS', 'Menu' , 'Proxy', 'Routes', 'TrafficShaper') {
            $folder = 'core'
        } else {
            $folder = 'plugins'
        }

        $filename = "{0}\{1}\{2}.rst" -f $DocsPath, $folder, $Module.ToLower()
        Write-Host -ForegroundColor Cyan "Writing rST output to $filename"
        $rstdata | Out-File -Encoding default -FilePath $filename
    }
}