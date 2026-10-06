#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Setup.sh
# Função: Configura o ambiente Rclone e garante estrutura de diretórios
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21 (baseada em Sync-Folder-Rclone)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém funções relacionadas à configuração inicial e
# preparação do ambiente de sincronização. Inclui:
#   • configure_rclone_remote  → Auxilia na criação/configuração do remote Rclone
#   • ensure_directory         → Garante a existência de diretórios locais
#
# Dependências:
#   👉 Usa funções do CopyToGDriver_Utils.sh
#   👉 Usa variáveis globais do CopyToGDriver_Config.sh
# ===========================================================


# ===========================================================
# 🔗 Importar dependências
# ===========================================================
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"


# ===========================================================
# ⚙️ Função: configure_rclone_remote
# ===========================================================
# Cria e configura um remote Rclone (ex: Google Drive), se ainda não existir.
# Exibe instruções interativas e valida o resultado da configuração.
# ===========================================================
configure_rclone_remote() {
    write_color_output "[CONFIGURANDO REMOTE RCLONE]" "Cyan"
    
    local config_file="$HOME/.config/rclone/rclone.conf"
    
    # Verificar se o remote já existe
    if [[ -f "$config_file" ]] && grep -q "^\[$REMOTE_NAME\]" "$config_file" 2>/dev/null; then
        write_color_output "  [OK] Remote '$REMOTE_NAME' já está configurado" "Green"
        return 0
    fi

    # Exibir instruções interativas
    write_color_output "  Iniciando configuração do remote Google Drive..." "Yellow"
    echo ""
    write_color_output "  INSTRUÇÕES PARA CONFIGURAÇÃO:" "Magenta"
    write_color_output "  1. Escolha 'n' para criar um novo remote" "Cyan"
    write_color_output "  2. Digite o nome: $REMOTE_NAME" "Cyan"
    write_color_output "  3. Escolha o tipo: drive (Google Drive)" "Cyan"
    write_color_output "  4. Siga as instruções para autenticação no navegador" "Cyan"
    write_color_output "  5. Aceite as opções padrão (pressione Enter)" "Cyan"
    write_color_output "  6. Confirme com 'y' quando terminar" "Cyan"
    echo ""
    write_color_output "  Aguardando configuração interativa..." "Yellow"
    echo ""

    # Executar configuração interativa
    if rclone config; then
        # Confirmar se o remote foi criado com o nome esperado
        if [[ -f "$config_file" ]] && grep -q "^\[$REMOTE_NAME\]" "$config_file"; then
            write_color_output "  [OK] Remote '$REMOTE_NAME' configurado com sucesso!" "Green"
            return 0
        else
            write_color_output "  [AVISO] Remote criado com nome diferente" "Yellow"
            write_color_output "  Verifique os remotes disponíveis com: rclone listremotes" "Yellow"
            return 1
        fi
    else
        write_color_output "  [ERRO] Falha na configuração do remote" "Red"
        return 1
    fi
}


# ===========================================================
# 📁 Função: ensure_directory
# ===========================================================
# Garante que um diretório local exista; cria caso necessário.
# Retorna 0 em sucesso, 1 em erro.
# ===========================================================
ensure_directory() {
    local path="$1"

    if [[ -z "$path" ]]; then
        write_color_output "  [ERRO] Caminho de diretório não informado" "Red"
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
# 🔚 Fim do módulo CopyToGDriver_Setup.sh
# ===========================================================
