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