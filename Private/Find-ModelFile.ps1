Function Find-ModelFile {
    param (
        [String[]]$BaseFolder = 'C:\opnsense'
    )
    foreach ($folder in $Basefolder) {
        Get-ChildItem -Recurse -Path "$folder/*.xml" -Exclude Menu.xml, ACL.xml, forms, tests | Select-Object -ExpandProperty fullname
    }
}