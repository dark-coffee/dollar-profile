function Prompt {
[Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem | Select-Object -ExpandProperty Path);
$env:COMPUTERNAME + "\" + (Get-Location) + "> "
}