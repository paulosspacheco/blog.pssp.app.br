#!/bin/bash
# ======================================================
# Script: borg_restore_pasta_corrente.sh
# Objetivo: Restaurar backups da pasta corrente feitos com BorgBackup
# Autor: PauloSSPacheco (modelo robusto e automático)
# ======================================================

# ======================
# Configurações
# ======================
SCRIPT_BASE="/home/paulosspacheco/scripts/borg_restore.sh"   # Caminho do script base de restauração
DESTINO_BASE="/media/paulosspacheco/Novo volume/borg_backup"  # Caminho base onde ficam os repositórios Borg
CRIPTO="none"                                                 # Tipo de criptografia (default)

# Pasta corrente e nome
ORIGEM="$(pwd)"
NOME="$(basename "$ORIGEM")"

# Repositório correspondente
REPO="$DESTINO_BASE/$NOME/borg-repo"

# Pasta de destino (onde será restaurado)
DESTINO_RESTAURACAO="$ORIGEM/restaurado"

# ======================
# Exibição inicial
# ======================
echo "======================================================"
echo "♻️  Restauração da pasta corrente com BorgBackup"
echo "======================================================"
echo "Nome ...........: $NOME"
echo "Repositório ....: $REPO"
echo "Destino final ..: $DESTINO_RESTAURACAO"
echo "Script base ....: $SCRIPT_BASE"
echo "Criptografia ...: $CRIPTO"
echo "======================================================"
echo

# ======================
# Validações iniciais
# ======================

# Verifica se o script base existe e é executável
if [ ! -x "$SCRIPT_BASE" ]; then
    echo "❌ O script base '$SCRIPT_BASE' não foi encontrado ou não tem permissão de execução."
    exit 1
fi

# Verifica se o repositório existe
if [ ! -d "$REPO" ]; then
    echo "❌ O repositório '$REPO' não foi encontrado!"
    echo "Verifique se o backup da pasta '$NOME' foi realmente criado."
    exit 1
fi

# Cria a pasta de restauração se não existir
mkdir -p "$DESTINO_RESTAURACAO"

# ======================
# Confirmação
# ======================
echo
read -p "Deseja restaurar a pasta '$NOME' para '$DESTINO_RESTAURACAO'? (s/n): " CONFIRMA
if [[ "$CONFIRMA" != "s" && "$CONFIRMA" != "S" ]]; then
  echo "❌ Operação cancelada pelo usuário."
  exit 0
fi

# ======================
# Execução da restauração
# ======================
echo
echo "======================================================"
echo "🚀 Iniciando restauração com borg_restore.sh ..."
echo "======================================================"
"$SCRIPT_BASE" "$REPO" "$DESTINO_RESTAURACAO" "" "$CRIPTO"

# ======================
# Resultado final
# ======================
if [ $? -eq 0 ]; then
    echo
    echo "✅ Restauração da pasta '$NOME' concluída com sucesso!"
    echo "Arquivos restaurados em: $DESTINO_RESTAURACAO"
else
    echo
    echo "❌ Ocorreu um erro durante a restauração."
    exit 1
fi
