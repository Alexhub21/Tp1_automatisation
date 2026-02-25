# A quoi sert la commande "Get-CimInstance" ?
#  Récupère des informations système (OS, BIOS, CPU, disques, services, etc.)
#   à partir des classes CIM (Common Information Model). C’est l’approche moderne.
Get-Command Get-CimInstance | Format-List *
Get-Help Get-CimInstance -Full

#•	À quoi sert la commandes Get-ComputerInfo ?
#  Donne un résumé d’informations matérielles et logicielles sur l’ordinateur.
Get-Command Get-ComputerInfo | Format-List *
Get-Help Get-ComputerInfo -Full