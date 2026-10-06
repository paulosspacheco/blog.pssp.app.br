#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_UnInstaller.sh
# Função: Remove completamente o sistema CopyToGDriver
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.4.1 (adiciona remoção de logs centralizados + registro discos)
# ===========================================================

set -e

INSTALL_DIR="$HOME/scripts/CopyToGDriver"
LOG_DIRS=("$HOME/.rclone-sync" "$HOME/CopyToGDriver_Log")
RCLONE_CONFIG_DIR="$HOME/.config/rclone"
DISK_REGISTRY_DIR="$HOME/.config/CopyToGDriver"
FLAG_FILE="$HOME/.rclone-sync/.rclone_installed_by_copytogdriver"
BASHRC="$HOME/.bashrc"
REMOTE_NAME="gdriver"

AUTO_MODE=false
for arg in "$@"; do
  [[ "$arg" == "--auto" ]] && AUTO_MODE=true
done

echo "======================================================"
echo "🧹 Desinstalador do CopyToGDriver"
echo "======================================================"

# ===========================================================
# 🧩 Função: confirmação (silenciosa em modo --auto)
# ===========================================================
confirmar() {
    local mensagem="$1"
    if [[ "$AUTO_MODE" == true ]]; then
        echo "AUTO: $mensagem → sim automático"
        return 0
    fi
    read -p "$mensagem (s/N): " resposta
    [[ "$resposta" =~ ^[sS]$ ]]
}

# ===========================================================
# 📦 1. Confirmar desinstalação
# ===========================================================
if [[ "$AUTO_MODE" == false ]]; then
    if ! confirmar "Tem certeza que deseja remover o CopyToGDriver do sistema?"; then
        echo "❌ Operação cancelada pelo usuário."
        exit 0
    fi
else
    echo "AUTO: Desinstalação iniciada sem confirmação."
fi

echo "------------------------------------------------------"
echo "🚮 Removendo módulos e pastas..."

# ===========================================================
# 🧩 2. Remover scripts principais
# ===========================================================
if [[ -d "$INSTALL_DIR" ]]; then
    rm -rf "$INSTALL_DIR"
    echo "✅ Diretório removido: $INSTALL_DIR"
else
    echo "ℹ️  Nenhum diretório encontrado em: $INSTALL_DIR"
fi

# ===========================================================
# 🧩 3. Limpar aliases no .bashrc
# ===========================================================
if grep -q "CopyToGDriver Aliases" "$BASHRC" 2>/dev/null; then
    sed -i '/# === CopyToGDriver Aliases ===/,+3d' "$BASHRC"
    echo "✅ Aliases removidos do ~/.bashrc"
else
    echo "ℹ️  Nenhum alias encontrado no ~/.bashrc"
fi

# ===========================================================
# 🧩 4. Remover logs centralizados
# ===========================================================
for log_dir in "${LOG_DIRS[@]}"; do
    if [[ -d "$log_dir" ]]; then
        if confirmar "Deseja remover os logs em '$log_dir'?"; then
            rm -rf "$log_dir"
            echo "✅ Logs removidos: $log_dir"
        else
            echo "ℹ️  Logs preservados em: $log_dir"
        fi
    fi
done

# ===========================================================
# 🧩 5. Remover registro de discos
# ===========================================================
if [[ -d "$DISK_REGISTRY_DIR" ]]; then
    if confirmar "Deseja remover o registro de discos em '$DISK_REGISTRY_DIR'?"; then
        rm -rf "$DISK_REGISTRY_DIR"
        echo "✅ Registro de discos removido."
    else
        echo "ℹ️  Registro de discos preservado em: $DISK_REGISTRY_DIR"
    fi
fi

# ===========================================================
# 🧩 6. Remover configuração e binário do Rclone
# ===========================================================
echo "------------------------------------------------------"
echo "🔍 Verificando instalação do Rclone..."

if command -v rclone &>/dev/null; then
    if [[ -f "$FLAG_FILE" ]]; then
        echo "🧩 Rclone foi instalado pelo CopyToGDriver."
        if confirmar "Deseja desinstalar completamente o Rclone e suas configurações?"; then
            sudo rm -f "$(command -v rclone)" 2>/dev/null || true
            rm -rf "$RCLONE_CONFIG_DIR"
            echo "✅ Rclone removido completamente."
        else
            echo "ℹ️  Rclone mantido conforme sua escolha."
        fi
    else
        echo "ℹ️  Rclone já existia antes da instalação — não será removido."
    fi
else
    echo "ℹ️  Rclone não está instalado."
fi

# ===========================================================
# 🧩 7. Remover remote do gdriver (opcional)
# ===========================================================
if [[ -f "$RCLONE_CONFIG_DIR/rclone.conf" ]] && grep -q "^\[$REMOTE_NAME\]" "$RCLONE_CONFIG_DIR/rclone.conf"; then
    if confirmar "Deseja remover o remote '$REMOTE_NAME' do Rclone?"; then
        rclone config delete "$REMOTE_NAME" || true
        echo "✅ Remote '$REMOTE_NAME' removido."
    else
        echo "ℹ️  Remote '$REMOTE_NAME' mantido."
    fi
fi

# ===========================================================
# 🧩 8. Finalização
# ===========================================================
echo "------------------------------------------------------"
echo "✅ Desinstalação concluída com sucesso!"
echo "------------------------------------------------------"
echo "💡 Para aplicar as mudanças, execute:"
echo "   source ~/.bashrc"
echo
echo "🧹 CopyToGDriver foi removido do sistema."
if [[ "$AUTO_MODE" == true ]]; then
    echo "🤖 Execução automática finalizada sem interação."
fi
echo