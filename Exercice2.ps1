#script qui presente configuration 
param(
    [switch]$Discret,
    [switch]$Fichier,
    [switch]$CSV,
    [Parameter(Mandatory=$true)]
    [ValidateSet("Tout","Materiel","Stockage")]
    [string]$Mode,
    [string]$CheminEnLigne
)
Write-Host "Mode choisi : $Mode"
Write-Host "Discret : $Discret" 
Write-Host "Fichier : $Fichier"
Write-Host "Chemin : $CheminEnLigne"
$cpu= Get-CimInstance Win32_Processor

