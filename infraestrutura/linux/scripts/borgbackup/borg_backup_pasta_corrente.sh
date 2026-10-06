#!/bin/bash
# ======================================================
# Script: borg_backup_pasta_corrente.sh
# Objetivo: Fazer backup incremental da pasta corrente
#           para /media/paulosspacheco/Novo volume/borg_backup
#           utilizando o script borg_backup.sh
# Autor: PauloSSPacheco
# ======================================================

# ======================
# Configuração
# ======================
SCRIPT_BASE="/home/paulosspacheco/scripts/borg_backup.sh"   # Caminho do script principal de backup
DESTINO="/media/paulosspacheco/Novo volume/borg_backup"      # Destino dos backups
MONTAGEM="$(dirname "$DESTINO")"                             # Ponto de montagem real
ORIGEM="$(pwd)"                                              # Pasta atual
NOME="$(basename "$ORIGEM")"                                 # Nome do backup = nome da pasta corrente
CRIPTO="none"                                                # Tipo de criptografia (padrão: none)

# ======================
# Exibição inicial
# ======================
echo "======================================================"
echo "💾 Backup da pasta corrente com BorgBackup"
echo "======================================================"
echo "Nome ...........: $NOME"
echo "Origem .........: $ORIGEM"
echo "Destino ........: $DESTINO"
echo "Ponto de montagem: $MONTAGEM"
echo "Script base ....: $SCRIPT_BASE"
echo "Criptografia ...: $CRIPTO"
echo "======================================================"
echo

# ======================
# Validações iniciais
# ======================

# Verifica se o script base existe
if [ ! -x "$SCRIPT_BASE" ]; then
    echo "❌ O script base '$SCRIPT_BASE' não foi encontrado ou não tem permissão de execução."
    exit 1
fi

# Verifica se o ponto de montagem do destino está ativo
if ! mountpoint -q "$MONTAGEM"; then
    echo "⚠️  O destino '$MONTAGEM' não está montado!"
    echo "Conecte e monte o disco antes de continuar."
    exit 1
fi

# Cria a pasta de destino se não existir
if [ ! -d "$DESTINO" ]; then
    echo "📁 Criando diretório de destino: $DESTINO"
    mkdir -p "$DESTINO"
    if [ $? -ne 0 ]; then
        echo "❌ Falha ao criar o diretório de destino."
        exit 1
    fi
fi

# ======================
# Confirmação
# ======================
echo
read -p "Deseja iniciar o backup da pasta corrente '$ORIGEM'? (s/n): " CONFIRMA
if [[ "$CONFIRMA" != "s" && "$CONFIRMA" != "S" ]]; then
  echo "❌ Operação cancelada pelo usuário."
  exit 0
fi

# ======================
# Execução do backup
# ======================
echo
echo "======================================================"
echo "🚀 Iniciando backup com borg_backup.sh ..."
echo "======================================================"
"$SCRIPT_BASE" "$NOME" "$ORIGEM" "$DESTINO" "$CRIPTO"

# ======================
# Resultado final
# ======================
if [ $? -eq 0 ]; then
    echo
    echo "✅ Backup da pasta '$ORIGEM' concluído com sucesso!"
    echo "Arquivos armazenados em: $DESTINO"
else
    echo
    echo "❌ Ocorreu um erro durante o backup."
    exit 1
fi

