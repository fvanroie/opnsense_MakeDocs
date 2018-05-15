
Function Get-NoteProperty {
    [CmdletBinding()]
    param (
        [psobject]$obj
    )
    return Get-Member -InputObject $obj -MemberType NoteProperty | Select-Object -ExpandProperty Name
}