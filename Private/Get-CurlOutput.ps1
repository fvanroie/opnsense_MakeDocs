Function Get-CurlOutput ($uri, $method, [pscredential]$apiCred) {
    Write-Host -ForegroundColor Green "   - $method`t$uri"
    try {
        $result = Invoke-WebRequest -Uri $uri -Credential $apiCred -SkipCertificateCheck -Authentication Basic -Method $method -ErrorVariable err -ErrorAction Stop

        return @(
            ('HTTP/1.1 {0} {1}' -f $result.StatusCode, $result.StatusDescription),
            ('Content-Type: {0}' -f $result.Headers.'Content-Type')
        ), $result.content
    } catch {
        Write-Warning ($err.message)
        return @(
            ('HTTP/1.1 {0} {1}' -f $err.ErrorRecord.Exception.Response.StatusCode.value__, $err.ErrorRecord.Exception.Response.ReasonPhrase),
            ('Content-Type: {0}' -f ($err.ErrorRecord.Exception.Response.Content.Headers | Where-Object { $_.key -eq 'Content-Type' } | Select-Object -ExpandProperty Value))
        ), $err.message
    }
}