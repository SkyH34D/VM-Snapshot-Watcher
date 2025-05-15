#
# Este script se encarga de controlar la existencia de instantaneas en las máquinas virtuales del entorno de producción. Comprueba la 'edad' de las mismas, y 
# si es superior a tres días, envía el nombre de la instantánea y el nombre de la máquina a la que pertenece a un zabbix trapper localizado en _PROD_VeamBackup
# bajo el ítem "Snapshots de VMWare". 
#
# Autor: Cristian "SkyH34D" Franco
#


##Declaración de funciones

#Envía los datos a zabbix
Function zabbix_sender($a){
    C:\Zabbix\scripts\zabbix_sender.exe -z 192.168.120.152 -p 10051 -s "2X-RAS" -k ss.name -o $a   
}


#Cargamos el módulo de vmWare y nos conectamos a vCenter
Add-PSSnapin vmware.vimautomation.core
Connect-VIServer 192.168.0.41 -user ro_zabbix@vsphere.local -Password EstaP***Contr4seña

#Listamos las fechas de todas las instantaneas del entorno, calculamos la cantidad de entradas y almacenamos como contador para recorrer el array
$query=Get-VM | Get-Snapshot |Select-Object Created
$count = $query | Measure-Object
$count=$count.count
$i=$count
$i-- #El count va de 1 a X y el array de 0 a X-1

#Almacenamos la fecha tres días atras de la actual
$maxDate=(get-date).AddDays(-3)

#Recorremos el listado de instaneas conviertiendo las fechas a un formato comparable con $maxDate
Do{
    $date=$query[$i].Created
    #$Newdate=Get-Date $date -Format 'MM/dd/yyyy'
    #Se recoge la información de aquellas mayores a tres días y luego se envía a zabbix
    if ($date -lt $maxDate){
        $q_vmName=Get-VM | Get-Snapshot | Where-Object {$_.Created -like $date} | Select-Object VM
        $vmName=[string]$q_vmName.VM

        $q_ssName=Get-VM | Get-Snapshot | Where-Object {$_.Created -like $date} | Select-Object Name
        $ssName=[string]$q_ssName.Name

        $ID="VM:"+$vmName+", SS:"+$ssName
        zabbix_sender $ID
    }
    $i--
}while($i -ge 0)

#Cuatro (4) de agosto de 2020
