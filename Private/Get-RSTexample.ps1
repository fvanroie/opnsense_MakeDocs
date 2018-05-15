function Get-RSTexample {
    Param (
        [Object]$data,
        [String]$char = '-',
        [String]$server,
        [String]$key,
        [String]$secret
    )

    if (-not $data) { return $null }
    $examplenum = 0

    # Make Credentials
    $SecurePassword = $Secret | ConvertTo-SecureString -AsPlainText -Force
    $apiCred = New-Object System.Management.Automation.PSCredential -ArgumentList $Key, $SecurePassword

    foreach ($item in $data) {
        foreach ($cmd in 'get', 'start', 'status', 'reconfigure') {
            if (-not $item.$cmd) { continue }

            $Module, $Controller, $Command, $params = Get-ApiCommand $item.$cmd

            if (-not $item.$cmd.method) {
                if ($item.$cmd.command.form -or $item.$cmd.command.json) {
                    $method = 'POST'
                } else {
                    if ($command -in 'add', 'del', 'remove', 'set') {
                        $method = 'POST'
                    } else {
                        $method = 'GET'
                    }    
                }

                # $item.$cmd.command | Add-Member -MemberType NoteProperty -Name Method -Value $method
            }
            
            $url = 'https://opnsense.localdomain/api/{0}/{1}/{2}/{3}' -f $Module, $Controller, $Command, $params
            $curl = $('$ curl "{0}" \' -f $url), '              --user "$key":"$secret"'
            if ($method -ne 'GET') { $curl[1] += " --request $method" }

            # Live API data capture !!
            $url = "{4}/api/{0}/{1}/{2}/{3}" -f $Module, $Controller, $Command, $params, $server
            $url = $url.replace('{uuid}', '')
            $header, $code = Get-CurlOutput $url $method $apiCred

            $examplenum++
            Get-RSTtitle 'Example' $char            #"Example {0}:" -f $examplenum
            Get-Rstcodeblock console $curl
            
            Get-RSTtitle 'Response' $char
            Get-Rstcodeblock text $header
            Get-Rstcodeblock json $code

            # Only show the first example, then return
            return
            if ($cmd -in 'status', 'reconfigure') { return }
        }
    }
}