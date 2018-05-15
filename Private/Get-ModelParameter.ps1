Function Get-ModelParameter {
    Param(
        $FileList
    )

    foreach ($file in $FileList) {
        # Parse XML
        [xml]$xml = Get-Content -Path $file

        # Validate input
        if (-Not $xml.model) {
            Write-Warning ("{0} is not a model file" -f $file)
            Continue #with next file
        }

        # Extract Parameters
        Write-Host -ForegroundColor cyan $file
        Find-ModelParameter $xml.model.items $file $xml.model.mount
        Write-Host ''
    }
}