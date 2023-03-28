Invoke-WebRequest -Uri https://raw.githubusercontent.com/JoshLuedeman/machine-setup/master/Windows/Packages.txt -OutFile Packages.txt -UseBasicParsing
$Packages = Get-Content -Path "Packages.txt"

function Install-Git
{
    $gitSite = Invoke-WebRequest -Uri https://git-scm.com/download/win -UseBasicParsing
    $linkArray = @($gitSite.Links)

    foreach($link in $linkArray)
    {
        if($link.outerHTML -clike "*64-bit Git for Windows Setup</a>")
        {
            $gitDlLink = $link.href
        }
        else
        {}
    }    

    $gitDlFileName = $gitDlLink.Substring($gitDlLink.LastIndexOf("/")+1,$gitDlLink.Length-$gitDlLink.LastIndexOf("/")-1)

    $gitDlPath = ($env:USERPROFILE)+"\Downloads\"+ $gitDlFileName

    Invoke-WebRequest -Uri $gitDlLink -OutFile $gitDlPath -UseBasicParsing

    Start-Process $gitDlPath.ToString()
    Write-Host "Press a key when the Git installer is complete...."
    Read-Host
}

function Clone-Repo
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

function Install-Chocolatey
{
    Find-Package -Name Autoruns | Install-Package -Verbose
    Find-Package -Name Install-Chocolatey | Install-Package -Verbose
}

function Install-ChocoPackages ($Packages)
{
    foreach ($PackageName in $Packages) {
        choco install $PackageName -y
        if($PackageName == "wsl2") {
            wsl --set-default-version 2
        }
        if($PackageName == "kubernetes-cli") {
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
Install-Git