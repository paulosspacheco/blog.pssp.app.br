#!/bin/bash
# Script: copyto.sh
# Descrição: Cria cópia fiel e sincronizada do diretório origem no destino
# Versão: v0.0.05
# Autor: PauloSSPacheco@yahoo.com.br
# Uso: ./copyto.sh /PastaDestino /arquivos_de_excessao.txt

# Função de ajuda
show_help() {
    cat << EOF
📚 copyto.sh - Script de Cópia Fiel e Sincronização

📖 DESCRIÇÃO:
    Cria uma cópia fiel e sincronizada do diretório atual para o destino,
    preservando todos os atributos dos arquivos e diretórios.

⚙️  USO:
    ./copyto.sh [OPÇÕES] <destino> [arquivo_excecoes]

📋 PARÂMETROS:
    <destino>          Diretório de destino para a cópia (OBRIGATÓRIO)
    [arquivo_excecoes] Arquivo com lista de padrões/paths a excluir (OPCIONAL)

🎯 OPÇÕES:
    -h, --help         Mostra esta mensagem de ajuda
    -y, --yes          Executa sem confirmação interativa
    -v, --version      Mostra a versão do script
    -l, --log <arquivo> Habilita logging detalhado no arquivo especificado

🔧 FUNCIONALIDADES:
    • Cópia fiel mantendo todos os atributos originais
    • Sincronização bidirecional (--delete)
    • Preserva: permissões, timestamps, proprietário, links, ACLs, etc.
    • Exclusões personalizadas via arquivo
    • Validações de segurança para evitar sobrescritas críticas
    • Sistema de logging de erros e operações

📝 EXEMPLOS:
    ./copyto.sh /backup/projeto
    ./copyto.sh /backup/projeto exclusoes.txt
    ./copyto.sh --yes /backup/projeto exclusoes.txt
    ./copyto.sh --log /var/log/copyto.log /backup/projeto
    ./copyto.sh --help

🔒 SEGURANÇA:
    • Bloqueia execução a partir de / ou \$HOME
    • Impede destino ser / ou \$HOME
    • Requer confirmação interativa (a menos que use -y)

EOF
    exit 0
}

# Função de versão
show_version() {
    echo "copyto.sh - Versão v0.0.05"
    echo "Autor: PauloSSPacheco@yahoo.com.br"
    exit 0
}

# Função de logging
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [ -n "$LOG_FILE" ]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    fi
    echo "[$timestamp] [$level] $message"
}

# Função para registrar erros do rsync
setup_rsync_logging() {
    if [ -n "$LOG_FILE" ]; then
        # Cria arquivo de log específico para rsync
        RSYNC_LOG="${LOG_FILE}.rsync"
        log_message "INFO" "Log detalhado do rsync: $RSYNC_LOG"
    fi
}

# Variáveis padrão
confirmacao_interativa=true
LOG_FILE=""
RSYNC_LOG=""

# Processamento de opções
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            show_version
            ;;
        -y|--yes)
            confirmacao_interativa=false
            shift
            ;;
        -l|--log)
            if [ -z "$2" ] || [[ "$2" == -* ]]; then
                echo "❌ Erro: Opção --log requer um arquivo de log"
                exit 1
            fi
            LOG_FILE="$2"
            # Cria diretório do log se não existir
            mkdir -p "$(dirname "$LOG_FILE")"
            shift 2
            ;;
        -*)
            echo "❌ Opção desconhecida: $1"
            echo "💡 Use --help para ver as opções disponíveis"
            exit 1
            ;;
        *)
            # Primeiro argumento não-option é o destino
            if [ -z "$destino" ]; then
                destino="$1"
            # Segundo argumento não-option é o arquivo de exceções
            elif [ -z "$except" ]; then
                except="$1"
            else
                echo "❌ Argumentos em excesso: $1"
                echo "💡 Use --help para ver o uso correto"
                exit 1
            fi
            shift
            ;;
    esac
done

echo "Script: copyto.sh - Cópia Fiel"
log_message "INFO" "Iniciando script copyto.sh"

origem="./"

# 🔒 SEGURANÇA: Abortando se caminho for arriscado
if [[ "$PWD" == "/" || "$PWD" == "$HOME" ]]; then
    error_msg="ERRO: Tentativa de execução a partir de diretório crítico: $PWD"
    log_message "ERRO" "$error_msg"
    echo "❌ $error_msg"
    echo "💡 Mude para um subdiretório específico antes de executar"
    exit 1
fi

if [ -z "$destino" ]; then
    error_msg="ERRO: Destino não informado"
    log_message "ERRO" "$error_msg"
    echo "❌ $error_msg"
    echo "💡 Uso: $0 [OPÇÕES] <pasta_destino> [arquivo_excecoes]"
    echo "💡 Use $0 --help para mais informações"
    exit 1
fi

if [ "$destino" == "/" ] || [ "$destino" == "$HOME" ]; then
    error_msg="ERRO GRAVE: Tentativa de usar destino crítico: $destino"
    log_message "ERRO" "$error_msg"
    echo "❌ $error_msg"
    echo "💡 Especifique um subdiretório específico como destino"
    exit 1
fi

if [ -n "$except" ] && [ ! -f "$except" ]; then
    warning_msg="Arquivo de exceções não encontrado: $except. Continuando sem exclusões."
    log_message "WARN" "$warning_msg"
    echo "⚠️  $warning_msg"
    except=""
fi

# Configura logging do rsync
setup_rsync_logging

echo
log_message "INFO" "Resumo da operação: Origem=$PWD, Destino=$destino, Exceções=${except:-nenhuma}"
echo "🔍 RESUMO DA OPERAÇÃO:"
echo "Origem............: $PWD"
echo "Destino...........: $destino"
echo "Exceções..........: ${except:-nenhuma}"
echo "Log..............: ${LOG_FILE:-não}"
echo "Modo..............: Cópia Fiel (espelhamento completo)"
echo

# 🔄 Opções do rsync para cópia fiel:
rsync_opts="-arlptgoDHAX --progress --delete"
[ -n "$except" ] && rsync_opts="$rsync_opts --exclude-from=$except"

# Adiciona logging do rsync se habilitado
if [ -n "$RSYNC_LOG" ]; then
    rsync_opts="$rsync_opts --log-file=$RSYNC_LOG"
fi

echo "📋 Comando a ser executado:"
echo "sudo rsync $rsync_opts ./ \"$destino\""
log_message "INFO" "Comando: sudo rsync $rsync_opts ./ \"$destino\""

# Confirmação manual (a menos que --yes seja usado)
if [ "$confirmacao_interativa" = true ]; then
    read -p "❓ Deseja realmente espelhar a origem acima para o destino? (s/N): " confirm
    if [[ "$confirm" != "s" && "$confirm" != "S" ]]; then
        log_message "INFO" "Operação cancelada pelo usuário"
        echo "⏹️  Operação cancelada."
        exit 0
    fi
else
    log_message "INFO" "Modo não-interativo ativado, executando automaticamente"
    echo "⚡ Modo não-interativo ativado (-y), executando automaticamente..."
fi

echo
log_message "INFO" "Iniciando cópia fiel..."
echo "🔄 Iniciando cópia fiel..."

# Executa rsync e captura stdout, stderr e código de retorno
if [ -n "$RSYNC_LOG" ]; then
    sudo rsync $rsync_opts ./ "$destino" 2>&1
else
    sudo rsync $rsync_opts ./ "$destino" 2>&1 | tee -a "$LOG_FILE"
fi

result_cp="$?"

# Verificação do resultado
if [ $result_cp -eq 0 ]; then
    success_msg="Cópia fiel concluída com sucesso! Código: $result_cp"
    log_message "SUCCESS" "$success_msg"
    echo "✅ $success_msg"
    echo "📊 O destino agora é um espelho exato da origem"
    
    # Log de estatísticas se disponível
    if [ -n "$RSYNC_LOG" ] && [ -f "$RSYNC_LOG" ]; then
        echo "📁 Log detalhado salvo em: $RSYNC_LOG"
        log_message "INFO" "Log do rsync disponível em: $RSYNC_LOG"
    fi
else
    error_msg="ERRO na cópia. Código de saída: $result_cp"
    log_message "ERROR" "$error_msg"
    echo "❌ $error_msg"
    echo "💡 Verifique as permissões e espaço em disco"
    
    # Log detalhado do erro
    if [ -n "$RSYNC_LOG" ] && [ -f "$RSYNC_LOG" ]; then
        echo "📁 Log de erro detalhado em: $RSYNC_LOG"
        log_message "ERROR" "Consulte $RSYNC_LOG para detalhes dos erros"
        
        # Extrai apenas os erros do log do rsync
        echo "🔍 Últimos erros encontrados:"
        grep -i "error\|fail\|warning\|permission denied" "$RSYNC_LOG" | tail -10
    fi
    
    exit 1
fi
