#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_Installer.sh
# Função: Instala o sistema CopyToGDriver e configura o Rclone
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.5.3 (corrigido cópia do script principal + aliases)
# ===========================================================

# 🛡️ Proteção CRLF (5 linhas mágicas)
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi


set -e

INSTALL_DIR="$HOME/scripts/CopyToGDriver"
LOG_ROOT="$HOME/CopyToGDriver_Log/system"
RCLONE_CONFIG="$HOME/.config/rclone/rclone.conf"
FLAG_FILE="$LOG_ROOT/.rclone_installed_by_copytogdriver"
REMOTE_NAME="gdriver"
DISK_REGISTRY="$HOME/.config/CopyToGDriver/disks_registry.conf"

echo "======================================================"
echo "🚀 Instalador do CopyToGDriver"
echo "======================================================"

# ===========================================================
# 📦 1. Instalar Rclone (se necessário)
# ===========================================================
echo "------------------------------------------------------"
echo "🔍 Verificando instalação do Rclone..."

if ! command -v rclone &>/dev/null; then
    echo "⚙️  Instalando Rclone..."
    curl -fsSL https://rclone.org/install.sh | sudo bash
    echo "✅ Rclone instalado com sucesso!"
    mkdir -p "$(dirname "$FLAG_FILE")"
    echo "installed_by_copytogdriver=true" > "$FLAG_FILE"
else
    echo "✅ Rclone já está instalado: $(rclone version | head -n1)"
fi

# ===========================================================
# ⚙️ 2. Configuração automática do remote gdriver
# ===========================================================
echo "------------------------------------------------------"
echo "🔗 Verificando configuração do remote '$REMOTE_NAME'..."

if [[ -f "$RCLONE_CONFIG" ]] && grep -q "^\[$REMOTE_NAME\]" "$RCLONE_CONFIG"; then
    echo "✅ Remote '$REMOTE_NAME' já está configurado."
else
    echo "⚙️  Criando remote '$REMOTE_NAME' para Google Drive..."
    mkdir -p "$(dirname "$RCLONE_CONFIG")"

    rclone config create "$REMOTE_NAME" drive scope=drive 2>/dev/null || {
        echo "❌ Falha ao criar remote '$REMOTE_NAME'."
        exit 1
    }

    echo "🌐 Abrindo navegador para autenticação Google..."
    echo "👉 Faça login na sua conta e conceda acesso ao Rclone."
    rclone about "$REMOTE_NAME": >/dev/null 2>&1 || rclone config reconnect "$REMOTE_NAME": || true

    if grep -q "^\[$REMOTE_NAME\]" "$RCLONE_CONFIG"; then
        echo "✅ Remote '$REMOTE_NAME' configurado com sucesso."
    else
        echo "❌ Falha ao autenticar o remote '$REMOTE_NAME'."
        exit 1
    fi
fi

# ===========================================================
# 🧩 3. Registrar discos do sistema
# ===========================================================
echo "------------------------------------------------------"
echo "💽 Detectando discos e registrando pontos de montagem..."

mkdir -p "$(dirname "$DISK_REGISTRY")"
> "$DISK_REGISTRY"

mount | grep '^/dev/' | grep -E 'ext4|btrfs|xfs|ntfs' | awk '{print $3}' | while read -r mount_point; do
    if [[ -d "$mount_point" ]]; then
        echo "$mount_point=ACTIVE" >> "$DISK_REGISTRY"
        echo "✅ Registrado: $mount_point"
    fi
done

if [[ ! -s "$DISK_REGISTRY" ]]; then
    echo "⚠️  Nenhum disco montado detectado — registrando /mnt como padrão."
    echo "/mnt=DEFAULT" >> "$DISK_REGISTRY"
fi

echo "📘 Registro salvo em: $DISK_REGISTRY"

# ===========================================================
# 📁 4. Instalar scripts principais
# ===========================================================
echo "------------------------------------------------------"
echo "📦 Instalando módulos do CopyToGDriver..."
mkdir -p "$INSTALL_DIR"

# CORREÇÃO: Copiar TODOS os scripts CopyToGDriver (incluindo o principal sem _)
cp -r ./CopyToGDriver* "$INSTALL_DIR" 2>/dev/null || true

# Garantir permissões de execução
chmod +x "$INSTALL_DIR"/*.sh

echo "✅ Scripts instalados em: $INSTALL_DIR"
echo "📄 Scripts copiados:"
ls -la "$INSTALL_DIR"/CopyToGDriver*.sh | wc -l

# ===========================================================
# 🔗 5. Criar aliases globais (copydrive, copycheck, copyrestore)
# ===========================================================
echo "------------------------------------------------------"
echo "🔗 Configurando aliases globais..."

BASHRC="$HOME/.bashrc"
if ! grep -q "alias copydrive=" "$BASHRC" 2>/dev/null; then
    {
        echo ""
        echo "# === CopyToGDriver Aliases ==="
        echo "alias copydrive='$INSTALL_DIR/CopyToGDriver_CopyCurrent.sh'"
        echo "alias copycheck='$INSTALL_DIR/CopyToGDriver.sh --check-only'"
        echo "alias copyrestore='$INSTALL_DIR/CopyToGDriver_Restore.sh'"
    } >> "$BASHRC"
    echo "✅ Aliases configurados:"
    echo "   🔄 copydrive   → Sincroniza a pasta atual"
    echo "   🔍 copycheck   → Verifica o ambiente"
    echo "   ♻️  copyrestore → Restaura backup mais recente da pasta atual"
else
    echo "ℹ️  Aliases já configurados no ~/.bashrc"
fi

# ===========================================================
# 🧩 6. Finalização
# ===========================================================
echo
echo "======================================================"
echo "✅ Instalação concluída com sucesso!"
echo "======================================================"
echo "📂 Scripts instalados em: $INSTALL_DIR"
echo "📜 Logs armazenados em:   $LOG_ROOT"
echo "💽 Registro de discos:    $DISK_REGISTRY"

if [[ -f "$FLAG_FILE" ]]; then
    echo "🧩 Rclone instalado pelo CopyToGDriver."
else
    echo "🧩 Rclone já existia no sistema — mantido."
fi

echo
echo "💡 Para ativar imediatamente os comandos, execute:"
echo "   source ~/.bashrc"
echo
echo "🎯 Comandos disponíveis:"
echo "   🔄 copydrive   → Sincroniza a pasta atual"
echo "   🔍 copycheck   → Verifica o ambiente"
echo "   ♻️  copyrestore → Restaura backup da pasta atual"
echo
echo "🗂️  Logs centralizados em: ~/CopyToGDriver_Log/system/"
echo "📘 Registro de discos em:  $DISK_REGISTRY"
echo