#Version 0.1.8
#Updated 2021-06-01

#Clear the gubbins and inform usr of update check
Clear-Host;
Write-Host 'Welcome back, Andy!';
Write-Host '----------------------------------';
Write-Host 'Checking for profile updates . . .';

#Profile URL
$GithubFileURL = 'https://raw.githubusercontent.com/dark-coffee/dollar-profile/main/profile.ps1';

#Define Files
$GithubFile = Invoke-WebRequest $GithubFileURL | Select-Object -ExpandProperty Content;
$ProfileFile = Get-Content $PROFILE;

#Pull Versions from Files
$CurrentVersion = $ProfileFile[0] -replace '#Version ';
$GitVersion = $GithubFile[9..13] | Join-String;

#Feed back to screen
Write-Host '';
Write-Host "Current profile version: $CurrentVersion";
Write-Host "Github profile version:  $GitVersion";
Write-Host '';

#Update Mechanism
If($GitVersion -gt $CurrentVersion){
    $UserChoice = Read-Host -Prompt 'Newer Version Found, Install? (Y)';
    If(($UserChoice -eq "Y") -or ($UserChoice -eq "")){
        try{
            Start-BitsTransfer -Source $GithubFileURL -Destination $PROFILE -ErrorAction Stop
            Write-Host 'Profile updated!'
            Write-Host 'Changes will take effect on reload'
        }
        catch{
            Write-Host "Uh oh! We hit an error :("
        }
    }else{
        Write-Host "We'll try again next time"
    };
}else{
    Write-Host "Profile up-to-date!"
};
Write-Host '----------------------------------';
Write-Host 'Clearing host in 3 seconds . . .  ';
Write-Host '----------------------------------';
Start-Sleep 3;
Clear-Host;

#Prompt
function Prompt {

    #Force .NET and PS Dirs to match
    [Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem | Select-Object -ExpandProperty Path);
    $env:COMPUTERNAME + "\" + (Get-Location) + "> "
};

<# notes:
* install modules?
** getdirectory
** dbatools

* profile colours
** oh my posh
#>
#Import-Module posh-git;
Import-Module oh-my-posh;
Set-PoshPrompt -theme stelbent.minimal;
#Clear-Host;