# Returns the 4 parts that make up the api URL
function Get-ApiCommand($obj) {
    $apiCommand, $Params = $obj.command.command -split '/', 2
    if ($params) {
        $params = $params.replace('<', '{').replace('>', '}')
    }
    return $obj.command.Module, $obj.command.Controller, $apiCommand, $Params
}