#Version 0.3.5
#Updated 02021-08-04


#-----------------------------------------------------------------------#
#PROFILE SYNC FUNCTIONALITY
#-----------------------------------------------------------------------#

Clear-Host;
Write-Host 'Welcome back, Andy!';
Write-Host '----------------------------------';
Write-Host 'Checking for profile updates . . .';


#Set TLS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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
            Write-Warning "Uh oh! We hit an error :("
        }
    }else{
        Write-Host "We'll try again next time"
    };
}else{
    Write-Host "Profile up-to-date!" -ForegroundColor Green
};

#-----------------------------------------------------------------------#



#-----------------------------------------------------------------------#
#MODULE INSTALLATION SECTION
#-----------------------------------------------------------------------#
Write-Host '----------------------------------';
Write-Host 'Checking Installed Modules';
Write-Host '----------------------------------';


#-----------------------------------------------------------------------#
#SETUP
#-----------------------------------------------------------------------#

#Set Reposity Trust
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

#Detect Modules Dir (OneDrive compatible)
$ModulesDir = "$($profile -replace "$($profile -replace ".*\\")")Modules"

#-----------------------------------------------------------------------#


#-----------------------------------------------------------------------#
#MODULE INSTALLTION
#-----------------------------------------------------------------------#

#Detect and Install: GetDirectory
If(!(Test-Path $ModulesDir\GetDirectory)){Install-Module Get-Directory -Scope CurrentUser}

#Detect and Install: oh-my-posh
If(!(Test-Path $ModulesDir\oh-my-posh)){Install-Module oh-my-posh -Scope CurrentUser}

#Detect and Install: BurntToast
If(!(Test-Path $ModulesDir\BurntToast)){Install-Module BurntToast -Scope CurrentUser}

#Detect and Install: dbatools
If(!(Test-Path $ModulesDir\dbatools)){Install-Module dbatools -Scope CurrentUser}

#Detect and Install: AWS.Tools.Common
If(!(Test-Path $ModulesDir\AWS.Tools.Common)){Install-Module AWS.Tools.Common -Scope CurrentUser}

#-----------------------------------------------------------------------#



#-----------------------------------------------------------------------#
#PROMPT CUSTOMIZATION SECTION
#-----------------------------------------------------------------------#
Write-Host '----------------------------------';
Write-Host 'Customizing Prompt';
Write-Host '----------------------------------';


#-----------------------------------------------------------------------#
#MODIFY PROMPT FUNCTION
#-----------------------------------------------------------------------#

function Prompt {

    #Force .NET and PS Dirs to match
    [Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem | Select-Object -ExpandProperty Path);
    $env:COMPUTERNAME + "\" + (Get-Location) + "> "
};

#-----------------------------------------------------------------------#


#-----------------------------------------------------------------------#
#INSTALL OH-MY-POSH THEME
#-----------------------------------------------------------------------#
#Import-Module posh-git;
Import-Module oh-my-posh;

#Set oh-my-posh Prompt Theme
#Detect oh-my-posh themes dir
$OhMyPosh_Themes_Dir = Get-Childitem "$modulesdir\oh-my-posh\" -Recurse -Directory | Where-Object name -eq 'themes' | Select-Object -ExpandProperty FullName

#Custom Theme URL
$PoshThemeURL = 'https://raw.githubusercontent.com/dark-coffee/dollar-profile/main/oh-my-posh/darkcoffee.minimal.omp.json';

#Logic to check for, install, and set custom theme
If(Test-Path $OhMyPosh_Themes_Dir){
    Write-Host "oh-my-posh themes directory found"
    If(!(Test-Path $OhMyPosh_Themes_Dir\darkcoffee.minimal.omp.json)){
        Write-Warning "Custom theme not found"
        Write-Host "Installing . . ."
        try{
            Start-BitsTransfer -Source $PoshThemeURL -Destination $OhMyPosh_Themes_Dir\darkcoffee.minimal.omp.json -ErrorAction Stop
            Write-Host 'Installed'
            Write-Host 'Setting prompt theme'
            Set-PoshPrompt -theme darkcoffee.minimal
            Write-Host 'Prompt theme set'-ForegroundColor Green
        }
        catch{
            Write-Warning "Uh oh! We hit an error :("
        }
    }else{
        Write-Host "Custom theme found"
        Write-Host 'Setting prompt theme'
        Set-PoshPrompt -theme darkcoffee.minimal
        Write-Host 'Prompt theme set' -ForegroundColor Green
    }
}else{
    Write-Warning "oh-my-posh themes directory not found. This action requires oh-my-posh."
}
#-----------------------------------------------------------------------#



#-----------------------------------------------------------------------#
#END OF SCRIPT
#-----------------------------------------------------------------------#
Write-Host '----------------------------------';
Write-Host 'Clearing host in 3 seconds . . .  ';
Write-Host '----------------------------------';
Start-Sleep 3;
Clear-Host;
#-----------------------------------------------------------------------#