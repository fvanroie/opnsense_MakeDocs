Function Find-FormFiles {
    param (
        [String[]]$BaseFolder = 'C:\opnsense'
    )
    foreach ($folder in $Basefolder) {
        Get-ChildItem -Path "$folder/dialog*.xml" -Recurse | Where-Object { $_.Directory -like '*forms*' }
    }
}