# Windows Machine Setup
This script is a simple PowerShell to install some of the basic applications I need on my Windows machine. This is by no means an exhaustive list. If you feel there are more applications that should be included, please create an issue on the repo. 

The script is a work in progress and hasn't been completed or had error checking for applications that may be already installed. Feel free to correct that or wait for me to correct that myself.

## Installation

First step is to download the script
> Invoke-WebRequest -Uri https://raw.githubusercontent.com/JoshLuedeman/machine-setup/main/Windows/machine-setup.ps1 -OutFile machine-setup.ps1

You then need to set the execution policy in PowerShell so that an unsigned script can be run. I recommend only doing this temporarily as this is not a secure way to have your environment setup
> Set-executionpolicy unrestricted

Once you have done that, you can run the script!!
> ./machine-setup.ps1