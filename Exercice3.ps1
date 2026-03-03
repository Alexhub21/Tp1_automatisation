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

    #Methode obenir adresse
     #Methode obtenir adresse
   [int] GetAdresse([int]$PositionHote) {
        if ($PositionHote -lt 0) { throw "PositionHote doit être >= 0" }
 
        $base = IpToUInt32 $this.Adresse
        $val = [uint32]($base + $PositionHote)
 
        # cast en int (minimal, pour respecter la signature)
        return [int]$val
    }

}

#Convertir IP réseau en entier

#Ajouter PositionHote

#Retourner nouvelle IP


}
class VLSCalculator{
    [string]$AdresseDepart
    [int]$MasqueDepart
    [int[]] $Hotes

    VLSCalculator([string]$AdresseDepart, [int]$MasqueDepart, [int]$Hotes){
        $this.AdresseDepart=$AdresseDepart
        $this.MasqueDepart=$MasqueDepart
        $this.Hotes=$Hotes
    }

    #Methode pour calculer le masque de sous reseau
   [int] GetMasque([int]$Hotes){
        $bitsHotes = [math]::Ceiling([math]::Log($Hotes + 2, 2))
        $masqueSousReseau = 32 - $bitsHotes
        return $masqueSousReseau
    }
}