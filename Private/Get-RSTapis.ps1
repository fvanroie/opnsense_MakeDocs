function Get-RSTapis ($namespace, $data) {
    if (-not $data) { return $null }
    $header = @"
.. csv-table::
   :header: "Method", "Module", "Controller", "Command", "Parameters"
   :widths: 10, 20, 20, 30, 30

"@

    # $data is .commands node
    $keys = Get-NoteProperty $data
 
    $csv = ForEach ($key in $keys) {
        if (-not $data.$key.command) { Continue }

        if (-not $data.$key.method) {
            if ($data.$key.command.form -or $data.$key.command.json) {
                $method = '``POST``'
            } else {
                if ($command -in 'add', 'del', 'remove', 'set') {
                    $method = '``POST``'
                } else {
                    $method = '``GET``'
                }    
            }
            $data.$key.command | Add-Member -MemberType NoteProperty -Name Method -Value $method -Force
        }

        $apiCommand, $Params = $data.$key.command.command -split '/', 2
        if ($params) {
            $params = $params.replace('<', '{').replace('>', '}')
        }
        $data.$key.command | Add-Member -MemberType NoteProperty -Name Method -Value $method -Force
        $data.$key.command | Add-Member -MemberType NoteProperty -Name ApiCommand -Value $apiCommand -Force
        $data.$key.command | Add-Member -MemberType NoteProperty -Name Params -Value $params -Force

        $data.$key.command |
            Select-Object -Property Method, Module, Controller, ApiCommand, Params |
            ConvertTo-Csv -NoTypeInformation |
            Select-Object -Skip 1 |
            ForEach-Object { "   {0}" -f $_ }
    }

    if ($csv) {
        return $header, $csv, ''
    }
}
