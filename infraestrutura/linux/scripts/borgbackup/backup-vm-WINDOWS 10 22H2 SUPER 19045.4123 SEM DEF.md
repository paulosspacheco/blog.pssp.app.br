# Script de Backup de VM com BorgBackup

Este script realiza backup de uma máquina virtual do VirtualBox utilizando **BorgBackup**, criando backups incrementais e mantendo um histórico gerenciável.

---

## Configuração

```bash
VM_NAME="WINDOWS 10 22H2 SUPER 19045.4123 SEM DEF"
SRC="/home/paulosspacheco/v/VirtualBoxVMs/$VM_NAME"
DEST="/media/paulosspacheco/Novo volume/virtualbox/$VM_NAME"
REPO="$DEST/borg-repo"
