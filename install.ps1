$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$passwdFolderPath = "$env:LOCALAPPDATA\passwd"
$exePath = "$passwdFolderPath\passwd.exe"
$process = Get-Process -Name "passwd" -ErrorAction SilentlyContinue
$latestRelease = Invoke-RestMethod -Uri 'https://api.github.com/repos/Alixxx-please/passwd/releases/latest'
$exeUrl = $latestRelease.assets[0].browser_download_url

if ($process) {
    Stop-Process -Name "passwd" -Force
    Write-Output "passwd.exe was running and has been terminated."
} else {
    Write-Output "passwd.exe is not running."
}

if (-not (Test-Path -Path $passwdFolderPath)) {
    New-Item -ItemType Directory -Path $passwdFolderPath | Out-Null
}

if (Test-Path -Path $exePath) {
    Remove-Item -Path $exePath -Force
    Write-Output "Existing passwd.exe has been removed."
}

Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

$currentPATH = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
if (-not $currentPATH.Contains($passwdFolderPath)) {
    $newPATH = "$currentPATH;$passwdFolderPath"
    [System.Environment]::SetEnvironmentVariable("PATH", $newPATH, [System.EnvironmentVariableTarget]::User)
    Write-Output "Folder added to PATH."
} else {
    Write-Output "Folder already in PATH."
}