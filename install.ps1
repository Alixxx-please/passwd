$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$passwdFolderPath = "$env:LOCALAPPDATA\passwd"

if (-not (Test-Path -Path $passwdFolderPath)) {
    New-Item -ItemType Directory -Path $passwdFolderPath
}