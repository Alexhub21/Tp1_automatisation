class SousReseau{
    [int]$Id
    [int]$TailleDemandee
    [string]$Adresse
    [int]$Masque
    
    SousReseau([int]$Id, [int]$TailleDemandee, [string]$Adresse, [int]$Masque){
        $this.Id=$Id
        $this.tailleDemandee=$TailleDemandee
        $this.Adresse=$Adresse
        $this.Masque=$Masque
    }

   #Methode obtenir adresse
[int] GetAdresse([int]$PositionHote){
    [int]$capacite =[int] [math]::Pow(2,(32-$this.Masque))
 #Vérifier que PositionHote est valide
 #$PositionHote = Get-PositionHote -PositionHote
 if($PositionHote -le 0){
    throw "la position doit etre superieur a 0"
}
if($PositionHote -ge ($capacite - 1)){
    throw "la position depasse la plage valide"
}

#Convertir IP réseau en entier
 $tabOctet = $this.Adresse.Split('.')
 [uint32]$base = 0
 $i = 0
 while ($i -lt 4) {
    $base = ($base * 256) + [uint32]$tabOctet[$i]
    $i ++
 }
 #Ajouter PositionHote

 [uint32]$nouveauIP = $base + $PositionHote

#Retourner nouvelle IP
return $nouveauIP
}

}

class VLSMCalculateur{
    [string]$AdresseDepart
    [int]$MasqueDepart
    [int[]] $Hotes

    VLSMCalculateur([string]$AdresseDepart, [int]$MasqueDepart, [int[]]$Hotes){

        Write-Debug "Constructeur VLSMCalculateur() - début"

        $this.AdresseDepart=$AdresseDepart
        $this.MasqueDepart= $MasqueDepart
        $this.Hotes= $Hotes
    
 #validation IPV4 avec le regex
    if($this.AdresseDepart -notmatch '^((25[0-5]|2[0-4]\d|1?\d?\d)(\.(25[0-5]|2[0-4]\d|1?\d?\d)){3})$'){
        throw"•	L'adresse IP de base n'est pas au format IPv4 valide."

    }
#validation du masque
    if (($this.MasqueDepart -lt 0 -or $this.MasqueDepart -gt 30)) {
        throw"Masque invalide : $($this.MasqueDepart)"
    }
#validation des hotes
    if(-not $this.Hotes -or $this.Hotes.Count -eq 0) {
        throw"La liste d'hôtes est vide"
    }
    $i = 0
    while ($i -lt $this.Hotes.Count) {
        if ($this.Hotes[$i] -le 0) {
            throw "Nombre d'Hôte invalide : $($this.Hotes[$i])"
        }
          $i++
    }
          
    [int]$capacite = [int][Math]::Pow(2,(32 - $this.MasqueDepart))
    [int]$SommeAdressesTotal = 0

    $i = 0
    while ($i -lt $this.Hotes.Count) {

        [int]$NbHote =$this.Hotes[$i]
         [int]$MasqueFin = $this.GetMasque($this.Hotes[$i])
        [int]$AdressesTotales = [int][Math]::Pow(2,(32 - $MasqueFin))

        $SommeAdressesTotal = $SommeAdressesTotal + $AdressesTotales

         Write-Debug "Validation: Hôtes :$NbHote , MasqueFin : $MasqueFin , TotalAdresses : $AdressesTotales , Somme : $SommeAdressesTotal" 
            $i++
    }
        if ($SommeAdressesTotal -gt $capacite){
            throw"la somme des sous-réseau ($SommeAdressesTotal) dépasse la capacité ($capacite)"
        }
         Write-Debug "Constructeur VLSMCalculateur() - validation OK"
    }


    #Methode pour calculer le masque de sous reseau
   [int] GetMasque([int]$Hotes){

    write-Debug "Calcul du masque pour $Hotes hôtes"

    if($Hotes -le 0){
        throw "Le nombre d'hôtes doit être supérieur à 0"
    }
       $bitsHotes = [math]::Ceiling([math]::Log($Hotes + 2, 2))
        $masqueSousReseau = 32 - $bitsHotes

       
     Write-Debug "Nombre de bits pour les hôtes: $bitsHotes, Masque de sous-réseau: $masqueSousReseau"
      
        if ($masqueSousReseau -lt 0 -or $masqueSousReseau -gt 30) {
            throw "Masque de sous-réseau invalide : $masqueSousReseau"
        }
        if ($masqueSousReseau -lt $this.MasqueDepart) {
            throw "Masque de sous-réseau  dépasse le réseau : $masqueSousReseau"
        }
        return $masqueSousReseau

    }

   [SousReseau[]] Calculer(){

     Write-Debug "Calculer() - début"

    $sousReseaux = @()
    #trie des hotes par ordre decroissant
    $HotesTries = $this.Hotes | Sort-Object -Descending

    $tabOctet = $this.AdresseDepart.Split('.')
    [uint32]$base = 0
    $i = 0
    while ($i -lt 4) {
        $base = ($base * 256) + [uint32]$tabOctet[$i]
        $i ++
    }
    #le calcul séquencielles
    for ($i = 0;$i -lt $HotesTries.Count; $i++){
        $NbHote =$HotesTries[$i]
         [int]$MasqueFin = $this.GetMasque($HotesTries[$i])

        # -shr et -band trouver a partir de recherche sur internet pour convertir entier en adresse ip

        $o1 = [int](($base -shr 24) -band 255)
        $o2 = [int](($base -shr 16) -band 255)
        $o3 = [int](($base -shr 8) -band 255)
        $o4 = [int]($base -band 255)

        $AdresseCourante = "$o1.$o2.$o3.$o4"

         # Créer l'objet SousReseau et l'ajouter à la liste
        $sousReseau = [SousReseau]::new(($i + 1), $NbHote, $AdresseCourante, $MasqueFin)
        $sousReseaux += $sousReseau

        # Calculer la capacité du sous-réseau (taille du bloc)
        [uint32]$CapaciteSousReseau = [uint32][Math]::Pow(2, (32 - $MasqueFin))

        # Avancer à la prochaine adresse réseau (séquentiel)
        $base = $base + $CapaciteSousReseau  

    }
    
        Write-Debug "Calculer() - fin"
    
    return $sousReseaux
    }
 
}
# petit test
$DebugPreference="Continue"
Write-Host "`n===== TEST 5 : Capacité dépassée ====="
try {
    $calc = [VLSMCalculateur]::new("192.168.1.0",24,@(200,100))
    $res = $calc.Calculer()
}
catch {
    Write-Host "ERREUR : $($_.Exception.Message)"
}