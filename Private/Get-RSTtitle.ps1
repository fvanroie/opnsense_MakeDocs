function Get-RSTtitle ($title, $char = '-') {
    if ($title -and $title -ne '') {
        return $title, ($(1..$Title.length | foreach-object { $char }) -join ''), ''
    }
}