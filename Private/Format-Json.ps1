# Formats JSON in a nicer format than the built-in ConvertTo-Json does.
function Format-Json([Parameter(Mandatory, ValueFromPipeline)][String] $json, $numSpaces = 4) {
    # Prettify JSON object
    # Workaround for bug in Convert-JSON cmdlets
    try {
        $json = ConvertFrom-Json -InputObject $json | ConvertTo-Json -Depth 20
    } catch {
        $json = $json.Replace('"":"', '"^":"')
        $json = $json.Replace('"":{', '"^":{')
        $json = ConvertFrom-Json -InputObject $json | ConvertTo-Json -Depth 20
        $json = $json.Replace('"^":', '"": ')
    }

    $indent = 0
    $json = ($json -Split '\r\n' | ForEach-Object {
            #Write-Warning "$indent $line"
            if ($_ -match '[\}\]][, ]?$' -and $_ -notmatch '": [\{\[]') {
                # This line contains  ] or }, decrement the indentation level
                $indent--
            }
            $line = (' ' * $indent * $numSpaces) + $_.TrimStart().Replace(':  ', ': ')
            $line = $line.TrimEnd()
            if ($_ -match '[\{\[][, ]?$' -and $_ -notmatch '[\}\]][,\n ]') {
                # This line contains [ or {, increment the indentation level
                $indent++
            }
            $line
        }
    ) -Join "`n"

    $lines = $json -split "`n" | Measure-Object | Select-Object -ExpandProperty Count
    if ($lines -le 3) {
        $json = $($json -split "`n" | ForEach-Object { $_.trimstart() }) -Join " "
        $json
    } else {
        # More compact OPNsense selection lists
        $json = $json -replace '(?ms)\n\s+"value": "(.*?)",\n\s+"selected": ([01])\n\s+}', ' "value": "$1", "selected": $2 }'
        $json -Split '\n'
    }
}
