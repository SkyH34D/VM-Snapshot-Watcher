# VM-Snapshot-Watcher

**VM-Snapshot-Watcher** es una herramienta en PowerShell diseñada para entornos VMware vSphere. Automatiza el control de snapshots (instantáneas) de máquinas virtuales en producción y notifica aquellas que superan los 3 días de antigüedad, integrándose con Zabbix para la monitorización centralizada.

## 📌 Características

- Detecta snapshots antiguas en VMware vSphere.
- Reporta los hallazgos a un ítem personalizado en Zabbix.
- Automatizable mediante tareas programadas o scripts de mantenimiento.

## ⚙️ Requisitos

- PowerShell (recomendado: versión 5 o superior)
- VMware PowerCLI (vmware.vimautomation.core)
- Acceso a un servidor vCenter
- Zabbix Sender (`zabbix_sender.exe`) instalado localmente
- Acceso a red al servidor Zabbix

## 🧪 Instalación y uso

1. Asegúrate de tener instalado PowerCLI y el `zabbix_sender.exe` en la ruta indicada (`C:\Zabbix\scripts\`).
2. Edita las siguientes líneas del script para adaptarlas a tu entorno:

```powershell
Connect-VIServer 192.168.0.41 -user ro_zabbix@vsphere.local -Password EstaP***Contr4seña
C:\Zabbix\scripts\zabbix_sender.exe -z 192.168.120.152 -p 10051 -s "2X-RAS" -k ss.name -o $a
```

3. Ejecuta el script manualmente o prográmalo en el Programador de tareas de Windows.

## ▶️ Ejemplo de ejecución

```powershell
.m-snapshot-watcher.ps1
```

El script enviará una salida similar a:

```
VM:BackupServer01, SS:DailySnapshot
VM:AppServer02, SS:OldTestSnapshot
```

Y reportará dicha información al servidor Zabbix configurado.

Para la configuración del `zabbix_sender`, consulta la [documentación oficial de Zabbix](https://www.zabbix.com/documentation/current/en/manpages/zabbix_sender).

## 🛡️ Autor

**Cristian "SkyH34D" Franco**  
Offensive Security | Pentester | Red Team | IA Enthusiast | Agents & MCP Servers | CEH v13

_Creado con cariño en agosto de 2020_
