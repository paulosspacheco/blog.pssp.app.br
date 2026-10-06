#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver (Utilitário)
# Script: Remove_Rclone.sh
# Função: Remove completamente o Rclone do sistema
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 1.0.0
# Data: 31/10/2025
# ===========================================================

set -e

echo "======================================================"
echo "🧹 Utilitário de Remoção do Rclone"
echo "======================================================"

# ===========================================================
# ⚙️ Verifica se o Rclone está instalado
# ===========================================================
if ! command -v rclone &>/dev/null; then
    echo "ℹ️  Rclone não está instalado neste sistema."
    exit 0
fi

echo "📦 Rclone encontrado em: $(command -v rclone)"
rclone version | head -n2

echo
read -p "Deseja realmente remover o Rclone do sistema? (s/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[sS]$ ]]; then
    echo "❌ Operação cancelada."
    exit 0
fi

# ===========================================================
# 🚫 Interrompe possíveis processos ativos do Rclone
# ===========================================================
echo
echo "🛑 Encerrando processos ativos do Rclone..."
sudo pkill -f rclone 2>/dev/null || true
sleep 1

# ===========================================================
# 🧹 Remove binários e pacotes
# ===========================================================
echo
echo "🗑️  Removendo binários..."
sudo rm -f /usr/bin/rclone /usr/local/bin/rclone 2>/dev/null || true
sudo apt remove -y rclone 2>/dev/null || true
sudo dnf remove -y rclone 2>/dev/null || true
sudo yum remove -y rclone 2>/dev/null || true

# ===========================================================
# 📁 Remove arquivos de configuração e logs (opcional)
# ===========================================================
CONFIG_DIR="$HOME/.config/rclone"
LOG_DIR="$HOME/.rclone-sync"
echo
read -p "Deseja também remover configurações e logs locais? (s/N): " CONFIRM_CFG
if [[ "$CONFIRM_CFG" =~ ^[sS]$ ]]; then
    rm -rf "$CONFIG_DIR" "$LOG_DIR"
    echo "🧹 Configurações e logs removidos."
else
    echo "📦 Configurações preservadas em: $CONFIG_DIR"
fi

# ===========================================================
# ✅ Confirmação final
# ===========================================================
echo
if command -v rclone &>/dev/null; then
    echo "⚠️  Falha: O Rclone ainda está presente no sistema."
    echo "   Verifique manualmente o diretório /usr/bin/rclone ou /usr/local/bin/rclone."
else
    echo "✅ Rclone removido completamente com sucesso."
fi

echo
echo "======================================================"
echo "🧹 Remoção do Rclone concluída."
echo "======================================================"

