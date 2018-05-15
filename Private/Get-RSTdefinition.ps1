function Get-RSTdefinition ($parameters, $caption, $forms, $char = '-') {
    # Escape backslashes in table caption namespace
    if ($caption) {
        $caption = $caption.replace('\\', '\\\').replace('\', '\\')
    }

    $header = @"
.. csv-table:: $caption
   :header: "Name", "Type", "Default", "Description"
   :widths: 20, 10, 10, 50

"@

    foreach ($item in $parameters) {
        # Convert Data TypeName to logical one
        $item | add-member -MemberType NoteProperty -Name NewType -Value $( Get-datatype $item)[3] -Force

        # Put asterisk on required parameters
        if ($item.required -eq 'Y') {
            $ParamName = '{0} *' -f $item.parameter
        } else {
            $ParamName = $item.parameter
        }
        $item | add-member -MemberType NoteProperty -Name ParamName -Value $ParamName -Force
        
        # Add Description based on Firm Data
        $Field = $forms | Where-Object { $_.Field -eq $item.parameter }
        $Description = '{0}' -f $Field.Label

        if ($Description -in '', $item.Parameter -And $('{0}' -f $Field.Help) -ne '') {
            $Description = '{0}' -f $Field.Help
        }

        if ($Description -eq '' -and $item.Type -eq 'UniqueIdField') {
            $Description = 'Auto-generated Unique Identifier (not UUID)'
        }

        $item | add-member -MemberType NoteProperty -Name Description -Value $Description -Force

        # Escape asterisk, otherwise this converts to a bullet in RST
        if ($item.default -eq '*') {$item.default = '\*'}

        #$item | add-member -MemberType NoteProperty -Name Contraints -Value $item.mask -Force
    }

    $csv = ($parameters |
            Sort-Object Parameter |             # Sort by parameter name first
            Group-Object Required |             # then, Group-by required
            Sort-Object Name -Descending |      # Sort required first
            ForEach-Object { $_.group } |       # Unpack group in alphabetical order
            Select-Object -Property ParamName, NewType, @{ name = 'Default'; exp = { '{0}' -f $_.Default } }, Description |
            ConvertTo-Csv -NoTypeInformation |  # As CSV
            Select-Object -Skip 1 |             # Skip Header
            ForEach-Object { "   {0}" -f $_ }   # indent for RST
    )
    
    # Output data if there is a schema to be exported
    if ($csv) {
        Get-RSTtitle 'Schema' $char
        $header
        $csv
        ''
    }
}