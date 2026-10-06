#!/bin/bash

# Arquivo Unificado: Todos os scripts *.sh da pasta corrente
# Gerado em: 2025-11-03 12:07:00
# Original: Concatenação de 15 scripts


# =================== INÍCIO DO SCRIPT: includes/crossplatform/alias_manager.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: includes/crossplatform/alias_manager.sh
# Função: Instala aliases globais para facilitar o uso do sistema
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 1.0.0
# Data: 31/10/2025
# ===========================================================

set -e

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este script cria aliases globais no shell do usuário:
#   • copydrive  → executa sincronização da pasta atual
#   • copycheck  → valida se o sistema CopyToGDriver está configurado corretamente
#
# Compatível com:
#   • Linux (bash / zsh)
#   • Git Bash (Windows)
# ===========================================================

# ===========================================================
# ⚙️ CONFIGURAÇÕES INICIAIS
# ===========================================================
BASE_DIR="$HOME/scripts/CopyToGDriver"
ALIAS_LINE_DRIVE="alias copydrive='bash \"$BASE_DIR/CopyToGDriver_CopyCurrent.sh\"'"
ALIAS_LINE_CHECK="alias copycheck='bash \"$BASE_DIR/CopyToGDriver.sh\" --check-only'"
BASHRC_FILES=("$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc")

# ===========================================================
# 🧩 FUNÇÃO: add_alias
# ===========================================================
add_alias() {
    local alias_line="$1"
    local rc_file="$2"

    # Ignorar se o arquivo não existe
    [[ -f "$rc_file" ]] || return

    # Verificar se o alias já existe
    if grep -Fq "$alias_line" "$rc_file"; then
        echo "✅ Alias já existe em: $rc_file"
    else
        echo "$alias_line" >> "$rc_file"
        echo "🔗 Alias adicionado em: $rc_file"
    fi
}

# ===========================================================
# 🧩 FUNÇÃO: install_aliases
# ===========================================================
install_aliases() {
    echo "======================================================"
    echo "🔗 Instalando aliases globais do CopyToGDriver"
    echo "======================================================"

    for rc_file in "${BASHRC_FILES[@]}"; do
        add_alias "$ALIAS_LINE_DRIVE" "$rc_file"
        add_alias "$ALIAS_LINE_CHECK" "$rc_file"
    done

    echo
    echo "✅ Aliases adicionados com sucesso!"
    echo
    echo "📦 Comandos disponíveis a partir de agora:"
    echo "   • copydrive → sincroniza a pasta atual"
    echo "   • copycheck → verifica o ambiente CopyToGDriver"
    echo
    echo "💡 Dica: execute 'source ~/.bashrc' ou reinicie o terminal."
}

# ===========================================================
# ▶️ EXECUÇÃO PRINCIPAL
# ===========================================================
install_aliases

# =================== FIM DO SCRIPT: includes/crossplatform/alias_manager.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_Cache.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Cache.sh
# Função: Limpeza e verificação do cache Rclone e espaço em disco
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21 (baseada em Sync-Folder-Rclone)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém funções relacionadas ao controle de cache
# e verificação de espaço em disco durante a sincronização.
#
# Funções incluídas neste módulo:
#   • cleanup_rclone_cache         → Remove caches antigos e libera espaço
#   • check_disk_space_for_sync    → Verifica se há espaço suficiente para sincronizar
#
# Dependências:
#   👉 Usa funções utilitárias de CopyToGDriver_Utils.sh
#   👉 Usa variáveis globais de CopyToGDriver_Config.sh
# ===========================================================


# ===========================================================
# 🔗 Importar dependências
# ===========================================================
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"


# ===========================================================
# 🧹 Função: cleanup_rclone_cache
# ===========================================================
# Faz limpeza do cache local do Rclone, encerrando processos ativos
# e removendo diretórios temporários em múltiplas localizações conhecidas.
# ===========================================================
cleanup_rclone_cache() {
    write_color_output "[LIMPEZA DE CACHE RCLONE]" "Yellow"
    
    local cache_dirs=(
        "$HOME/.cache/rclone"
        "/media/paulosspacheco/85206044-cf3f-4ca0-a9d0-e25ec4a4e83c/.cache/rclone"
    )
    
    # Parar processos Rclone se estiverem rodando
    if pgrep rclone > /dev/null; then
        write_color_output "  Parando processos Rclone..." "Yellow"
        pkill rclone
        sleep 3
    fi
    
    local total_freed=0
    
    for cache_dir in "${cache_dirs[@]}"; do
        if [[ -d "$cache_dir" ]]; then
            local size_before=$(du -sb "$cache_dir" 2>/dev/null | cut -f1)
            local size_before_human=$(du -sh "$cache_dir" 2>/dev/null | cut -f1)
            
            write_color_output "  Limpando: $cache_dir ($size_before_human)" "Cyan"
            
            # Limpar conteúdo mas manter estrutura do diretório
            rm -rf "$cache_dir"/* 2>/dev/null
            rm -rf "$cache_dir"/.* 2>/dev/null
            
            local size_after=$(du -sb "$cache_dir" 2>/dev/null | cut -f1)
            local freed=$((size_before - size_after))
            total_freed=$((total_freed + freed))
            
            write_color_output "  Cache limpo: $cache_dir" "Green"
        fi
    done
    
    if [[ $total_freed -gt 0 ]]; then
        local freed_mb=$((total_freed / 1024 / 1024))
        write_color_output "  Espaço liberado: ${freed_mb}MB" "Green"
    else
        write_color_output "  Nenhum cache para limpar" "Blue"
    fi
}


# ===========================================================
# 💽 Função: check_disk_space_for_sync
# ===========================================================
# Verifica se o espaço livre em disco é suficiente para a sincronização.
# Retorna:
#   0 → Espaço suficiente
#   1 → Espaço insuficiente
#   2 → Espaço limitado (alerta, mas não falha)
# ===========================================================
check_disk_space_for_sync() {
    write_color_output "  [ESPAÇO] Verificando espaço para sincronização..." "Cyan"
    
    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "  Pasta local não existe, não é possível verificar espaço" "Yellow"
        return 0
    fi
    
    # Obter espaço disponível (em KB)
    local available_kb=$(df "$LOCAL_FOLDER" 2>/dev/null | awk 'NR==2 {print $4}')
    local available_gb=$((available_kb / 1024 / 1024))
    
    # Requerimentos mínimos de espaço
    local min_space_gb=5      # Mínimo absoluto
    local recommended_gb=10   # Recomendado
    
    write_color_output "  Espaço disponível: ${available_gb}GB" "Blue"
    
    if [[ $available_gb -lt $min_space_gb ]]; then
        write_color_output "  Espaço insuficiente para sincronização" "Red"
        write_color_output "  Disponível: ${available_gb}GB, Mínimo: ${min_space_gb}GB" "Yellow"
        write_color_output "  Execute com --clean-cache para liberar espaço" "Blue"
        return 1
    elif [[ $available_gb -lt $recommended_gb ]]; then
        write_color_output "  Espaço limitado para sincronização" "Yellow"
        write_color_output "  Disponível: ${available_gb}GB, Recomendado: ${recommended_gb}GB" "Yellow"
        write_color_output "  Considere usar --clean-cache" "Blue"
        return 2
    else
        write_color_output "  Espaço suficiente para sincronização" "Green"
        return 0
    fi
}


# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Cache.sh
# ===========================================================

# =================== FIM DO SCRIPT: CopyToGDriver_Cache.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_Checks.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Checks.sh
# Função: Verifica pré-requisitos, ambiente e condições antes da sincronização
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21 (baseada em Sync-Folder-Rclone)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo implementa funções de verificação e diagnóstico
# do ambiente antes da sincronização com o Google Drive.
#
# Funções principais que serão importadas aqui:
#   • check_rclone_installed       → verifica se o Rclone está instalado
#   • check_internet_connection    → confirma conectividade com a internet
#   • check_local_folder           → valida existência e permissões da pasta local
#   • check_rclone_remote          → verifica se o remote Rclone está configurado
#   • check_disk_space             → avalia espaço disponível no disco
#   • check_rclone_cache_size      → mede tamanho do cache e alerta se grande
#   • check_sensitive_location     → alerta se a pasta está em local de risco
#   • check_prerequisites          → orquestra todas as verificações acima
#
# Dependências:
#   👉 Este módulo usa funções do CopyToGDriver_Utils.sh
#   👉 Usa variáveis globais do CopyToGDriver_Config.sh
# ===========================================================


# ===========================================================
# 🔗 Importar dependências
# ===========================================================
# O caminho é resolvido com base no diretório atual do script.
# ===========================================================
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"


# ===========================================================
# 🧩 Função: check_rclone_installed
# ===========================================================
# Verifica se o comando rclone está instalado e acessível.
# Texto original inicia em: "check_rclone_installed() {"
# e termina em: "return 0"
# ===========================================================
check_rclone_installed() {
    write_color_output "  [1/5] Verificando Rclone..." "Cyan"
    
    if ! command -v rclone &> /dev/null; then
        write_color_output "  Rclone não encontrado no PATH" "Red"
        write_color_output "  Instalação necessária:" "Yellow"
        write_color_output "     Opção 1: curl https://rclone.org/install.sh | sudo bash" "Blue"
        write_color_output "     Opção 2: sudo apt install rclone (Debian/Ubuntu)" "Blue"
        write_color_output "     Opção 3: sudo yum install rclone (RHEL/CentOS)" "Blue"
        write_color_output "     Opção 4: sudo dnf install rclone (Fedora)" "Blue"
        return 1
    else
        local version=$(rclone version | head -n1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        write_color_output "  Rclone encontrado: $version" "Green"
        return 0
    fi
}



# ===========================================================
# 🌐 Função: check_internet_connection
# ===========================================================
# Testa conexão com sites confiáveis (Google, Cloudflare, GitHub, Rclone.org)
# ===========================================================
check_internet_connection() {
    write_color_output "  [2/5] Verificando conexão com a internet..." "Cyan"
    
    local test_endpoints=(
        "https://www.google.com"
        "https://www.cloudflare.com" 
        "https://www.github.com"
        "https://rclone.org"
    )
    
    local success=false
    
    for endpoint in "${test_endpoints[@]}"; do
        if curl --output /dev/null --silent --head --fail --max-time 10 "$endpoint"; then
            write_color_output "  Conexão detectada via: $(echo "$endpoint" | cut -d'/' -f3)" "Green"
            success=true
            break
        fi
    done
    
    if [[ "$success" == "false" ]]; then
        write_color_output "  Sem conexão com a internet" "Red"
        write_color_output "  Solução: Verifique sua conexão de rede e DNS" "Yellow"
        return 1
    fi
    
    return 0
}


# ===========================================================
# 📂 Função: check_local_folder
# ===========================================================
# Verifica existência, permissões e cria pasta caso não exista.
# ===========================================================
check_local_folder() {
    write_color_output "  [3/5] Verificando pasta local..." "Cyan"
    
    # Verificar se o caminho é válido
    if [[ -z "$LOCAL_FOLDER" ]]; then
        write_color_output "  Caminho da pasta local está vazio" "Red"
        return 1
    fi
    
    # CORREÇÃO: Expandir caminhos relativos para absolutos
    local expanded_local_folder="$LOCAL_FOLDER"
    if [[ "$LOCAL_FOLDER" != /* ]]; then
        expanded_local_folder="$(pwd)/$LOCAL_FOLDER"
        write_color_output "  Caminho relativo expandido: $expanded_local_folder" "Blue"
    else
        write_color_output "  Caminho absoluto: $LOCAL_FOLDER" "Blue"
    fi
    
    # Atualizar variável com caminho expandido
    LOCAL_FOLDER="$expanded_local_folder"
    
    # Tentar criar a pasta se não existir
    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "  Pasta local não encontrada: $LOCAL_FOLDER" "Yellow"
        
        # MELHORIA: Usar auto-create se especificado
        if [[ "$AUTO_CREATE" == "true" ]]; then
            write_color_output "  Criando pasta automaticamente (--auto-create)..." "Green"
            choice="s"
        else
            read -p "  Deseja criar a pasta? (s/N): " choice
        fi
        
        if [[ "$choice" == "s" || "$choice" == "S" ]]; then
            if mkdir -p "$LOCAL_FOLDER"; then
                write_color_output "  Pasta criada com sucesso: $LOCAL_FOLDER" "Green"
                
                # Verificar permissões de escrita
                if [[ -w "$LOCAL_FOLDER" ]]; then
                    write_color_output "  Permissões de escrita OK" "Green"
                else
                    write_color_output "  Sem permissão de escrita na pasta" "Red"
                    return 1
                fi
            else
                write_color_output "  Falha ao criar pasta: $LOCAL_FOLDER" "Red"
                return 1
            fi
        else
            write_color_output "  Pasta local necessária para sincronização" "Red"
            return 1
        fi
    else
        # Pasta existe, verificar permissões
        if [[ -w "$LOCAL_FOLDER" ]]; then
            # MELHORIA: Contagem mais eficiente de arquivos
            local item_count=$(find "$LOCAL_FOLDER" -maxdepth 1 -type f 2>/dev/null | wc -l)
            local folder_size=$(du -sh "$LOCAL_FOLDER" 2>/dev/null | cut -f1)
            write_color_output "  Pasta local válida: $LOCAL_FOLDER" "Green"
            write_color_output "  Conteúdo: $item_count arquivos, tamanho: $folder_size" "Blue"
        else
            write_color_output "  Sem permissão de escrita na pasta: $LOCAL_FOLDER" "Red"
            return 1
        fi
    fi
    
    return 0
}


# ===========================================================
# ☁️ Função: check_rclone_remote
# ===========================================================
# Valida se o remote do Rclone existe e se consegue listar pastas.
# ===========================================================

check_rclone_remote() {
    write_color_output "  [4/5] Verificando remote Rclone..." "Cyan"
    
    local config_file="$HOME/.config/rclone/rclone.conf"
    
    # Verificar se arquivo de configuração existe
    if [[ ! -f "$config_file" ]]; then
        write_color_output "  Arquivo de configuração do Rclone não encontrado" "Red"
        write_color_output "  Execute: rclone config" "Yellow"
        
        # CORREÇÃO: Oferecer para configurar o remote
        if [[ "$AUTO_CREATE" == "true" ]]; then
            write_color_output "  Executando configuração automática do Rclone..." "Green"
            configure_rclone_remote
        else
            read -p "  Deseja configurar o Rclone agora? (s/N): " choice
            if [[ "$choice" == "s" || "$choice" == "S" ]]; then
                configure_rclone_remote
            else
                return 1
            fi
        fi
    fi
    
    # Verificar se o remote específico existe
    if grep -q "^\[$REMOTE_NAME\]" "$config_file" 2>/dev/null; then
        write_color_output "  Remote '$REMOTE_NAME' configurado" "Green"
        
        # Testar conexão com o remote
        write_color_output "  Testando conexão com remote..." "Cyan"
        if rclone lsd "$REMOTE_NAME:" --max-depth 1 &>/dev/null; then
            write_color_output "  Conexão com remote OK" "Green"
            
            # MELHORIA: Verificação mais robusta da pasta remota
            write_color_output "  Verificando pasta remota: $REMOTE_FOLDER" "Cyan"
            
	    # 👉 NOVO: se estamos em modo auto, cria agora
	    if [[ "$AUTO_CREATE" == "true" ]]; then
		write_color_output "  (--auto-create) Criando pasta remota agora: $REMOTE_NAME:$REMOTE_FOLDER" "Blue"
		if rclone mkdir "$REMOTE_NAME:$REMOTE_FOLDER" &>/dev/null; then
		    write_color_output "  [OK] Pasta remota criada: $REMOTE_NAME:$REMOTE_FOLDER" "Green"
		else
		    write_color_output "  [ERRO] Não foi possível criar a pasta remota" "Red"
		    return 1
		fi
	    else
		# comportamento antigo (só avisa)
		write_color_output "  Tentando encontrar caminhos similares..." "Blue"
		local similar_paths=$(rclone lsd "$REMOTE_NAME:" -R 2>/dev/null | grep -i "$(basename "$REMOTE_FOLDER")" | head -5)
		if [[ -n "$similar_paths" ]]; then
		    write_color_output "  Caminhos similares encontrados:" "Yellow"
		    echo "$similar_paths"
		    write_color_output "  Use o caminho completo correto com -f" "Blue"
		else
		    write_color_output "  Nenhum caminho similar encontrado" "Yellow"
		    write_color_output "  A pasta será criada durante a sincronização" "Blue"
		fi
	    fi

            
            return 0
        else
            write_color_output "  Falha na conexão com remote '$REMOTE_NAME'" "Red"
            write_color_output "  Execute: rclone config" "Yellow"
            return 1
        fi
    else
        write_color_output "  Remote '$REMOTE_NAME' não encontrado na configuração" "Red"
        write_color_output "  Remotes disponíveis:" "Yellow"
        rclone listremotes 2>/dev/null || echo "    Nenhum remote configurado"
        
        # CORREÇÃO: Oferecer para configurar o remote
        if [[ "$AUTO_CREATE" == "true" ]]; then
            write_color_output "  Executando configuração automática do Rclone..." "Green"
            configure_rclone_remote
        else
            read -p "  Deseja configurar o Rclone agora? (s/N): " choice
            if [[ "$choice" == "s" || "$choice" == "S" ]]; then
                configure_rclone_remote
            else
                return 1
            fi
        fi
    fi
}


# ===========================================================
# 💽 Função: check_disk_space
# ===========================================================
# Verifica espaço total, livre e percentual de uso no disco local.
# ===========================================================
check_disk_space() {
    write_color_output "  [5/5] Verificando espaço em disco..." "Cyan"
    
    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "  Não foi possível verificar espaço - pasta não existe" "Yellow"
        return 0
    fi
    
    # Obter informações do disco
    local disk_info=$(df "$LOCAL_FOLDER" 2>/dev/null | awk 'NR==2')
    
    if [[ -z "$disk_info" ]]; then
        write_color_output "  Não foi possível obitar informações do disco" "Yellow"
        return 0
    fi
    
    # Extrair valores
    local available_kb=$(echo "$disk_info" | awk '{print $4}')
    local total_kb=$(echo "$disk_info" | awk '{print $2}')
    local use_percent=$(echo "$disk_info" | awk '{print $5}')
    local mount_point=$(echo "$disk_info" | awk '{print $6}')
    
    # Converter para GB
    local available_gb=$((available_kb / 1024 / 1024))
    local total_gb=$((total_kb / 1024 / 1024))
    
    write_color_output "  Ponto de montagem: $mount_point" "Blue"
    write_color_output "  Espaço total: ${total_gb}GB, Disponível: ${available_gb}GB, Uso: $use_percent" "Blue"
    
    # Definir limites de espaço (1GB mínimo recomendado)
    local min_space_gb=1
    local warning_space_gb=5
    
    if [[ $available_gb -lt $min_space_gb ]]; then
        write_color_output "  Espaço em disco insuficiente (mínimo ${min_space_gb}GB)" "Red"
        write_color_output "  Libere espaço ou escolha outro local" "Yellow"
        return 1
    elif [[ $available_gb -lt $warning_space_gb ]]; then
        write_color_output "  Espaço em disco limitado (${available_gb}GB disponível)" "Yellow"
        write_color_output "  Recomendado ter pelo menos ${warning_space_gb}GB" "Blue"
        return 0
    else
        write_color_output "  Espaço em disco suficiente (${available_gb}GB disponível)" "Green"
        return 0
    fi
}


# ===========================================================
# 🧹 Função: check_rclone_cache_size
# ===========================================================
# Mede tamanho do cache (~/.cache/rclone) e emite alertas se grande.
# ===========================================================

check_rclone_cache_size() {
    write_color_output "  [CACHE] Verificando cache do Rclone..." "Cyan"
    
    local cache_dir="$HOME/.cache/rclone"
    local max_cache_size="2G"  # 2GB máximo recomendado
    
    if [[ -d "$cache_dir" ]]; then
        local cache_size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1)
        local cache_size_bytes=$(du -sb "$cache_dir" 2>/dev/null | cut -f1)
        
        write_color_output "  Tamanho do cache: $cache_size" "Blue"
        
        # Verificar se o cache está muito grande (> 2GB)
        if [[ $cache_size_bytes -gt 2147483648 ]]; then  # 2GB em bytes
            write_color_output "  Cache grande detectado (> 2GB)" "Yellow"
            return 1
        elif [[ "$cache_size" == *"G"* ]]; then
            local size_gb=$(echo "$cache_size" | sed 's/G//')
            if (( $(echo "$size_gb > 1.5" | bc -l 2>/dev/null || echo "0") )); then
                write_color_output "  Cache está ficando grande" "Yellow"
                return 2
            fi
        fi
        
        write_color_output "  Tamanho do cache OK" "Green"
        return 0
    else
        write_color_output "  Nenhum cache encontrado" "Green"
        return 0
    fi
}


# ===========================================================
# ⚠️ Função: check_sensitive_location
# ===========================================================
# Detecta locais sensíveis (/, /usr, /var, /home, etc.)
# ===========================================================
check_sensitive_location() {
    write_color_output "  [LOCALIZAÇÃO] Verificando pasta local..." "Cyan"
    
    local sensitive_locations=(
        "/media/paulosspacheco/85206044-cf3f-4ca0-a9d0-e25ec4a4e83c"
        "/"
        "/home"
        "/var"
        "/usr"
    )
    
    for location in "${sensitive_locations[@]}"; do
        if [[ "$LOCAL_FOLDER" == "$location"* ]]; then
            write_color_output "  AVISO: Pasta local em localização sensível" "Yellow"
            write_color_output "  $LOCAL_FOLDER" "Yellow"
            write_color_output "  Recomendado usar: $HOME/$(basename "$LOCAL_FOLDER")" "Blue"
            return 1
        fi
    done
    
    write_color_output "  Localização da pasta OK" "Green"
    return 0
}

# ===========================================================
# ✅ Função: check_prerequisites
# ===========================================================
# Orquestra todas as verificações anteriores.
# Retorna 0 se todas as condições forem atendidas.
# ===========================================================
check_prerequisites() {
    write_color_output "[VALIDANDO PRE-REQUISITOS]" "Cyan"
    echo ""
    
    local all_checks_passed=true
    
    # 1. Verificar Rclone instalado
    if ! check_rclone_installed; then
        all_checks_passed=false
    fi
    echo ""
    
    # 2. Verificar conexão com internet
    if ! check_internet_connection; then
        all_checks_passed=false
    fi
    echo ""
    
    # 3. Verificar pasta local
    if ! check_local_folder; then
        all_checks_passed=false
    fi
    echo ""
    
    # 4. Verificar remote Rclone
    if ! check_rclone_remote; then
        all_checks_passed=false
    fi
    echo ""
    
    # 5. Verificar espaço em disco
    if ! check_disk_space; then
        # Espaço insuficiente é um warning, não necessariamente falha
        if [[ "$all_checks_passed" == "true" ]]; then
            write_color_output "  Continuando com espaço limitado..." "Yellow"
        else
            all_checks_passed=false
        fi
    fi
    echo ""
    
    # NOVAS VERIFICAÇÕES ADICIONADAS
    write_color_output "[VERIFICAÇÕES ADICIONAIS]" "Cyan"
    
    # 6. Verificar cache
    if ! check_rclone_cache_size; then
        write_color_output "  Considere usar --clean-cache" "Blue"
    fi
    echo ""
    
    # 7. Verificar espaço para sincronização
    if ! check_disk_space_for_sync; then
        if [[ "$all_checks_passed" == "true" && "$CLEAN_CACHE" != "true" ]]; then
            write_color_output "  Execute com --clean-cache para liberar espaço" "Blue"
        fi
    fi
    echo ""
    
    # 8. Verificar localização sensível
    check_sensitive_location
    echo ""
    
    # Resumo final
    if [[ "$all_checks_passed" == "true" ]]; then
        write_color_output "TODOS OS PRÉ-REQUISITOS ATENDIDOS" "Green"
        write_color_output "   Sincronização pode ser iniciada com segurança" "Blue"
        return 0
    else
        write_color_output "PRÉ-REQUISITOS NÃO ATENDIDOS" "Red"
        write_color_output "   Corrija os problemas acima antes de continuar" "Yellow"
        return 1
    fi
}


# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Checks.sh
# ===========================================================

# =================== FIM DO SCRIPT: CopyToGDriver_Checks.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_ConfigFunctions.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_ConfigFunctions.sh
# Função: Implementa funções de configuração e parsing de parâmetros
# Autor: Paulo SSPacheco
# Versão: 0.0.0.23
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém as funções responsáveis por:
#   • Confirmar execução de sincronização com o usuário
#   • Calcular valores padrão dinâmicos (pasta local, remota, etc.)
#   • Exibir ajuda detalhada e exemplos de uso
#   • Fazer parsing dos parâmetros da linha de comando
# 
# Essas funções utilizam as variáveis globais definidas em:
#   👉 CopyToGDriver_Config.sh
# 
# E utilizam a função de saída colorida definida em:
#   👉 CopyToGDriver_Utils.sh
# ===========================================================


# ===========================================================
# 🌈 Função utilitária: write_color_output
# ===========================================================
write_color_output() {
    local message="$1"
    local color="$2"
    case $color in
        "Red") echo -e "\033[31m$message\033[0m" ;;
        "Green") echo -e "\033[32m$message\033[0m" ;;
        "Yellow") echo -e "\033[33m$message\033[0m" ;;
        "Blue") echo -e "\033[34m$message\033[0m" ;;
        "Magenta") echo -e "\033[35m$message\033[0m" ;;
        "Cyan") echo -e "\033[36m$message\033[0m" ;;
        *) echo "$message" ;;
    esac
}


# ===========================================================
# 🧩 Função: confirm_sync
# ===========================================================
confirm_sync() {
    write_color_output "Modo automático: usando pasta atual como padrão" "Cyan"
    write_color_output "   Local:  $LOCAL_FOLDER" "Blue"
    write_color_output "   Remoto: $REMOTE_NAME:$REMOTE_FOLDER" "Blue"
    echo ""
    
    local choice
    read -p "Deseja sincronizar a pasta corrente '$LOCAL_FOLDER' para a pasta de mesmo nome dentro da pasta 'rclone' na nuvem '$REMOTE_NAME'? (s/N): " choice
    
    if [[ "$choice" != "s" && "$choice" != "S" ]]; then
        write_color_output "Sincronização cancelada pelo usuário." "Yellow"
        exit 0
    fi
    
    write_color_output "Prosseguindo com a sincronização..." "Green"
    echo ""
}


# ===========================================================
# 🧩 Função: calculate_defaults
# ===========================================================
calculate_defaults() {
    if [[ -z "$DEFAULT_LOCAL_FOLDER" ]]; then
        DEFAULT_LOCAL_FOLDER="$(pwd)"
    fi
    
    if [[ -z "$DEFAULT_REMOTE_FOLDER" ]]; then
        local basename_folder
        basename_folder="$(basename "$(pwd)")"
        DEFAULT_REMOTE_FOLDER="rclone/$basename_folder"
    fi
    
    if [[ -z "$DEFAULT_REMOTE_FOLDER" ]]; then
        DEFAULT_REMOTE_FOLDER="rclone/sync-$(date +%Y%m%d)"
    fi
}


# ===========================================================
# 🧩 Função auxiliar: is_effectively_empty
# ===========================================================
# Considera a pasta “vazia” se contém apenas scripts do sistema CopyToGDriver.
# ===========================================================
is_effectively_empty() {
    local folder="$1"

    # Conta arquivos que NÃO sejam scripts internos nem ignores
    local useful_count
    useful_count=$(find "$folder" -maxdepth 1 -type f \
        ! -name "CopyToGDriver_CopyCurrent.sh" \
        ! -name "CopyToGDriver_Restore.sh" \
        ! -name "CopyToGDriver_*.sh" \
        ! -name "CopyToGDriverIgnore.txt" \
        ! -name "CopyToGDriver_ignore.txt" \
        2>/dev/null | wc -l)

    [[ "$useful_count" -eq 0 ]]
}


# ===========================================================
# 🧩 Função: show_help
# ===========================================================
show_help() {
    calculate_defaults
    
    cat << EOF
Uso: $0 [OPCOES]

Sincronização bidirecional Rclone com parâmetros dinâmicos.

VALORES PADRÃO:
  • Pasta Local:      Diretório atual ($(basename "$(pwd)"))
  • Pasta Remota:     "rclone/[nome da pasta atual]" no Google Drive ("$DEFAULT_REMOTE_FOLDER")
  • Remote:           "$DEFAULT_REMOTE_NAME"

OPÇÕES:
    -l, --local-folder DIR      Pasta local (padrão: diretório atual)
    -r, --remote-name NAME      Nome do remote Rclone (padrão: $DEFAULT_REMOTE_NAME)
    -f, --remote-folder PATH    Pasta remota (padrão: "$DEFAULT_REMOTE_FOLDER")
    -a, --auto-create           Cria pastas automaticamente
    -c, --clean-cache           Limpa cache do Rclone antes de sincronizar
    -n, --dry-run               Executa em modo simulação (sem alterar nada)
    -v, --verbose               Exibe logs detalhados
    -R, --resync                Força ressincronização completa
    -h, --help                  Mostra esta ajuda

EXEMPLOS:
    $0                                  # Sincroniza a pasta atual
    $0 --dry-run                        # Simula sem alterar nada
    $0 -f "rclone/projetos/app"         # Pasta remota específica
    $0 -a -c                            # Cria pastas e limpa cache

DICA:
  - Se a pasta local contiver apenas scripts do sistema, o sistema tenta restaurar
    automaticamente o backup mais recente do Google Drive (rclone.deleted).
EOF
}


# ===========================================================
# 🧩 Função: parse_parameters
# ===========================================================
parse_parameters() {
    local has_parameters=false
    local explicit_remote_folder=false
    
    if [[ $# -eq 0 ]]; then
        SHOW_HELP=false
    else
        has_parameters=true
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -l|--local-folder) LOCAL_FOLDER="$2"; shift 2 ;;
            -r|--remote-name) REMOTE_NAME="$2"; shift 2 ;;
            -f|--remote-folder) REMOTE_FOLDER="$2"; explicit_remote_folder=true; shift 2 ;;
            -n|--dry-run) DRY_RUN=true; shift ;;
            -v|--verbose) VERBOSE=true; shift ;;
            -R|--resync) RESYNC=true; shift ;;
            -a|--auto-create) AUTO_CREATE=true; shift ;;
            -c|--clean-cache) CLEAN_CACHE=true; shift ;;
            -h|--help) SHOW_HELP=true; shift ;;
            *) write_color_output "Erro: Parâmetro desconhecido: $1" "Red"; show_help; exit 1 ;;
        esac
    done

    calculate_defaults

    LOCAL_FOLDER="${LOCAL_FOLDER:-$DEFAULT_LOCAL_FOLDER}"
    REMOTE_NAME="${REMOTE_NAME:-$DEFAULT_REMOTE_NAME}"

    if [[ "$explicit_remote_folder" == "false" ]]; then
        REMOTE_FOLDER="${REMOTE_FOLDER:-$DEFAULT_REMOTE_FOLDER}"
        echo "DEBUG: REMOTE_FOLDER usando valor padrão dinâmico: '$REMOTE_FOLDER'" >&2
    else
        echo "DEBUG: REMOTE_FOLDER usando valor explícito: '$REMOTE_FOLDER'" >&2
    fi

    if [[ "$has_parameters" == "false" && "$SHOW_HELP" == "false" ]]; then
        confirm_sync
    fi

    # =======================================================
    # 🔄 NOVO: restauração automática se a pasta só tiver scripts
    # =======================================================
    if [[ -d "$LOCAL_FOLDER" ]]; then
        if is_effectively_empty "$LOCAL_FOLDER"; then
            write_color_output "⚠️  A pasta local '$LOCAL_FOLDER' contém apenas scripts do sistema." "Yellow"
            write_color_output "Tentando restaurar o conteúdo do Google Drive..." "Cyan"

            local restore_script_path="$(dirname "$0")/CopyToGDriver_Restore.sh"

            if [[ -x "$restore_script_path" ]]; then
                bash "$restore_script_path" --remote-folder "$(basename "$LOCAL_FOLDER")"
                local restore_exit=$?

                # 🔍 Tratamento de retorno do restore
                case $restore_exit in
                    11)
                        write_color_output "🛑 Restauração concluída com segurança." "Yellow"
                        write_color_output "🚫 Sincronização interrompida propositalmente para evitar sobrescrita." "Red"
                        write_color_output "👉 Revise os arquivos restaurados e execute novamente a sincronização." "Cyan"
                        exit 0  # encerra imediatamente
                        ;;
                    0)
                        write_color_output "⚠️  Restauração concluída sem código especial." "Yellow"
                        write_color_output "Encerrando também para evitar sincronização imediata." "Yellow"
                        exit 0  # encerra também
                        ;;
                    *)
                        write_color_output "❌ Falha durante a restauração (código $restore_exit)." "Red"
                        write_color_output "Abortando para evitar perda de dados." "Red"
                        exit 1
                        ;;
                esac

            else
                write_color_output "❌ Script de restauração não encontrado em:" "Red"
                write_color_output "   $restore_script_path" "Yellow"
                write_color_output "Abortando para evitar perda de dados." "Red"
                exit 1
            fi
        fi
    fi
    


}

# =================== FIM DO SCRIPT: CopyToGDriver_ConfigFunctions.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_Config.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Config.sh
# Função: Define variáveis globais e padrões de configuração
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.0.0.22
# ===========================================================

# ===========================================================
# 📦 VARIÁVEIS GERAIS DO SISTEMA
# ===========================================================
SCRIPT_NAME="CopyToGDriver"                    # Nome base do script principal
SCRIPT_VERSION="0.0.0.22"                      # Versão atual do projeto
SYNC_ROOT="$HOME/.rclone-sync"                 # Diretório de sincronização local
LOG_DIR="$SYNC_ROOT/logs"                      # Diretório central de logs
TMP_DIR="$SYNC_ROOT/tmp"                       # Diretório temporário

# ===========================================================
# 🌐 VARIÁVEIS DE LOCALIZAÇÃO NO GOOGLE DRIVE
# ===========================================================
# Essas variáveis controlam onde os arquivos são armazenados no Drive.
# A estrutura final será sempre:
#   gdriver:<BASE_REMOTE_FOLDER>/<pasta_local>
#   gdriver:<DELETED_BASE_FOLDER>/<pasta_local>/<data>
# -----------------------------------------------------------
BASE_REMOTE_FOLDER="rclone"                    # Pasta base principal (conteúdo ativo)
DELETED_BASE_FOLDER="rclone.deleted"           # Pasta base para backups de arquivos removidos
# -----------------------------------------------------------
# Exemplo:
#   Pasta local ........: /home/paulo/Projetos/Backup
#   Remote Rclone ......: gdriver
#   Resultado no Drive .: gdriver:rclone/Backup
#   Backup de deletados : gdriver:rclone.deleted/Backup/2025-10-31
# ===========================================================

# ===========================================================
# ⚙️ PARÂMETROS DE FUNCIONAMENTO PADRÃO
# ===========================================================
DEFAULT_REMOTE_NAME="gdriver"                  # Nome padrão do remote configurado no Rclone
DEFAULT_EXCLUDE_FILE="./CopyToGDriver_ignore.txt" # Arquivo de exclusões padrão
DEFAULT_LOCAL_FOLDER="./"                      # Pasta local padrão (pasta corrente)
DEFAULT_REMOTE_FOLDER="$(basename "$(pwd)")"   # Nome padrão da pasta remota (igual à atual)

# ===========================================================
# 🧾 LOGS E HISTÓRICO
# ===========================================================
LOG_RETENTION_DAYS=30                          # Quantos dias manter logs
ZIP_AFTER_DAYS=7                               # Compactar logs após X dias
HISTORY_FILE="$LOG_DIR/SyncHistory.csv"         # Histórico centralizado de execuções

# ===========================================================
# 💾 ARMAZENAMENTO E CACHE
# ===========================================================
CACHE_DIR="$SYNC_ROOT/cache"                   # Cache local do rclone
RCLONE_CONFIG_FILE="$HOME/.config/rclone/rclone.conf" # Caminho padrão da configuração rclone

# ===========================================================
# 🎨 CORES DO TERMINAL (usadas em Utils)
# ===========================================================
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_BLUE="\033[0;34m"
COLOR_CYAN="\033[0;36m"
COLOR_MAGENTA="\033[0;35m"
COLOR_RESET="\033[0m"

# ===========================================================
# 🧩 FLAGS DE MODO
# ===========================================================
DRY_RUN="false"                                # Modo simulação (dry-run)
VERBOSE="false"                                # Modo verboso
AUTO_CREATE="false"                            # Cria pastas automaticamente
CLEAN_CACHE="false"                            # Limpa cache rclone após execução
RESYNC="false"                                 # Reforça reindexação (resync)
SHOW_HELP="false"                              # Exibe ajuda e encerra
# ===========================================================

# ===========================================================
# 🔧 FUNÇÃO DE INICIALIZAÇÃO
# ===========================================================
initialize_environment() {
    mkdir -p "$LOG_DIR" "$TMP_DIR" "$CACHE_DIR"
}

initialize_environment

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Config.sh
# ===========================================================

# =================== FIM DO SCRIPT: CopyToGDriver_Config.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_CopyCurrent.sh ===================

#!/bin/bash
# ======================================================
# Script: CopyToGDriver_CopyCurrent.sh
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Data: 01/11/2025
# Versão: 0.4.1 (centralização de logs e estrutura aprimorada)
#
# Objetivo:
#   Sincronizar a pasta corrente com o Google Drive,
#   detectando automaticamente o disco e caminho relativo.
#
# Recursos:
#   ✅ Funciona em qualquer diretório de qualquer disco
#   ✅ Usa discos registrados em ~/.config/CopyToGDriver/disks_registry.conf
#   ✅ Monta caminho remoto hierárquico (rclone/<caminho_relativo>)
#   ✅ Protege contra sobrescrita após restauração
#   ✅ Suporta modo automático (--auto)
#   ✅ Logs centralizados em ~/CopyToGDriver_Log/
# ======================================================

# ======================================================
# 🔧 CONFIGURAÇÕES INICIAIS
# ======================================================
: "${SCRIPT_NAME:=/home/paulosspacheco/scripts/CopyToGDriver/CopyToGDriver.sh}"
: "${BASE_REMOTE_FOLDER:=rclone}"
: "${DELETED_BASE_FOLDER:=rclone.deleted}"
REMOTE_NAME="gdriver"
ORIGEM="./"
EXCECOES="./CopyToGDriver_ignore.txt"

LOG_ROOT="$HOME/CopyToGDriver_Log"
LOG_DIR="$LOG_ROOT/system"
RESTORE_MARKER="$LOG_ROOT/.restore_aborted"
DISK_REGISTRY="$HOME/.config/CopyToGDriver/disks_registry.conf"

# ======================================================
# 🧾 Preparação
# ======================================================
LOCAL_FOLDER="$(cd "$ORIGEM" && pwd)"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/sync-$(basename "$LOCAL_FOLDER")-$TIMESTAMP.log"

AUTO_MODE=false
for arg in "$@"; do
  [[ "$arg" == "--auto" ]] && AUTO_MODE=true && break
done

# ======================================================
# 💽 Função: Detectar o disco base e caminho relativo
# ======================================================
get_disk_base_path() {
  local folder="$1"
  local registry="$DISK_REGISTRY"

  if [[ ! -f "$registry" ]]; then
    echo "⚠️  Registro de discos não encontrado: $registry"
    echo "   Execute novamente o instalador do CopyToGDriver."
    echo "   Usando fallback para base '/mnt'."
    echo "/mnt"
    return
  fi

  local best_match=""
  local longest_match=0

  while IFS='=' read -r path _; do
    path=$(echo "$path" | xargs)
    [[ -z "$path" || "$path" == \[*\] ]] && continue

    if [[ "$folder" == "$path"* ]]; then
      local len=${#path}
      if (( len > longest_match )); then
        longest_match=$len
        best_match="$path"
      fi
    fi
  done < "$registry"

  if [[ -z "$best_match" ]]; then
    echo "⚠️  Nenhum disco correspondente encontrado em $registry."
    echo "   Fallback: usando /mnt como base."
    echo "/mnt"
  else
    echo "$best_match"
  fi
}

# ======================================================
# 🧩 Determina caminho remoto seguro e relativo
# ======================================================
DISK_BASE=$(get_disk_base_path "$LOCAL_FOLDER")
RELATIVE_PATH="${LOCAL_FOLDER#${DISK_BASE}/}"
REMOTE_FOLDER="$RELATIVE_PATH"

REMOTE_FOLDER=$(echo "$REMOTE_FOLDER" | sed 's|//*|/|g' | sed 's|^/||')
[[ -z "$REMOTE_FOLDER" ]] && REMOTE_FOLDER="$(basename "$LOCAL_FOLDER")"

# ======================================================
# 🧭 CABEÇALHO INFORMATIVO
# ======================================================
echo "======================================================"
echo "🔄 Sincronização com Google Drive (CopyToGDriver)"
echo "======================================================"
echo "📂 Pasta local ......: $LOCAL_FOLDER"
echo "💽 Disco base .......: $DISK_BASE"
echo "🧭 Caminho relativo ..: $RELATIVE_PATH"
echo "☁️  Remote Rclone ....: $REMOTE_NAME"
echo "📁 Pasta remota ......: $BASE_REMOTE_FOLDER/$REMOTE_FOLDER"
echo "🗑️  Pasta de backup ...: $DELETED_BASE_FOLDER/"
echo "🚫 Arquivo ignore ....: ${EXCECOES:-nenhum}"
echo "📜 Log ...............: $LOG_FILE"
echo "======================================================"
echo

# ======================================================
# 🧱 VERIFICAÇÕES BÁSICAS
# ======================================================
if ! command -v rclone &>/dev/null; then
  echo "❌ ERRO: Rclone não está instalado."
  echo "   Instale com: curl https://rclone.org/install.sh | sudo bash"
  exit 1
fi

# 🔍 Localiza o script principal
if [[ -x "$SCRIPT_NAME" ]]; then
  ROOT_PATH="$SCRIPT_NAME"
else
  ROOT_PATH=$(find "$HOME" /mnt /media /srv /opt -maxdepth 5 -type f -name "$(basename "$SCRIPT_NAME")" 2>/dev/null | head -n1)
fi

if [[ "$ROOT_PATH" == *"/Trash/"* ]]; then
  echo "❌ ERRO: O script principal está na Lixeira: $ROOT_PATH"
  exit 1
fi

if [[ -z "$ROOT_PATH" ]]; then
  echo "❌ ERRO: Não encontrei o script principal '$SCRIPT_NAME'."
  echo "   Dica: export SCRIPT_NAME=/caminho/para/CopyToGDriver.sh"
  exit 1
fi

echo "📄 Script principal localizado em: $ROOT_PATH"
echo

# ======================================================
# ⚠️ INTERROMPE SE RESTAURAÇÃO FOI FEITA
# ======================================================
if [[ -f "$RESTORE_MARKER" ]]; then
  echo "🛑 Detectado processo de restauração recente."
  echo "🚫 Sincronização abortada para evitar sobrescrita."
  rm -f "$RESTORE_MARKER"
  exit 0
fi

# ======================================================
# 🧰 FUNÇÃO DE EXECUÇÃO
# ======================================================
run_sync() {
  local mode="$1"

  if [[ -f "$EXCECOES" ]]; then
    export RCLONE_EXCLUDE_FILE="$EXCECOES"
    echo "🚫 Aplicando exclusões: $RCLONE_EXCLUDE_FILE"
  else
    unset RCLONE_EXCLUDE_FILE
    echo "ℹ️  Nenhum arquivo de exclusão encontrado."
  fi

  local SAFE_REMOTE_PATH="$BASE_REMOTE_FOLDER/$REMOTE_FOLDER"
  echo "⚙️  Caminho remoto final: $SAFE_REMOTE_PATH"

  local args=(
    --auto-create
    --clean-cache
    --verbose
    --local-folder "$LOCAL_FOLDER"
    --remote-name "$REMOTE_NAME"
    --remote-folder "$SAFE_REMOTE_PATH"
  )

  if [[ "$mode" == "dry" ]]; then
    args+=(--dry-run)
    echo "🔍 Modo: simulação (dry-run)"
  else
    echo "🚀 Modo: sincronização real"
  fi

  echo
  echo "📜 Comando completo:"
  echo "   $ROOT_PATH ${args[*]}"
  echo "======================================================"
  echo

  bash "$ROOT_PATH" "${args[@]}" 2>&1 | tee "$LOG_FILE"
  local rc=$?

  [[ -f "$RESTORE_MARKER" ]] && {
    echo "🛑 Restauração detectada — sincronização abortada."
    rm -f "$RESTORE_MARKER"
    exit 0
  }

  return $rc
}

# ======================================================
# 💡 ETAPA 1: SIMULAÇÃO (DRY-RUN)
# ======================================================
echo
echo "======================================================"
echo "🔍 Etapa 1: Simulação — nenhuma alteração será feita"
echo "======================================================"
run_sync "dry"
DRY_EXIT=$?

# ======================================================
# ⚙️ DECISÃO DE CONTINUIDADE
# ======================================================
if [[ $DRY_EXIT -ne 0 ]]; then
  echo "⚠️  Simulação retornou erro. Verifique o log: $LOG_FILE"
  if [[ "$AUTO_MODE" == "false" ]]; then
    read -p "Mesmo assim deseja continuar (s/n)? " CONF
    [[ "$CONF" =~ ^[sS]$ ]] || exit 1
  fi
else
  if [[ "$AUTO_MODE" == "false" ]]; then
    read -p "Deseja continuar com a sincronização real? (s/n): " CONF
    [[ "$CONF" =~ ^[sS]$ ]] || exit 0
  fi
fi

# ======================================================
# 🚀 ETAPA 2: EXECUÇÃO REAL
# ======================================================
echo
echo "======================================================"
echo "⚙️  Etapa 2: Sincronização real iniciada..."
echo "======================================================"
run_sync "real"
REAL_EXIT=$?

# ======================================================
# ✅ RESULTADO FINAL
# ======================================================
echo
if [[ $REAL_EXIT -eq 0 ]]; then
  echo "✅ Sincronização concluída com sucesso."
  echo "📄 Log: $LOG_FILE"
else
  echo "⚠️  Ocorreu um erro durante a sincronização."
  echo "📄 Consulte o log: $LOG_FILE"
  exit 1
fi

# =================== FIM DO SCRIPT: CopyToGDriver_CopyCurrent.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_Installer.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_Installer.sh
# Função: Instala o sistema CopyToGDriver e configura o Rclone
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.5.3 (corrigido cópia do script principal + aliases)
# ===========================================================

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
# =================== FIM DO SCRIPT: CopyToGDriver_Installer.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_Restore.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Restore.sh
# Função: Restaura o backup mais recente da pasta rclone.deleted
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.2.0 (restaura também conteúdo ativo quando não há backup)
# ===========================================================

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh" 2>/dev/null || true
source "$SCRIPT_DIR/CopyToGDriver_Config.sh" 2>/dev/null || true

# ===========================================================
# ⚙️ PARÂMETROS PADRÃO
# ===========================================================
REMOTE_NAME="gdriver"
BASE_REMOTE_FOLDER="rclone"
DELETED_BASE_FOLDER="rclone.deleted"
RESTORE_MODE="copy"   # copy = mantém o backup / move = remove após restaurar
DRY_RUN=false
TARGET_FOLDER=""
LOG_ROOT="$HOME/CopyToGDriver_Log"
LOG_DIR="$LOG_ROOT/system"
RESTORE_MARKER="$LOG_ROOT/.restore_aborted"
DISK_REGISTRY="$HOME/.config/CopyToGDriver/disks_registry.conf"

# ===========================================================
# 🧩 Função: show_help
# ===========================================================
show_help() {
    cat <<EOF
Uso:
  CopyToGDriver_Restore.sh [opções]

Se executado sem parâmetros, restaura automaticamente o backup da pasta atual.

Opções:
  --remote-folder <nome>     Pasta remota a restaurar (opcional)
  --restore-mode <copy|move> Restaurar copiando (padrão) ou movendo os arquivos
  --dry-run                  Simula a restauração sem alterar nada
  --verbose                  Exibe detalhes durante a execução
  --help                     Mostra esta ajuda

Observações:
  • Logs ficam em: $LOG_DIR
  • Após restaurar, o script cria o marcador:
        $RESTORE_MARKER
    para impedir sincronizações acidentais.
  • Detecta automaticamente o HD base e o caminho relativo conforme:
        $DISK_REGISTRY
EOF
    exit 0
}

# ===========================================================
# 🧠 Função: parse_parameters
# ===========================================================
parse_parameters() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --remote-folder) TARGET_FOLDER="$2"; shift 2 ;;
            --restore-mode) RESTORE_MODE="$2"; shift 2 ;;
            --dry-run) DRY_RUN=true; shift ;;
            --verbose) VERBOSE=true; shift ;;
            --help) show_help ;;
            *) echo "❌ Parâmetro desconhecido: $1"; exit 1 ;;
        esac
    done
}

# ===========================================================
# 💽 Função: Detectar o disco base e caminho relativo
# ===========================================================
get_disk_base_path() {
    local folder="$1"
    local registry="$DISK_REGISTRY"

    if [[ ! -f "$registry" ]]; then
        echo "⚠️  Registro de discos não encontrado: $registry"
        echo "/mnt"
        return
    fi

    local best_match=""
    local longest_match=0

    while IFS='=' read -r path _; do
        path=$(echo "$path" | xargs)
        [[ -z "$path" || "$path" == \[*\] ]] && continue
        if [[ "$folder" == "$path"* ]]; then
            local len=${#path}
            (( len > longest_match )) && longest_match=$len && best_match="$path"
        fi
    done < "$registry"

    [[ -z "$best_match" ]] && echo "/mnt" || echo "$best_match"
}

# ===========================================================
# 🚀 Função: restore_from_backup
# ===========================================================
restore_from_backup() {
    mkdir -p "$LOG_DIR"

    # Se nenhum alvo foi informado, usar caminho atual
    if [[ -z "$TARGET_FOLDER" ]]; then
        LOCAL_FOLDER="$(pwd)"
        DISK_BASE=$(get_disk_base_path "$LOCAL_FOLDER")
        RELATIVE_PATH="${LOCAL_FOLDER#${DISK_BASE}/}"
        TARGET_FOLDER="$RELATIVE_PATH"
        TARGET_FOLDER=$(echo "$TARGET_FOLDER" | sed 's|//*|/|g' | sed 's|^/||')
    fi

    # Caminho remoto de backup
    local backup_root="$REMOTE_NAME:$DELETED_BASE_FOLDER/$TARGET_FOLDER"
    local latest_date
    latest_date=$(rclone lsd "$backup_root" 2>/dev/null | awk '{print $5}' | sort -r | head -1)

    # ----------------------------------------------------------
    # 🧭 Se não há backup, tenta restaurar conteúdo ativo
    # ----------------------------------------------------------
    if [[ -z "$latest_date" ]]; then
        write_color_output "⚠️  Nenhum backup encontrado em $backup_root" "Yellow"
        write_color_output "🔍 Tentando restaurar conteúdo ativo em '$REMOTE_NAME:$BASE_REMOTE_FOLDER/$TARGET_FOLDER'..." "Cyan"

        if rclone lsd "$REMOTE_NAME:$BASE_REMOTE_FOLDER/$TARGET_FOLDER" >/dev/null 2>&1; then
            local timestamp=$(date +"%Y%m%d-%H%M%S")
            local log_file="$LOG_DIR/restore-$(basename "$TARGET_FOLDER")-$timestamp.log"
            write_color_output "📁 Pasta ativa encontrada — iniciando restauração..." "Blue"

            local rclone_copy_args=(
                copy
                "$REMOTE_NAME:$BASE_REMOTE_FOLDER/$TARGET_FOLDER"
                "$(pwd)"
                "--progress"
                "--create-empty-src-dirs"
                "--log-file" "$log_file"
            )
            [[ "$DRY_RUN" == "true" ]] && rclone_copy_args+=("--dry-run")
            [[ "$VERBOSE" == "true" ]] && rclone_copy_args+=("--verbose")

            rclone "${rclone_copy_args[@]}"
            local exit_code=$?

            if [[ $exit_code -eq 0 ]]; then
                write_color_output "✅ Restauração concluída com sucesso a partir da pasta ativa!" "Green"
                echo "📜 Log salvo em: $log_file"
                exit 0
            else
                write_color_output "❌ Erro ao restaurar da pasta ativa (código $exit_code)." "Red"
                echo "📜 Log salvo em: $log_file"
                exit 1
            fi
        else
            write_color_output "❌ Nenhum backup nem pasta ativa encontrada para '$TARGET_FOLDER'." "Red"
            write_color_output "🛑 Restauração cancelada para evitar sobrescrita." "Red"
            exit 1
        fi
    fi

    # ----------------------------------------------------------
    # 📦 Se há backup, restaura normalmente
    # ----------------------------------------------------------
    write_color_output "📅 Backup mais recente encontrado: $latest_date" "Blue"

    local source_path="$backup_root/$latest_date"
    local destination_path="$(pwd)"
    local timestamp=$(date +"%Y%m%d-%H%M%S")
    local log_file="$LOG_DIR/restore-$(basename "$TARGET_FOLDER")-$timestamp.log"

    echo "------------------------------------------------------"
    echo "🔄 Restauração de Backup (Google Drive → Local)"
    echo "------------------------------------------------------"
    echo "☁️  Origem (remoto): $source_path"
    echo "📂 Destino local.. : $destination_path"
    echo "🗂️  Modo.......... : $RESTORE_MODE"
    echo "📜 Log............ : $log_file"
    echo "------------------------------------------------------"
    echo ""

    local rclone_args=(
        copy
        "$source_path"
        "$destination_path"
        "--create-empty-src-dirs"
        "--log-file" "$log_file"
        "--stats" "30s"
        "--stats-file-name-length" "0"
    )

    [[ "$DRY_RUN" == "true" ]] && rclone_args+=("--dry-run")
    [[ "$VERBOSE" == "true" ]] && rclone_args+=("--verbose")

    write_color_output "🚀 Restaurando arquivos de backup..." "Cyan"
    echo "rclone ${rclone_args[*]}"
    echo ""

    rclone "${rclone_args[@]}"
    local exit_code=$?

    echo ""
    if [[ $exit_code -eq 0 ]]; then
        write_color_output "✅ Restauração concluída com sucesso!" "Green"
        mkdir -p "$(dirname "$RESTORE_MARKER")"
        echo "restore_abort $(date)" > "$RESTORE_MARKER"
        echo "📜 Log salvo em: $log_file"
        write_color_output "🛑 Sincronizações futuras foram bloqueadas temporariamente." "Yellow"
        write_color_output "👉 Revise os arquivos antes de sincronizar novamente." "Cyan"
        exit 11
    else
        write_color_output "❌ Erro durante a restauração (código $exit_code)" "Red"
        echo "📜 Log salvo em: $log_file"
        exit 1
    fi
}

# ===========================================================
# ▶️ Execução principal
# ===========================================================
main() {
    parse_parameters "$@"
    restore_from_backup
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Restore.sh
# ===========================================================

# =================== FIM DO SCRIPT: CopyToGDriver_Restore.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_Setup.sh ===================

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

# =================== FIM DO SCRIPT: CopyToGDriver_Setup.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver.sh
# Função: Script principal que orquestra todos os módulos
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.0.0.24 (suporte à flag --check-only)
# ===========================================================

SCRIPT_DIR="$(dirname "$0")"

# ===========================================================
# 🔍 VERIFICAÇÃO DE DEPENDÊNCIAS
# ===========================================================
verify_dependencies() {
    local missing_modules=()
    local required_modules=("Utils" "Config" "ConfigFunctions" "Checks" "Cache" "Sync" "Setup")
    
    echo "======================================================"
    echo "🔍 Verificando módulos do CopyToGDriver..."
    echo "======================================================"
    
    for module in "${required_modules[@]}"; do
        local module_file="$SCRIPT_DIR/CopyToGDriver_${module}.sh"
        if [[ ! -f "$module_file" ]]; then
            missing_modules+=("$module_file")
            echo "❌ Módulo faltante: $(basename "$module_file")"
        else
            echo "✅ $(basename "$module_file") encontrado."
        fi
    done
    
    if [[ ${#missing_modules[@]} -gt 0 ]]; then
        echo ""
        echo "🚫 ERRO: Módulos essenciais faltando!"
        echo "💡 Solução: Execute o instalador ou verifique se todos os scripts estão no diretório:"
        echo "   $SCRIPT_DIR"
        echo ""
        exit 1
    fi
    
    echo ""
    echo "✅ Todas as dependências verificadas com sucesso!"
    echo "======================================================"
    echo ""
}

# ===========================================================
# ▶️ OPÇÃO --check-only (verificação sem execução)
# ===========================================================
if [[ "$1" == "--check-only" ]]; then
    verify_dependencies
    echo "✅ Verificação concluída. Nenhuma ação de sincronização executada."
    echo "======================================================"
    exit 0
fi

# ===========================================================
# 🔗 IMPORTAR MÓDULOS COM VERIFICAÇÃO
# ===========================================================
verify_dependencies

source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"
source "$SCRIPT_DIR/CopyToGDriver_ConfigFunctions.sh"
source "$SCRIPT_DIR/CopyToGDriver_Checks.sh"
source "$SCRIPT_DIR/CopyToGDriver_Cache.sh"
source "$SCRIPT_DIR/CopyToGDriver_Setup.sh"
source "$SCRIPT_DIR/CopyToGDriver_Sync.sh"

# ===========================================================
# ▶️ EXECUÇÃO PRINCIPAL
# ===========================================================
if declare -f main >/dev/null; then
    main "$@"
else
    echo "❌ ERRO: Função 'main' não encontrada. Verifique se CopyToGDriver_Sync.sh foi carregado."
    exit 1
fi

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Main.sh
# ===========================================================

# =================== FIM DO SCRIPT: CopyToGDriver.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_Sync.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Sync.sh
# Função: Sincroniza pasta local → Google Drive (via rclone)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5 Thinking)
# Versão: 0.0.0.34
#
# Esta versão:
#   ✅ Centraliza logs em ~/CopyToGDriver_Log/
#   ✅ Corrige de vez o erro: destination and parameter to --backup-dir mustn't overlap
#   ✅ Normaliza caminho remoto vindo do copydrive (que às vezes já vem com rclone/)
#   ✅ Cria backup SEMPRE em gdriver:rclone.deleted/<caminho_limpo>/<AAAA-MM-DD>
#   ✅ Mostra barra de progresso (--progress + --stats 15s --stats-one-line)
#   ✅ Respeita --quiet (sem barra)
#   ✅ Gera resumo em ~/CopyToGDriver_Log/system/summary.log
# ===========================================================

# -----------------------------------------------------------
# 🔗 Importar dependências
# -----------------------------------------------------------
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"
source "$SCRIPT_DIR/CopyToGDriver_ConfigFunctions.sh"
source "$SCRIPT_DIR/CopyToGDriver_Checks.sh"
source "$SCRIPT_DIR/CopyToGDriver_Cache.sh"
source "$SCRIPT_DIR/CopyToGDriver_Setup.sh"

# -----------------------------------------------------------
# 🔧 Defaults de pastas remotas
# -----------------------------------------------------------
BASE_REMOTE_FOLDER="${BASE_REMOTE_FOLDER:-rclone}"          # conteúdo ativo
DELETED_BASE_FOLDER="${DELETED_BASE_FOLDER:-rclone.deleted}" # lixeira/backup

# ===========================================================
# 🧩 Função: show_configuration
# ===========================================================
show_configuration() {
    write_color_output "[CONFIGURAÇÃO ATUAL]" "Cyan"
    echo "  Pasta Local:          $LOCAL_FOLDER"
    echo "  Remote:               $REMOTE_NAME"
    echo "  Pasta Base Remota:    $BASE_REMOTE_FOLDER"
    echo "  Pasta Remota pedida:  '$REMOTE_FOLDER'"
    echo "  Pasta Base de Backup: $DELETED_BASE_FOLDER"
    echo "  Logs (locais):        ~/CopyToGDriver_Log/"
    echo
    echo "  Retenção Logs:        $LOG_RETENTION_DAYS dias"
    echo "  Compactar após:       $ZIP_AFTER_DAYS dias"
    echo ""

    [[ "$DRY_RUN" == "true" ]]     && write_color_output "  MODO: SIMULAÇÃO" "Yellow"
    [[ "$RESYNC" == "true" ]]      && write_color_output "  MODO: RESSINCRONIZAÇÃO" "Yellow"
    [[ "$VERBOSE" == "true" ]]     && write_color_output "  MODO: VERBOSO" "Yellow"
    [[ "$AUTO_CREATE" == "true" ]] && write_color_output "  MODO: AUTO-CRIAR" "Yellow"
    [[ "$CLEAN_CACHE" == "true" ]] && write_color_output "  MODO: LIMPEZA-CACHE" "Yellow"
    [[ "$QUIET" == "true" ]]       && write_color_output "  MODO: QUIET (sem progress)" "Yellow"
    echo ""
}

# ===========================================================
# 🧠 Função utilitária: normalizar caminho remoto
#
# Entradas possíveis que vêm do copydrive:
#   - "blog"
#   - "rclone/blog"
#   - "rclone/paulo/docs"
#   - "/rclone/paulo/docs"
# Saída esperada:
#   - TARGET_REMOTE_PATH → SEMPRE algo como:   rclone/paulo/docs
#   - CLEAN_REMOTE_PATH  → SEMPRE sem o 'rclone/': paulo/docs
# ===========================================================
normalize_remote_paths() {
    local incoming="$1"

    # tira aspas
    incoming="${incoming%\"}"; incoming="${incoming#\"}"
    incoming="${incoming%\'}"; incoming="${incoming#\'}"

    # tira começo com /
    incoming="${incoming#/}"

    local target_remote=""   # onde vamos sincronizar
    local clean_remote=""    # usado para montar o backup

    if [[ "$incoming" == "$BASE_REMOTE_FOLDER"* ]]; then
        # já veio com rclone/...
        target_remote="$incoming"
        clean_remote="${incoming#${BASE_REMOTE_FOLDER}/}"
    else
        # veio só "blog" → vira rclone/blog
        target_remote="${BASE_REMOTE_FOLDER}/${incoming}"
        clean_remote="$incoming"
    fi

    # se por acaso ficar vazio (caso remoto tenha sido só "rclone")
    if [[ -z "$clean_remote" ]]; then
        clean_remote="$(basename "$LOCAL_FOLDER")"
    fi

    NORMALIZED_TARGET_REMOTE_PATH="$target_remote"
    NORMALIZED_CLEAN_REMOTE_PATH="$clean_remote"
}

# ===========================================================
# 🚀 Função: sync_folders
# ===========================================================
sync_folders() {
    write_color_output "[INICIANDO SINCRONIZAÇÃO]" "Magenta"

    [[ "$CLEAN_CACHE" == "true" ]] && cleanup_rclone_cache && echo ""

    # --- Validações padrão ---
    [[ -z "$LOCAL_FOLDER" ]] && exit_with_error "LOCAL_FOLDER não definido."
    [[ ! -d "$LOCAL_FOLDER" ]] && exit_with_error "Pasta local não existe: $LOCAL_FOLDER"
    ! command -v rclone &>/dev/null && exit_with_error "rclone não encontrado."

    # 1) normalizar caminhos remotos com base no REMOTE_FOLDER pedido
    normalize_remote_paths "$REMOTE_FOLDER"
    local TARGET_REMOTE_PATH="$NORMALIZED_TARGET_REMOTE_PATH"     # ex: rclone/paulo/docs
    local CLEAN_REMOTE_PATH="$NORMALIZED_CLEAN_REMOTE_PATH"       # ex: paulo/docs
    local TODAY
    TODAY=$(date +"%Y-%m-%d")

    # 2) montar caminho de backup FORA da árvore ativa
    #    FICA ASSIM: rclone.deleted/paulo/docs/2025-11-01
    local DELETED_REMOTE_FOLDER_PATH="${DELETED_BASE_FOLDER}/${CLEAN_REMOTE_PATH}/${TODAY}"

    # 3) garantir que bases existam
    for folder in "$BASE_REMOTE_FOLDER" "$DELETED_BASE_FOLDER"; do
        if ! rclone lsd "$REMOTE_NAME:$folder" &>/dev/null; then
            write_color_output "🆕 Criando pasta base remota: $REMOTE_NAME:$folder ..." "Blue"
            rclone mkdir "$REMOTE_NAME:$folder" &>/dev/null \
                || exit_with_error "Falha ao criar pasta remota base: $folder"
        fi
    done

    # 4) garantir que destino ativo existe
    write_color_output "🔍 Verificando pasta remota: $REMOTE_NAME:$TARGET_REMOTE_PATH" "Cyan"
    if ! rclone lsd "$REMOTE_NAME:$TARGET_REMOTE_PATH" --max-depth 1 &>/dev/null; then
        write_color_output "⚠️  Pasta remota não existe, criando..." "Yellow"
        rclone mkdir "$REMOTE_NAME:$TARGET_REMOTE_PATH" &>/dev/null \
            || exit_with_error "Falha ao criar pasta remota de destino: $TARGET_REMOTE_PATH"
    fi

    # 5) garantir que pasta de backup do dia existe
    #    OBS: criamos TAMBÉM o diretório pai para facilitar navegação no Drive
    write_color_output "🔍 Garantindo pasta de backup: $REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH" "Cyan"
    rclone mkdir "$REMOTE_NAME:$DELETED_BASE_FOLDER/$CLEAN_REMOTE_PATH" &>/dev/null || true
    rclone mkdir "$REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH" &>/dev/null || true

    # ----------------------------------------------------------
    # 🧾 Logs centralizados
    # ----------------------------------------------------------
    local BASENAME_FOLDER
    BASENAME_FOLDER="$(basename "$LOCAL_FOLDER")"
    local LOG_DIR="$HOME/CopyToGDriver_Log/${BASENAME_FOLDER}"
    local SYSTEM_LOG_DIR="$HOME/CopyToGDriver_Log/system"
    ensure_directory "$LOG_DIR"
    ensure_directory "$SYSTEM_LOG_DIR"

    local timestamp
    timestamp=$(date +"%Y%m%d-%H%M%S")
    local log_file="$LOG_DIR/sync-$timestamp.log"
    local summary_file="$SYSTEM_LOG_DIR/summary.log"

    echo "------------------------------------------------------"
    echo "📂 Local .............: $LOCAL_FOLDER"
    echo "☁️  Destino remoto ...: $REMOTE_NAME:$TARGET_REMOTE_PATH"
    echo "🗑️  Backup remoto ....: $REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH"
    echo "📜 Log desta execução : $log_file"
    echo "📘 Resumo geral ......: $summary_file"
    echo "------------------------------------------------------"
    echo ""

    # ----------------------------------------------------------
    # 🚫 Exclusões
    # ----------------------------------------------------------
    if [[ -n "$RCLONE_EXCLUDE_FILE" && -f "$RCLONE_EXCLUDE_FILE" ]]; then
        write_color_output "🚫 Aplicando exclusões: $RCLONE_EXCLUDE_FILE" "Yellow"
        EXCLUDE_FROM_ARGS=(--exclude-from "$RCLONE_EXCLUDE_FILE")
    else
        EXCLUDE_FROM_ARGS=()
    fi

    # ----------------------------------------------------------
    # ⚙️ Montar parâmetros do rclone
    # ----------------------------------------------------------
    local rclone_args=(
        "sync"
        "$LOCAL_FOLDER"
        "$REMOTE_NAME:$TARGET_REMOTE_PATH"
        "--backup-dir" "$REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH"
        "--fast-list"
        "--transfers" "4"
        "--checkers" "8"
        "--delete-after"
        "--log-file" "$log_file"
        "--stats-file-name-length" "0"
    )

    # → stats / progress
    if [[ "$QUIET" == "true" ]]; then
        rclone_args+=("--quiet")
    else
        # barra de progresso e linha única
        rclone_args+=("--progress" "--stats" "15s" "--stats-one-line")
    fi

    # → verbosidade
    if [[ "$VERBOSE" == "true" ]]; then
        rclone_args+=("--verbose")
    else
        rclone_args+=("--log-level" "INFO")
    fi

    # → simulação
    if [[ "$DRY_RUN" == "true" ]]; then
        rclone_args+=("--dry-run")
        write_color_output "🔍 MODO SIMULAÇÃO ATIVADO — nada será enviado ao Drive." "Yellow"
    fi

    # → resync forçado
    if [[ "$RESYNC" == "true" ]]; then
        rclone_args+=("--resync")
        write_color_output "🔄 RESSINCRONIZAÇÃO COMPLETA ATIVADA" "Yellow"
    fi

    # ----------------------------------------------------------
    # ▶️ Executar
    # ----------------------------------------------------------
    local start_epoch
    start_epoch=$(date +%s)

    write_color_output "🚀 Executando sincronização (rclone)..." "Cyan"
    write_color_output "Comando completo:" "Blue"
    echo "rclone ${rclone_args[*]} ${EXCLUDE_FROM_ARGS[*]}"
    echo

    local exit_code=0
    rclone "${rclone_args[@]}" "${EXCLUDE_FROM_ARGS[@]}" || exit_code=$?

    local end_epoch
    end_epoch=$(date +%s)
    local duration=$(( end_epoch - start_epoch ))
    local duration_str="$((duration/60))m $((duration%60))s"

    # ----------------------------------------------------------
    # ✅ Resultado + resumo
    # ----------------------------------------------------------
    if [[ $exit_code -eq 0 ]]; then
        write_color_output "✅ Sincronização concluída com sucesso!" "Green"
    else
        write_color_output "❌ Erro durante sincronização!" "Red"
        write_color_output "⚠️ Código de saída: $exit_code" "Red"
        # se for 7, lembrar motivo
        [[ $exit_code -eq 7 ]] && write_color_output "💡 Dica: código 7 costuma ser caminho de backup que se sobrepôs ao destino. Esta versão já evita isso. Se continuar, veja o log completo." "Yellow"
    fi

    write_color_output "⏱️  Tempo total: $duration_str" "Blue"
    write_color_output "📜 Log salvo em: $log_file" "Cyan"

    # grava pequeno resumo
    {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] local='$LOCAL_FOLDER' remote='$REMOTE_NAME:$TARGET_REMOTE_PATH' backup='$REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH' exit=$exit_code time=$duration_str log='$log_file'"
    } >> "$summary_file"

    # ----------------------------------------------------------
    # 🧹 Limpeza automática de logs
    # ----------------------------------------------------------
    write_color_output "🧹 Limpando logs antigos..." "Cyan"
    find "$LOG_DIR" -type f -name "sync-*.log" -mtime "+$ZIP_AFTER_DAYS" -exec gzip {} \; 2>/dev/null
    find "$LOG_DIR" -type f -name "sync-*.log*" -mtime "+$LOG_RETENTION_DAYS" -delete 2>/dev/null

    write_color_output "🗂️  Itens removidos foram movidos para: $REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH" "Blue"
    write_color_output "✅ Nenhum arquivo foi excluído definitivamente." "Green"

    return $exit_code
}

# ===========================================================
# 🧩 Função principal
# ===========================================================
main() {
    # esta função vem do ConfigFunctions
    parse_parameters "$@"

    [[ "$SHOW_HELP" == "true" ]] && show_help && exit 0

    show_configuration

    if check_prerequisites; then
        sync_folders
    else
        exit_with_error "Pré-requisitos não atendidos."
    fi
}

# -----------------------------------------------------------
# ▶️ Execução direta
# -----------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
# =================== FIM DO SCRIPT: CopyToGDriver_Sync.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_UnInstaller.sh ===================

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
# =================== FIM DO SCRIPT: CopyToGDriver_UnInstaller.sh ===================


# =================== INÍCIO DO SCRIPT: CopyToGDriver_Utils.sh ===================

#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Utils.sh
# Função: Fornece funções utilitárias compartilhadas entre módulos
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21 (baseada em Sync-Folder-Rclone)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém funções auxiliares de uso geral, como:
#   • Saída colorida no terminal
#   • Função genérica de log com timestamp
#   • Tratamento de mensagens de erro e sucesso padronizadas
#
# Todos os demais módulos devem importar este script com:
#   👉 source "$(dirname "$0")/CopyToGDriver_Utils.sh"
# ===========================================================


# ===========================================================
# 🎨 Função: write_color_output
# ===========================================================
# Exibe mensagens coloridas no terminal para facilitar a leitura.
# Uso:
#   write_color_output "mensagem" "Cor"
# Cores disponíveis: Red, Green, Yellow, Blue, Magenta, Cyan
# ===========================================================
write_color_output() {
    local message="$1"
    local color="$2"
    
    case $color in
        "Red") echo -e "\033[31m$message\033[0m" ;;
        "Green") echo -e "\033[32m$message\033[0m" ;;
        "Yellow") echo -e "\033[33m$message\033[0m" ;;
        "Blue") echo -e "\033[34m$message\033[0m" ;;
        "Magenta") echo -e "\033[35m$message\033[0m" ;;
        "Cyan") echo -e "\033[36m$message\033[0m" ;;
        *) echo "$message" ;;
    esac
}


# ===========================================================
# 🧾 Função: log_message
# ===========================================================
# Grava mensagens com timestamp no log especificado.
# Uso:
#   log_message "/caminho/arquivo.log" "mensagem"
# ===========================================================
log_message() {
    local logfile="$1"
    shift
    local message="$*"

    if [[ -z "$logfile" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') [LOG] $message"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') [LOG] $message" >> "$logfile"
    fi
}


# ===========================================================
# ⚠️ Função: exit_with_error
# ===========================================================
# Encerra o script exibindo mensagem de erro colorida e opcionalmente registrando em log.
# Uso:
#   exit_with_error "mensagem de erro" [arquivo.log]
# ===========================================================
exit_with_error() {
    local message="$1"
    local logfile="$2"

    write_color_output "❌ ERRO: $message" "Red"

    if [[ -n "$logfile" ]]; then
        log_message "$logfile" "ERRO: $message"
    fi

    exit 1
}


# ===========================================================
# ✅ Função: success_message
# ===========================================================
# Exibe uma mensagem de sucesso padronizada e registra no log, se fornecido.
# Uso:
#   success_message "mensagem de sucesso" [arquivo.log]
# ===========================================================
success_message() {
    local message="$1"
    local logfile="$2"

    write_color_output "✅ $message" "Green"

    if [[ -n "$logfile" ]]; then
        log_message "$logfile" "SUCESSO: $message"
    fi
}


# ===========================================================
# 🧩 Placeholder para futuras utilidades
# ===========================================================
# Exemplos futuros:
#   - validate_command "rclone"
#   - bytes_to_human 12345678
#   - ensure_directory_exists "/pasta/alvo"
# ===========================================================


# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Utils.sh
# ===========================================================
# =================== FIM DO SCRIPT: CopyToGDriver_Utils.sh ===================


# =================== INÍCIO DO SCRIPT: junte_Scripts.sh ===================

#!/bin/bash

# Script: merge_scripts.sh
# Descrição: Concatena todos os arquivos *.sh na pasta corrente em um único arquivo chamado 'scripts.sh'.
#            Adiciona separadores entre os scripts para facilitar a leitura e análise.
#            Ignora o próprio 'merge_scripts.sh' e o 'scripts.sh' gerado para evitar loops.
# Uso: Salve este código como 'merge_scripts.sh', torne executável com 'chmod +x merge_scripts.sh'
#      e rode './merge_scripts.sh' na pasta com os scripts originais.
# Nota: Faça backup da pasta antes, se necessário. O arquivo 'scripts.sh' será sobrescrito.

set -e  # Para em caso de erro

# Arquivo de saída
OUTPUT_FILE="scripts.sh"

# Limpa o arquivo de saída se existir
> "$OUTPUT_FILE"

# Cabeçalho geral
echo "#!/bin/bash" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "# Arquivo Unificado: Todos os scripts *.sh da pasta corrente" >> "$OUTPUT_FILE"
echo "# Gerado em: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "# Original: Concatenação de $(ls *.sh | grep -v -E '^(merge_scripts.sh|scripts.sh)$' | wc -l) scripts" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Lista de arquivos a ignorar
IGNORE_FILES="merge_scripts.sh|scripts.sh"

# Concatena cada script com separador
for script in *.sh; do
    if [[ ! "$script" =~ $IGNORE_FILES ]]; then
        echo "" >> "$OUTPUT_FILE"
        echo "# =================== INÍCIO DO SCRIPT: $script ===================" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        cat "$script" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "# =================== FIM DO SCRIPT: $script ===================" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    fi
done

# Torna o arquivo unificado executável
chmod +x "$OUTPUT_FILE"

echo "Concluído! Arquivo 'scripts.sh' criado com $(ls *.sh | grep -v -E '^(merge_scripts.sh|scripts.sh)$' | wc -l) scripts concatenados."
echo "Agora, você pode encaminhar o 'scripts.sh' para avaliação das dependências."
echo "Para testar: ./scripts.sh (mas revise primeiro, pois é uma concatenação direta)."
# =================== FIM DO SCRIPT: junte_Scripts.sh ===================


# =================== INÍCIO DO SCRIPT: Remove_Rclone.sh ===================

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


# =================== FIM DO SCRIPT: Remove_Rclone.sh ===================

