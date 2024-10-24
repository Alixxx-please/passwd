$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$passwdFolderPath = "$env:LOCALAPPDATA\passwd"
$process = Get-Process -Name "passwd" -ErrorAction SilentlyContinue

if ($process) {
    Stop-Process -Name "passwd" -Force
    Write-Output "passwd.exe was running and has been terminated."
} else {
    Write-Output "passwd.exe is not running."
}

if (-not (Test-Path -Path $passwdFolderPath)) {
    New-Item -ItemType Directory -Path $passwdFolderPath
}

$currentPATH = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
if (-not $currentPATH.Contains($passwdFolderPath)) {
    $newPATH = "$currentPATH;$passwdFolderPath"
    [System.Environment]::SetEnvironmentVariable("PATH", $newPATH, [System.EnvironmentVariableTarget]::User)
    Write-Output "Folder added to PATH."
} else {
    Write-Output "Folder already in PATH."
}