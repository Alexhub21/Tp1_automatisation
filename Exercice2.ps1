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
$board = Get-CimInstance Win32_BaseBoard
$bios = Get-CimInstance Win32_BIOS
$os = Get-CimInstance Win32_OperatingSystem
$rapport = [PSCustomObject]@{
    Mode               = $Mode
    CPU_Nom            = $cpu.Name
    CPU_Fabricant      = $cpu.Manufacturer
    CPU_Coeurs         = $cpu.NumberOfCores

    CM_Fabricant       = $board.Manufacturer
    CM_Modele          = $board.Product

    BIOS_Fabricant     = $bios.Manufacturer
    BIOS_Version       = $bios.SMBIOSBIOSVersion

    OS_Nom             = $os.Caption
    OS_Version         = $os.Version
}
#ecrire un fichier csv
if ($CSV) {
    $cheminCsv = Join-Path -Path (Get-Location) -ChildPath "info.csv"
    $cpuInfo | Export-Csv -Path $cheminCsv -NoTypeInformation -Append
    $rapport | Export-Csv -Path $cheminCsv -NoTypeInformation -Append

    Write-Host "CSV ecris : $cheminCsv"

}