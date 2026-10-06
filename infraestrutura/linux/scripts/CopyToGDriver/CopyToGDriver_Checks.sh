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
