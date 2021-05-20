#Version 0.1.0
#Updated 2021-05-20

function Prompt {

    #Force .NET and PS Dirs to match
    [Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem | Select-Object -ExpandProperty Path);
    $env:COMPUTERNAME + "\" + (Get-Location) + "> "
}

<# notes:
* install modules?
** getdirectory
** dbatools

* profile colours
* oh my posh?
#>
