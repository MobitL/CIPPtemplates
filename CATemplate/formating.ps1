# Finn mappen skriptet kjører fra
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Finn alle JSON-filer i denne mappen
$jsonFiles = Get-ChildItem -Path $scriptPath -Filter '*.json'

foreach ($file in $jsonFiles) {
    # Definer input og output filbaner
    $inputFile = $file.FullName
    $outputFile = $file.FullName

    # Les og parse JSON fra original fil
    $raw = Get-Content $inputFile -Raw | ConvertFrom-Json

    # Sjekk at feltet "JSON" eksisterer for å unngå feil
    if ($null -eq $raw.JSON) {
        Write-Warning "❌ Hopper over '$($file.Name)' - fant ikke JSON-feltet."
        continue
    }

    # Parse JSON-feltet som er en string med escape-tegn
    $policy = $raw.JSON | ConvertFrom-Json

    # Legg til Graph API-felter
    $policy | Add-Member -NotePropertyName "@odata.context" -NotePropertyValue "https://graph.microsoft.com/beta/$metadata#identity/conditionalAccess/policies/$entity"
    $policy | Add-Member -NotePropertyName "@odata.type" -NotePropertyValue "#microsoft.graph.conditionalAccessPolicy"

    # Skriv ut til samme fil – pent formattert
    $policy | ConvertTo-Json -Depth 10 | Out-File $outputFile -Encoding utf8

    Write-Host "✅ Formatert policy skrevet til $outputFile"
}
