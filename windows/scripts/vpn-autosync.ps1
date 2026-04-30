$GroupName = "vpn"
$StateFile = "C:\VPN\vpn_users.txt"
$UbuntuHost = "vrmnk@192.168.10.4"

Import-Module ActiveDirectory

# Поточні користувачі групи
try {
    $members = Get-ADGroupMember -Identity $GroupName -ErrorAction Stop
} catch {
    $members = @()
}

$current = $members |
           Where-Object {$_.objectClass -eq "user"} |
           Select-Object -ExpandProperty SamAccountName

# Якщо група пуста — зробити порожній масив
if (-not $current) {
    $current = @()
}

# Попередній стан
if (Test-Path $StateFile) {
    $old = Get-Content $StateFile
} else {
    $old = @()
}

# ➕ Нові користувачі
$newUsers = $current | Where-Object {$_ -notin $old}

foreach ($u in $newUsers) {
    Write-Host "CREATE VPN for $u"
    ssh $UbuntuHost "sudo /home/vrmnk/create-user-vpn.sh $u"
}

# ➖ Видалені користувачі
$removedUsers = $old | Where-Object {$_ -notin $current}

foreach ($u in $removedUsers) {
    Write-Host "REVOKE VPN for $u"
    ssh $UbuntuHost "sudo /home/vrmnk/revoke-user-vpn.sh $u"
}

# Оновити файл стану
$current | Out-File $StateFile -Encoding ASCII
