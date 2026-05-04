param(
    [Parameter(Mandatory = $true)]
    [string]$DomainFqdn,

    [Parameter(Mandatory = $true)]
    [string]$DomainNetBios,

    [string]$StudentUser = 'student',
    [Parameter(Mandatory = $true)]
    [string]$StudentPassword,

    [string]$ServiceUser = 'svc_sql',
    [Parameter(Mandatory = $true)]
    [string]$ServicePassword,

    [string]$ServiceSpn
)

Import-Module ActiveDirectory -ErrorAction Stop

if (-not $ServiceSpn) {
    $ServiceSpn = "MSSQLSvc/sql.$DomainFqdn:1433"
}

$studentUpn = "$StudentUser@$DomainFqdn"
$serviceUpn = "$ServiceUser@$DomainFqdn"
$studentPasswordSecure = ConvertTo-SecureString $StudentPassword -AsPlainText -Force
$servicePasswordSecure = ConvertTo-SecureString $ServicePassword -AsPlainText -Force

if (-not (Get-ADUser -Filter "SamAccountName -eq '$StudentUser'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name $StudentUser -SamAccountName $StudentUser -UserPrincipalName $studentUpn -AccountPassword $studentPasswordSecure -Enabled $true
}

if (-not (Get-ADUser -Filter "SamAccountName -eq '$ServiceUser'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name $ServiceUser -SamAccountName $ServiceUser -UserPrincipalName $serviceUpn -AccountPassword $servicePasswordSecure -Enabled $true -PasswordNeverExpires $true
}

$existingSpns = setspn -L $ServiceUser
if ($existingSpns -notmatch [regex]::Escape($ServiceSpn)) {
    setspn -S $ServiceSpn "$DomainNetBios\\$ServiceUser"
}

Write-Host '=== AD objects ready ==='
Get-ADUser -Identity $StudentUser | Select-Object SamAccountName, UserPrincipalName, Enabled
Get-ADUser -Identity $ServiceUser | Select-Object SamAccountName, UserPrincipalName, Enabled, PasswordNeverExpires
Write-Host '=== SPN list ==='
setspn -L $ServiceUser
