#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Setup.sh
# Função: Configura o ambiente Rclone e garante estrutura de diretórios
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.1.1 (força escopo "drive" e atualiza remoto antigo)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo:
#   • Configura automaticamente o Rclone e o remote "gdriver"
#   • Garante que os diretórios locais e de logs existam
#   • Atualiza o remote caso use escopo limitado (drive.file)
# ===========================================================

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh" 2>/dev/null || true
source "$SCRIPT_DIR/CopyToGDriver_Config.sh" 2>/dev/null || true

# ===========================================================
# ⚙️ Função: auto_configure_rclone_gdriver
# ===========================================================
auto_configure_rclone_gdriver() {
    local remote_name="gdriver"
    local config_file="$HOME/.config/rclone/rclone.conf"

    write_color_output "🔍 Verificando configuração automática do Rclone..." "Cyan"
    mkdir -p "$(dirname "$config_file")"

    # --- Se remote já existir, verificar escopo ---
    if [[ -f "$config_file" ]] && grep -q "^\[$remote_name\]" "$config_file"; then
        if grep -q "scope = drive.file" "$config_file"; then
            write_color_output "⚠️  Remote '$remote_name' usa escopo limitado (drive.file)." "Yellow"
            write_color_output "🔁 Atualizando para escopo completo (drive)..." "Blue"

            # Remove remote antigo e recria com escopo completo
            rclone config delete "$remote_name" >/dev/null 2>&1 || true
            if rclone config create "$remote_name" drive scope=drive 2>/dev/null; then
                write_color_output "✅ Remote '$remote_name' recriado com escopo completo." "Green"
            else
                write_color_output "❌ Falha ao recriar remote '$remote_name'." "Red"
                exit 1
            fi
        else
            write_color_output "✅ Remote '$remote_name' já está configurado corretamente." "Green"
            return 0
        fi
    else
        write_color_output "⚙️ Criando remote '$remote_name' para Google Drive..." "Yellow"
        if ! rclone config create "$remote_name" drive scope=drive 2>/dev/null; then
            write_color_output "❌ Falha ao criar remote '$remote_name'." "Red"
            exit 1
        fi
    fi

    # --- Autenticação interativa apenas uma vez ---
    write_color_output "🌐 Autenticação necessária — abrindo navegador..." "Blue"
    write_color_output "👉 Faça login com sua conta Google e conceda acesso." "Magenta"

    if ! rclone about "$remote_name": >/dev/null 2>&1; then
        write_color_output "⚠️ Aguardando autenticação do usuário..." "Yellow"
        rclone config reconnect "$remote_name": || {
            write_color_output "❌ Falha ao autenticar o remote '$remote_name'." "Red"
            exit 1
        }
    fi

    # --- Confirmação final ---
    if grep -q "^\[$remote_name\]" "$config_file"; then
        write_color_output "✅ Remote '$remote_name' configurado e autenticado com sucesso!" "Green"
    else
        write_color_output "❌ Remote '$remote_name' não foi encontrado após a configuração." "Red"
        exit 1
    fi
}

# ===========================================================
# 📁 Função: ensure_directory
# ===========================================================
ensure_directory() {
    local path="$1"
    if [[ -z "$path" ]]; then
        write_color_output "  [ERRO] Caminho de diretório não informado." "Red"
        return 1
    fi

    if [[ ! -d "$path" ]]; then
        mkdir -p "$path" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            write_color_output "  [OK] Diretório criado: $path" "Green"
        else
            write_color_output "  [ERRO] Falha ao criar diretório: $path" "Red"
            return 1
        fi
    else
        write_color_output "  [OK] Diretório já existe: $path" "Blue"
    fi
    return 0
}

# ===========================================================
# 🧩 Função: configure_rclone_remote (modo compatibilidade)
# ===========================================================
configure_rclone_remote() {
    auto_configure_rclone_gdriver
}

# ===========================================================
# 🧩 Execução direta (modo standalone)
# ===========================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    write_color_output "🚀 Executando configuração do ambiente CopyToGDriver..." "Cyan"
    ensure_directory "$HOME/.rclone-sync"
    ensure_directory "$HOME/.rclone-sync/logs"
    auto_configure_rclone_gdriver

    write_color_output "✅ Ambiente configurado com sucesso!" "Green"
    echo "------------------------------------------------------"
    echo "📄 Arquivo de configuração: $HOME/.config/rclone/rclone.conf"
    echo "📁 Logs: $HOME/.rclone-sync/logs"
    echo "------------------------------------------------------"
fi
