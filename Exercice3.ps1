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

    #Methode obenir adrsse
    


}
class VLSMCalculator{
    [string]$AdresseDepart
    [int]$MasqueDepart=24
    [int[]] $Hotes

    VLSCalculator([string]$AdresseDepart, [int]$MasqueDepart, [int]$Hotes){
        $this.AdresseDepart=$AdresseDepart
        $this.MasqueDepart=$MasqueDepart
        $this.Hotes=$Hotes
    }
    [void]ValiderEntrees(){
        Write-Host "Validation des entrées..."
        #
        $ipv4Regex = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
        $estIPV4 = $this.AdresseDepart -match $ipv4Regex
        #Si ce n'est pas une adresse IPv4, vérifier si c'est une adresse IPv6
        $estIPV6 =$false
        if (-not $estIPV4) {
            try{
                [void][System.Net.IPAddress]::Parse($this.AdresseDepart)
                $estIPV6 = $true
            }
            catch{
                 $estIPV6 = $false
            }
            
        }
        #Valider l'adresse IP
        if ((-not $estIPV4 -and -not $estIPV6)) {
            throw "Adresse IP invalide. Veuillez entrer une adresse IPv4 ou IPv6 valide: $($this.AdresseDepart)"
           
        }
        #Valider le masque de sous-réseau
        if ($this.MasqueDepart -lt 0 -or $this.MasqueDepart -gt 30) {
            throw "Masque de sous-réseau invalide. Veuillez entrer un masque entre 0 et 30: $($this.MasqueDepart)"
          
        }
        # Hotes non vide positif
        if(null -eq $this.Hotes -or $this.Hotes.Length -eq 0){
            throw "Veuillez fournir une liste d'hôtes valide."
        }
        $i=0
        foreach($hote in $this.Hotes){
            if($hote -le 0){
                throw "Le nombre d'hôtes doit être un entier positif. Hôte invalide à l'index $i : $hote"
            }
            $i++
        }
    }

    #Methode pour calculer le masque de sous reseau
   [int] GetMasque([int]$Hotes){
        $bitsHotes = [math]::Ceiling([math]::Log($Hotes + 2, 2))
        $masqueSousReseau = 32 - $bitsHotes
        return $masqueSousReseau
    }
}