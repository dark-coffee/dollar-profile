#Version 0.1.2
#Updated 2021-05-24

#Profile URL
$GithubFileURL = 'https://raw.githubusercontent.com/dark-coffee/dollar-profile/main/profile.ps1'

#Define Files
$GithubFile = Invoke-WebRequest $GithubFileURL
$ProfileFile = Get-Content $PROFILE

#Pull Versions from Files
$CurrentVersion = $ProfileFile[0] -replace '#Version '
$GitVersion = $GithubFile[9..14] | Join-String

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
    Write-Host "We're up-to-date!"
}

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
