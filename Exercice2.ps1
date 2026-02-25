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

Write-Host "---------------------------------"
Write-Host "CPU : $($cpu.Name)"
Write-Host "Fabricant : $($cpu.Manufacturer)"
Write-Host "Nombre de coeurs : $($cpu.NumberOfCores)"

#creation d'un objet Csv
$cpuInfo= [PSCustomObject]@{
    Mode = $Mode
    NomCPU = $cpu.Name
    FabricantCPU = $cpu.Manufacturer
    NombreDeCoeurs = $cpu.NumberOfCores
}
$rapport = 
#ecrire un fichier csv
if ($CSV) {
    $cheminCsv = Join-Path -Path (Get-Location) -ChildPath "info.csv"
    $cpuInfo | Export-Csv -Path $cheminCsv -NoTypeInformation -Append

    Write-Host "CSV ecris : $cheminCsv"

}