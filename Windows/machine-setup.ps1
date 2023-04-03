If (Test-Path "Packages.txt")
{
    Write-Host "Packages.txt already exists. Using Existing File."
}
else {
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/JoshLuedeman/machine-setup/master/Windows/Packages.txt -OutFile Packages.txt -UseBasicParsing
}

$Packages = Get-Content -Path "Packages.txt"

function Install-Git
{
    # Removed installer download and using choco instead
    choco install git -y
}

function Get-Repo ()
{
    install-module 'posh-git' -Scope CurrentUser
    New-Alias -Name git -Value "$Env:ProgramFiles\Git\bin\git.exe"
    $srcCntrlPath = (($env:USERPROFILE) + "\source\github\")
    if(Test-Path -LiteralPath $srcCntrlPath)
    {Write-Host "Script directory already exists"}
    else
    {$srcCntrlDir = New-Item -ItemType Directory -Path $srcCntrlPath}
    Set-Location $srcCntrlDir
    git clone https://github.com/JoshLuedeman/machine-setup.git   
}

function Get-Chocolatey 
{
    Invoke-WebRequest -Uri https://chocolatey.org/install.ps1 -OutFile install.ps1 -UseBasicParsing
    ./install.ps1
}

function Install-ChocoPackages ($Packages)
{
    foreach ($PackageName in $Packages) {
        choco install $PackageName -y
        if($PackageName -eq "wsl2") {
            wsl --set-default-version 2
        }
        if($PackageName -eq "kubernetes-cli") {
            Set-Location -Path $env:USERPROFILE
            New-Item -ItemType Directory ".kube"
            Set-Location -Path "$env:USERPROFILE\.kube"
            kubectl 
        }
    }
}

Clear-Host

Write-Host("Welcome to my machine provisioner script. This PowerShell script will install the software that I need to make a machine functional for my day-to-day job")
Write-Host("")
Write-Host("The first task is to install Git so that we can download the repository of other scripts")


Get-Chocolatey
Install-Git
Install-ChocoPackages($Packages)