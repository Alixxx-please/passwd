$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$passwdFolderPath = "$env:LOCALAPPDATA\passwd"
$currentPATH = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)

Write-Output "Starting"

if (Test-Path -Path $passwdFolderPath) {
    Remove-Item -Path $passwdFolderPath -Recurse -Force | Out-Null
}

if ($currentPATH.Contains($passwdFolderPath)) {
    $newPATH = $currentPATH -replace [regex]::Escape(";$passwdFolderPath"), ""
    [System.Environment]::SetEnvironmentVariable("PATH", $newPATH, [System.EnvironmentVariableTarget]::User)
    Write-Output "Folder removed from PATH."
} else {
    Write-Output "Folder not found in PATH."
}