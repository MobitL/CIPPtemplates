# Filbaner
$inputFile = ".\Require_multifactor_authentication_for_all_users.json"
$outputFile = ".\policy_formatted.json"

# Les og parse den originale filen
$raw = Get-Content $inputFile -Raw | ConvertFrom-Json

# Parse JSON-feltet som er en string med escape-tegn
$policy = $raw.JSON | ConvertFrom-Json

# Legg til Graph API-felter
$policy | Add-Member -NotePropertyName "@odata.context" -NotePropertyValue "https://graph.microsoft.com/beta/$metadata#identity/conditionalAccess/policies/$entity"
$policy | Add-Member -NotePropertyName "@odata.type" -NotePropertyValue "#microsoft.graph.conditionalAccessPolicy"

# Skriv ut til ny fil – pent formattert
$policy | ConvertTo-Json -Depth 10 | Out-File $outputFile -Encoding utf8

Write-Host "✅ Formatert policy skrevet til $outputFile"
