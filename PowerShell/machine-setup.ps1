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

function Clone-ScriptRepo
{
    $srcCntrlDir = New-Item -ItemType Directory -Path (($env:USERPROFILE) + "\source\github\")
    Set-Location $srcCntrlDir
    .\git clone https://github.com/JoshLuedeman/machine-setup.git   
}

function Install-VsCode
{}

function Install-AzureDataStudio
{}

function Install-Python3
{}

function Install-PowerShellCore
{}

function Install-WindowsTerminal
{}

function Enable-Wsl
{}

function Install-Wsl2
{}

Clear-Host

Write-Host("Welcome to my machine provisioner script. This PowerShell script will install the software that I need to make a machine functional for my day-to-day job")
Write-Host("")
Write-Host("The first task is to install Git so that we can download the repository of other scripts")
Install-Git