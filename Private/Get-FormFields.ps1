Function Get-FormFields ($files) {
    $forms = foreach ($file in $files) {
        [xml]$xml = Get-Content $file
        if ($file.FullName -match '[\\/]controllers[\\/]OPNsense[\\/](.*)[\\/]forms[\\/]') {
            $Module = $Matches[1]
        } else {
            $Module = ''
        }
        $xml.form.field | Where-Object { $_.type -notin 'info', 'header' } |
            Add-Member -MemberType NoteProperty -Name Module -Value $Module -PassThru |
            Add-Member -MemberType NoteProperty -Name Filename -Value $File.FullName -PassThru
    }

    foreach ($form in $forms) {
        $object, $field = $form.id.split('.', 2)
        $form | Add-Member -MemberType NoteProperty -Name Object -Value $Object
        $form | Add-Member -MemberType NoteProperty -Name Field -Value $Field
    }
    $forms
}