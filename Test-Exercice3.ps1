. "$PSScriptRoot\Exercice3.ps1"

$Adresse = Read-Host "Entrez l'adresse réseau "
$Masque = [int](Read-Host "Entrez le masque ")
$Hotes = Read-Host "Entrez les hôtes  "

$Hotes = $Hotes.Split(',') | ForEach-Object { [int]$_ }

$v = [VLSMCalculateur]::new($Adresse, $Masque, $Hotes)
$sousReseaux = $v.Calculer()

$i = 0
while ($i -lt $sousReseaux.Count) {

    $sr = $sousReseaux[$i]

    Write-Host ("Réseau : {0}   Taille : {1}   adresse : {2}   masque : {3}" -f `
        $sr.Id, $sr.TailleDemandee, $sr.Adresse, $sr.Masque)

    $i++
}