#Version 0.1.5
#Updated 2021-06-01

#Clear the gubbins and inform usr of update check
Clear-Host
Write-Host 'Welcome back, Andy!'
Write-Host '----------------------------------'
Write-Host 'Checking for profile updates . . .'

#Profile URL
$GithubFileURL = 'https://raw.githubusercontent.com/dark-coffee/dollar-profile/main/profile.ps1'

#Define Files
$GithubFile = Invoke-WebRequest $GithubFileURL | Select-Object -ExpandProperty Content;
$ProfileFile = Get-Content $PROFILE;

#Pull Versions from Files
$CurrentVersion = $ProfileFile[0] -replace '#Version '
$GitVersion = $GithubFile[9..14] | Join-String

#Feed back to screen
Write-Host ''
Write-Host "Current profile version: $CurrentVersion"
Write-Host "Github profile version:  $GitVersion"

#Update Mechanism
If($GitVersion -gt $CurrentVersion){
    $UserChoice = Read-Host -Prompt 'Newer Version Found, Install? (Y)'
    If(($UserChoice -eq "Y") -or ($UserChoice -eq "")){
        try{
            Start-BitsTransfer -Source $GithubFileURL -Destination $PROFILE -ErrorAction Stop
            Write-Host 'Updated!'
        }
        catch{
            Write-Host "Uh Oh! We hit an error :("
        }
    }
}else{
    Write-Host "PowerShell profile up-to-date!"
}
Write-Host '----------------------------------'

#Prompt

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
Import-Module posh-git;
Import-Module oh-my-posh;
Set-PoshPrompt -theme Paradox;
#Clear-Host;