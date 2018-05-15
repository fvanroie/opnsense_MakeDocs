Function Find-ModelParameter {
    Param($obj,
        $file,
        $mount
    )
    if ($obj.type -and 'ArrayField' -notin $obj.type) {
        $name = Split-Path $mount -Leaf
        $mount = Split-Path $mount
        $mount2 = $mount.Replace('\\', '')
        $mount2 = $mount.Replace('\', '.')
        Write-Host -ForegroundColor green ("   - {0}`t{1} => {2}" -f $mount, $name, $obj.type)

        # Use case sensitive Names for C#
        switch ($name) {
            'as' { $name = 'AS' }
            'interface' { $name = 'Interface' }
            'operator' { $name = 'Operator' }
            default {}
        }

        $item = [PSCustomObject] @{
            'mount'             = $mount
            'parameter'         = $name
            'type'              = $obj.type
            'multiple'          = $obj.multiple
            'required'          = $obj.required
            'default'           = $obj.default
            'minimumvalue'      = $obj.minimumvalue
            'maximumvalue'      = $obj.maximumvalue

            'optionvalues'      = $obj.optionvalues

            'sourcefile'        = $obj.sourcefile
            'sourcefield'       = $obj.sourcefield

            'mask'              = $obj.mask
            'ValidationMessage' = $obj.validationmessage

            'wildcardsenabled'  = $obj.wildcardsenabled
            'netmaskrequired'   = $obj.netmaskrequired
            'fieldseperator'    = $obj.fieldseperator
            'constraints'       = $obj.constraints
            'changecase'        = $obj.changecase
            'filters'           = $obj.filters
            'model'             = $obj.model
            'selectall'         = $obj.selectall

            'file'              = $file
        }
        return $item


    } else {
        # ArrayField

        #$results = @()
        $items = $obj | Get-Member -Type "Property" | Select-Object -ExpandProperty "Name"
        foreach ($item in $items) {
            #$results += Find-ModelParameter $obj.$item $file "$mount/$item"
            Find-ModelParameter $obj.$item $file "$mount/$item"
        }
        #return $results
    }
}