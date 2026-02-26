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


#recuperation des infos CIM
$cpu= Get-CimInstance Win32_Processor
$board = Get-CimInstance Win32_BaseBoard
$bios = Get-CimInstance Win32_BIOS
$os = Get-CimInstance Win32_OperatingSystem
#ignorer les cartes citrix
$gpu =Get-CimInstance Win32_VideoController | Where-object {$_.Name -notmatch "Citrix"} | Select-Object -First 1
#disque : max 3
$disks = Get-CimInstance Win32_DiskDrive | Select-Object -First 3

Write-Host "---------------------------------"
Write-Host "CPU : $($cpu.Name)"
Write-Host "Fabricant : $($cpu.Manufacturer)"
Write-Host "Nombre de coeurs : $($cpu.NumberOfCores)"

#creation d'un objet Csv
$cpuInfo= [PSCustomObject]@{
    Mode = $Mode
    
}
#message de sorties
$sortie= ""
if ($Mode -eq "Tout" -or $Mode -eq "Materiel") {
    $sortie += "===========================CARTE MÈRE===========================`n"
    $sortie += "Carte mère : $($board.Product)`n"
    $sortie += "Manufacturier de la carte mère : $($board.Manufacturer)`n"
    $sortie += "Version du bios : $($board.SerialNumber)`n`n "

    $sortie += "===========================PROCESSEUR===========================`n"
    $sortie += "Nom du processeur : $($cpu.Name)`n"
    $sortie += "Manufacturier du processeur : $($cpu.Manufacturer)`n"
    $sortie += "Nombre de coeurs du processeur : $($cpu.NumberOfCores)`n"

    $sortie += "===========================CARTE GRAPHIQUE===========================`n"
    $sortie += "Nom de la carte graphique : $($gpu.Name)`n"
    $sortie += "Version du driver : $($gpu.DriverVersion)`n"
    
}
if ($Mode -eq "Tout" -or $Mode -eq "Stockage") {
    $sortie += "===========================DISQUES===========================`n"
    foreach ($disk in $disks) {
        $sortie += "Nom du disque : $($disk.Model)`n"
        $sortie += "Taille du disque : $([math]::Round($disk.Size / 1GB, 2)) GB`n"
        $sortie += "Type de media : $($disk.MediaType)`n`n"
    }
}
if ($Mode -eq "Tout") {
    $sortie += "===========================OS===========================`n"
    $sortie += "Système d'exploitation : $($os.Caption)`n"
    $sortie += "Version du système d'exploitation : $($os.Version)`n"
    $sortie += "Édition du système d'exploitation : $($os.OperatingSystemSKU)`n"
    
}
if (-not $Discret) {
    Write-Host $sortie
    
}
#fichier texte
if ($Fichier) {
    $cheminFichier = Join-Path -Path (Get-Location) -ChildPath "info.txt"
    $sortie | Out-File -FilePath $cheminFichier -Encoding UTF8
    Write-Host "Les informations ont été enregistrées dans $cheminFichier"
}
#ecrire un fichier csv
if ($CSV) {
    $cheminCsv = Join-Path -Path (Get-Location) -ChildPath "info.csv"
    $ligne = [PSCustomObject]@{
        Date = (Get-date)
        Mode =$Mode
        CarteMere = $board.Product
        CPU= $cpu.Name
        GPU = $gpu.Name
        Disk1 =($disks | Select-Object -First 1).Model
        OS= $os.Caption

    }

    $ligne | Export-Csv -Path $cheminCsv -NoTypeInformation -Append
    Write-Host "Les informations ont été exportées vers $cheminCsv"

    
}
if ($CheminEnLigne) {
    $sortie | Out-File -FilePath $CheminEnLigne -Encoding UTF8
    Write-Host "Écrit sur le serveur $CheminEnLigne"
   
}