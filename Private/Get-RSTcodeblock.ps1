Function Get-RSTcodeblock {
    param (
        $language,
        $code,
        $caption = $null,
        [int[]]$highlight = @()
    )

    ".. code-block:: $language"
    if ($caption) {
        '   :caption: {0}' -f $caption
    }
    if ($highlight) {
        '   :emphasize-lines: {0}' -f $($highlight -join ',')
    }
    ''

    if ($language -eq 'JSON') {
        try {
            $code = Format-Json $code       # Prettify JSON string   
        } catch {
            # Output as-is
        }
    }

    # Left indent with 3 spaces to match the codeblock indent, skip right-trimmed empty lines
    $code | ForEach-Object { $_.TrimEnd() } | Where-Object { $_ -ne '' } | ForEach-Object { '   {0}' -f $_ }

    ''
}