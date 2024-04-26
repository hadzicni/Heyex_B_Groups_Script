# Aktualisieren Sie die Gruppennamen nach Bedarf
$targetGroup = "ICT_B_Augenklinik_Aerzte"
$requiredGroups = @("ICT_B_Augenklinik_Alle", "ICT_B_FORUM_Users", "ICT_B_HeyexUsers")

# Holen Sie alle Benutzer aus der Zielgruppe
$members = Get-ADGroupMember -Identity $targetGroup

# Durchlaufen Sie jeden Benutzer und überprüfen Sie die erforderlichen Gruppenmitgliedschaften
foreach ($member in $members) {
    $username = $member.SamAccountName

    # Holen Sie alle Gruppenmitgliedschaften des Benutzers
    $userGroups = (Get-ADUser $username -Properties MemberOf).MemberOf | Get-ADGroup | Select-Object -ExpandProperty SamAccountName

    # Überprüfen Sie, ob alle erforderlichen Gruppenmitgliedschaften vorhanden sind
    $missingGroups = $requiredGroups | Where-Object { $_ -notin $userGroups }

    if ($missingGroups.Count -eq 0) {
        Write-Host "Benutzer $username ist Mitglied aller erforderlichen Gruppen."
    } else {
        Write-Host "Benutzer $username fehlt in den Gruppen: $($missingGroups -join ', ')"
    }
}
