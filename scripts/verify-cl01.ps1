param(
    [string]$ExpectedDomain = 'demo.local',
    [string]$ExpectedDcHostname = 'DC01'
)

$computerSystem = Get-CimInstance Win32_ComputerSystem
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$dnsConfig = Get-DnsClientServerAddress -AddressFamily IPv4
$tickets = klist
$hasTgt = $tickets -match 'krbtgt/'
$isDomainMatch = $computerSystem.Domain -ieq $ExpectedDomain

Write-Host '=== User ==='
Write-Host $currentUser

Write-Host '=== Host / Domain ==='
Write-Host "Hostname: $env:COMPUTERNAME"
Write-Host "Domain: $($computerSystem.Domain)"
Write-Host "Domain joined: $($computerSystem.PartOfDomain)"
Write-Host "Domain expected: $ExpectedDomain"
Write-Host "Domain check: $(if ($isDomainMatch) { 'PASS' } else { 'FAIL' })"

Write-Host '=== DNS ==='
$dnsConfig | Select-Object InterfaceAlias, ServerAddresses

Write-Host '=== Time status ==='
w32tm /query /status

Write-Host '=== Kerberos tickets ==='
$tickets
Write-Host "TGT present: $(if ($hasTgt) { 'PASS' } else { 'FAIL' })"

Write-Host '=== Quick guidance ==='
Write-Host "- Nếu Domain check = FAIL: kiểm tra lại join domain và DNS về $ExpectedDcHostname"
Write-Host '- Nếu TGT present = FAIL: đăng xuất/đăng nhập lại rồi chạy klist'
