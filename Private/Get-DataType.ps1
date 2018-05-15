Function Get-DataType {
    Param ($param)

    # c#, powershell, default unspecified value, openapi

    switch ($param.type) {
        'BooleanField' { return @('boolean', 'bool', 'false', 'boolean')}
        'AutoNumberField' { 
            return @('integer', 'int', '0', 'integer')
        }
        'IntegerField' { 

            if ($param.minimumvalue -and $param.minimumvalue -ge 0) {
                #unsigned
                if ($param.maximumvlaue) {

                    if ($param.maximumvalue -gt 4294967295) {
                        return @('uint64', 'uint64', '0', 'integer')
                    }
                    if ($param.maximumvalue -gt 65535) {
                        return @('uint', 'uint', '0', 'integer')
                    }
                    if ($param.maximumvalue -gt 255) {
                        return @('uint16', 'uint16', '0', 'integer')
                    }
                    return @('byte', 'byte', '0', 'integer')

                } else {
                    # unknown max, use 32 bits
                    return @('uint', 'uint', '0', 'integer')
                }

            }
            #signed

            if ($param.maximumvlaue) {

                if ($param.maximumvalue -gt 2147483647) {
                    return @('int64', 'int64', '0', 'integer')
                }
                if ($param.maximumvalue -gt 32767) {
                    return @('int', 'int', '0', 'integer')
                }
                if ($param.maximumvalue -gt 127) {
                    return @('int16', 'int16', '0', 'integer')
                }
                return @('sbyte', 'sbyte', '0', 'integer')

            } else {
                # unknown max, use 32 bits
                return @('int', 'int', '0', 'integer')
            }

        }

        'CSVListField' { return @('Object', 'Object', 'null', 'object')} # System.Object without [] !!

        'EmailField' { return @('String', 'string', 'null', 'string')}
        'HostnameField' { return @('String', 'string', 'null', 'string')}
        'TextField' { return @('String', 'string', 'null', 'string')}
        'UniqueIdField' { return @('String', 'string', 'null', 'string')}
        'UrlField' { return @('String', 'string', 'null', 'string') }

        'CertificateField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'ConfigdActionsField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'InterfaceField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'JsonKeyValueStoreField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'ModelRelationField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'NetworkField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'OptionField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'PortField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'System.Object[]' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'AuthenticationServerField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'AuthGroupField' { return @('PSCustomObject', 'PSObject', 'null', 'object')}
        'CountryField' { return @('PSCustomObject', 'PSObject', 'null', 'object') }
        default {
            # unknwon type }
            #return @('unknown', 'unknown', 'unknown', 'unknown')
        }
    }
    throw ("Unknow dataype {0} for parameter {1} encountered!" -f $param.type, $param.parameter)
}