#!/bin/bash
# ===========================================================
# crossplatform_utils.sh - Turbo Utilities for Cross-Platform Projects
# Versão: 2.0.0 | Compatível: Linux, macOS, Windows (Git Bash/WSL)
# ===========================================================
#
# 🚀 DESCRIÇÃO TURBO:
# Biblioteca definitiva para projetos multiplataforma. Oferece funções
# para auto-correção de CRLF, detecção de SO, normalização de caminhos
# e validação de ambiente. Garante que seus scripts funcionem em
# qualquer sistema operacional!
#
# ⚡ FUNÇÕES TURBO:
# • Auto-detecção e correção de CRLF
# • Normalização inteligente de caminhos
# • Validação de dependências cross-platform
# • Logging colorido e informativo
# • Backup automático de arquivos
#
# 🎯 COMO USAR:
# source ./crossplatform_utils.sh
# auto_fix_current_script "$@"  # ← ADICIONE ESTA LINHA no topo dos seus scripts
#
# ===========================================================

# Cores para output turbo
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configurações turbo
TURBO_BACKUP=true
TURBO_VERBOSE=true

# ===========================================================
# 🧠 FUNÇÕES CORE TURBO
# ===========================================================

# 🔧 detect_os_type - Detecção avançada de SO
detect_os_type() {
    local os_name
    os_name=$(uname -s)
    
    case "$os_name" in
        Darwin*)
            echo "macOS"
            ;;
        Linux*)
            # Detecta se está no WSL
            if [[ -n "$WSL_DISTRO_NAME" ]] || grep -q -i microsoft /proc/version 2>/dev/null; then
                echo "WSL"
            else
                echo "Linux"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "Windows"
            ;;
        *BSD*)
            echo "BSD"
            ;;
        *)
            echo "Unknown"
            ;;
    esac
}

# 🔧 turbo_log - Logging colorido turbo
turbo_log() {
    local level="$1"
    local message="$2"
    local color="$NC"
    
    case "$level" in
        "ERROR") color="$RED" ;;
        "SUCCESS") color="$GREEN" ;;
        "WARNING") color="$YELLOW" ;;
        "INFO") color="$BLUE" ;;
        "DEBUG") color="$PURPLE" ;;
        "TURBO") color="$CYAN" ;;
    esac
    
    if [[ "$TURBO_VERBOSE" == true || "$level" != "DEBUG" ]]; then
        echo -e "${color}[$(date '+%H:%M:%S')] $level: $message${NC}" >&2
    fi
}

# 🔧 normalize_path - Normalização inteligente de caminhos
normalize_path() {
    local path="$1"
    local os_type
    os_type=$(detect_os_type)
    
    # Remove aspas se existirem
    path=$(echo "$path" | sed "s/^['\"]//; s/['\"]$//")
    
    case "$os_type" in
        "Windows")
            # Converte C:\path para /c/path para Git Bash/WSL
            if [[ "$path" =~ ^[A-Za-z]:\\ ]]; then
                path=$(echo "$path" | sed 's/\\/\//g' | sed 's/^\([A-Za-z]\):/\/\1/')
            fi
            # Converte C:/path para /c/path
            path=$(echo "$path" | sed 's/^\([A-Za-z]\):/\/\1/')
            ;;
        "WSL")
            # Converte caminhos Windows para WSL
            if [[ "$path" =~ ^[A-Za-z]:\\ ]]; then
                path=$(wslpath -u "$path" 2>/dev/null || echo "$path")
            fi
            ;;
    esac
    
    # Remove trailing slash e retorna
    echo "${path%/}"
}

# ===========================================================
# 🛡️ FUNÇÕES DE PROTEÇÃO CRLF TURBO
# ===========================================================

# 🔧 check_and_fix_crlf - Verificação e correção turbo de CRLF
check_and_fix_crlf() {
    local script_path="$1"
    local os_type
    os_type=$(detect_os_type)
    
    # Só executa em sistemas Unix-like
    if [[ "$os_type" =~ (Linux|macOS|BSD|WSL) ]]; then
        
        if [[ ! -f "$script_path" ]]; then
            turbo_log "ERROR" "Arquivo não encontrado: $script_path"
            return 1
        fi
        
        # Métodos turbo de detecção
        local has_crlf=false
        local detection_method=""
        
        # Método 1: file command (mais preciso)
        if command -v file >/dev/null 2>&1; then
            if file "$script_path" | grep -q "CRLF"; then
                has_crlf=true
                detection_method="file command"
            fi
        fi
        
        # Método 2: grep por \r (fallback)
        if [[ "$has_crlf" == false ]] && grep -q $'\r' "$script_path"; then
            has_crlf=true
            detection_method="grep"
        fi
        
        # Método 3: hexdump (ultra preciso)
        if [[ "$has_crlf" == false ]] && command -v hexdump >/dev/null 2>&1; then
            if hexdump -C "$script_path" | head -10 | grep -q "0d 0a"; then
                has_crlf=true
                detection_method="hexdump"
            fi
        fi
        
        if [[ "$has_crlf" == true ]]; then
            turbo_log "WARNING" "CRLF detectado ($detection_method) em: $(basename "$script_path")"
            
            # Backup turbo
            if [[ "$TURBO_BACKUP" == true ]]; then
                local backup_file="${script_path}.crlf.bak"
                cp "$script_path" "$backup_file"
                turbo_log "INFO" "Backup criado: $(basename "$backup_file")"
            fi
            
            # Correção turbo
            if sed -i 's/\r$//' "$script_path"; then
                # Restaura permissões
                [[ -x "${script_path}.bak" ]] && chmod +x "$script_path"
                
                turbo_log "SUCCESS" "Conversão LF concluída: $(basename "$script_path")"
                return 2  # Código especial: arquivo foi corrigido
            else
                turbo_log "ERROR" "Falha na conversão: $(basename "$script_path")"
                return 1
            fi
        else
            turbo_log "DEBUG" "OK - Sem CRLF: $(basename "$script_path")"
            return 0
        fi
    else
        turbo_log "DEBUG" "Windows native - Skip CRLF check"
        return 0
    fi
}

# 🔧 auto_fix_current_script - Auto-correção turbo do script atual
auto_fix_current_script() {
    local current_script="$0"
    local os_type
    os_type=$(detect_os_type)
    
    turbo_log "TURBO" "Iniciando verificação cross-platform..."
    turbo_log "DEBUG" "Sistema detectado: $os_type"
    turbo_log "DEBUG" "Script: $(basename "$current_script")"
    
    # Verifica e corrige se necessário
    check_and_fix_crlf "$current_script"
    local fix_result=$?
    
    # Se foi corrigido, reexecuta com o script corrigido
    if [[ $fix_result -eq 2 ]]; then
        turbo_log "SUCCESS" "Script corrigido! Reexecutando..."
        exec /bin/bash "$current_script" "$@"
        exit $?
    elif [[ $fix_result -eq 0 ]]; then
        turbo_log "SUCCESS" "Script verificado - pronto para execução!"
    fi
    
    return $fix_result
}

# 🔧 fix_project_scripts - Correção em lote turbo
fix_project_scripts() {
    local project_dir="${1:-.}"
    local fixed_count=0
    local total_count=0
    
    turbo_log "INFO" "Verificação em lote iniciada: $project_dir"
    
    find "$project_dir" -name "*.sh" -type f | while read script; do
        total_count=$((total_count + 1))
        if check_and_fix_crlf "$script"; then
            fixed_count=$((fixed_count + 1))
        fi
    done
    
    turbo_log "SUCCESS" "Concluído! Verificados: $total_count | Corrigidos: $fixed_count"
    return $fixed_count
}

# ===========================================================
# 🔍 FUNÇÕES DE VALIDAÇÃO TURBO
# ===========================================================

# 🔧 validate_dependencies - Valida dependências cross-platform
validate_dependencies() {
    local deps=("$@")
    local missing_deps=()
    local os_type
    os_type=$(detect_os_type)
    
    turbo_log "INFO" "Validando dependências para: $os_type"
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing_deps+=("$dep")
            turbo_log "WARNING" "Dependência não encontrada: $dep"
        else
            turbo_log "DEBUG" "✅ $dep"
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        turbo_log "ERROR" "Dependências faltando: ${missing_deps[*]}"
        
        # Sugestões específicas por SO
        case "$os_type" in
            "Linux")
                turbo_log "INFO" "No Debian/Ubuntu tente: sudo apt install ${missing_deps[*]}"
                ;;
            "macOS")
                turbo_log "INFO" "No macOS tente: brew install ${missing_deps[*]}"
                ;;
            "Windows")
                turbo_log "INFO" "No Windows instale via: chocolatey install ${missing_deps[*]}"
                ;;
        esac
        
        return 1
    else
        turbo_log "SUCCESS" "Todas dependências disponíveis!"
        return 0
    fi
}

# 🔧 get_script_directory - Diretório do script (cross-platform)
get_script_directory() {
    local source_dir
    local os_type
    os_type=$(detect_os_type)
    
    if [[ "$os_type" == "Windows" ]]; then
        source_dir=$(cd "$(dirname "$0")" && pwd -W 2>/dev/null || pwd)
    else
        source_dir=$(cd "$(dirname "$0")" && pwd)
    fi
    
    echo "$source_dir"
}

# ===========================================================
# 🎯 EXEMPLOS DE USO E DEMONSTRAÇÃO
# ===========================================================

# 🔧 demo_crossplatform - Demonstração das capacidades turbo
demo_crossplatform() {
    turbo_log "TURBO" "🚀 INICIANDO DEMONSTRAÇÃO CROSS-PLATFORM"
    
    local os_type
    os_type=$(detect_os_type)
    
    echo ""
    echo "=== DEMONSTRAÇÃO TURBO UTILITIES ==="
    echo "📋 Sistema detectado: $os_type"
    echo "📋 Diretório script: $(get_script_directory)"
    echo "📋 Shell: $SHELL"
    echo ""
    
    # Teste de normalização de caminhos
    echo "=== TESTE NORMALIZAÇÃO DE CAMINHOS ==="
    local test_paths=("/home/user" "C:\\Users\\Documentos" "C:/Windows/System32")
    
    for path in "${test_paths[@]}"; do
        local normalized
        normalized=$(normalize_path "$path")
        echo "🔧 $path → $normalized"
    done
    echo ""
    
    # Valida dependências comuns
    echo "=== VALIDAÇÃO DE DEPENDÊNCIAS ==="
    local common_deps=("bash" "sed" "grep" "find")
    validate_dependencies "${common_deps[@]}"
    
    echo ""
    turbo_log "SUCCESS" "Demonstração concluída!"
}

# 🔧 show_usage - Mostra uso da biblioteca
show_usage() {
    echo ""
    echo "🎯 CROSSPLATFORM UTILS - USO TURBO"
    echo "==========================================="
    echo ""
    echo "📚 COMO INCLUIR NO SEU SCRIPT:"
    echo "   source ./crossplatform_utils.sh"
    echo "   auto_fix_current_script \"\$@\"  # ← PRIMEIRA LINHA APÓS shebang"
    echo ""
    echo "⚡ FUNÇÕES DISPONÍVEIS:"
    echo "   auto_fix_current_script    - Auto-correção do script atual"
    echo "   check_and_fix_crlf [arquivo] - Verifica/corrige CRLF"
    echo "   fix_project_scripts [dir]  - Correção em lote"
    echo "   detect_os_type            - Detecta SO precisamente"
    echo "   normalize_path [caminho]   - Normaliza caminhos"
    echo "   validate_dependencies [...] - Valida dependências"
    echo "   get_script_directory       - Diretório do script"
    echo ""
    echo "🎪 EXEMPLO PRÁTICO:"
    echo "   #!/bin/bash"
    echo "   source ./crossplatform_utils.sh"
    echo "   auto_fix_current_script \"\$@\""
    echo "   "
    echo "   # Seu código aqui - garantido sem problemas de CRLF!"
    echo "   echo \"Script turbo funcionando!\""
    echo ""
}

# ===========================================================
# 🚀 INICIALIZAÇÃO E DEMONSTRAÇÃO AUTOMÁTICA
# ===========================================================

# Se executado diretamente, mostra demonstração
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo ""
    echo "🔧 CROSSPLATFORM UTILS - MODO DEMONSTRAÇÃO"
    echo "==========================================="
    
    show_usage
    echo ""
    
    # Peça confirmação para demo interativa
    read -rp "🎪 Executar demonstração interativa? (s/N): " choice
    if [[ "$choice" == [sS] ]]; then
        demo_crossplatform
    else
        turbo_log "INFO" "Use 'source $(basename "$0")' para incluir no seu script"
        turbo_log "INFO" "Chame 'demo_crossplatform' para ver exemplos práticos"
    fi
fi

# ===========================================================
# 💡 DICAS TURBO PARA DESENVOLVIMENTO MULTIPLATAFORMA
# ===========================================================
#
# 🚀 MELHORES PRÁTICAS:
# 1. Sempre use #!/bin/bash (não #!/bin/sh)
# 2. Use 'source' em vez de '.' para melhor compatibilidade
# 3. Teste caminhos com espaços e caracteres especiais
# 4. Use [[ ]] em vez de [ ] para condicionais
# 5. Sempre normalize caminhos de entrada
#
# 🐛 PROBLEMAS COMUNS:
# • CRLF no Linux → use auto_fix_current_script
# • Caminhos Windows → use normalize_path
# • Permissões de execução → chmod +x seus scripts
# • Encoding → use UTF-8 sem BOM
#
# 🔧 COMANDOS ÚTEIS:
# • file meuscript.sh → verifica encoding
# • dos2unix → conversão manual (se disponível)
# • hexdump -C → análise hexadecimal
#
# ===========================================================
# 🎉 SEU PROJETO AGORA É TURBO MULTIPLATAFORMA!
# ===========================================================