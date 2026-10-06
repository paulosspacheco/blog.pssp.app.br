#!/bin/bash

# =============================================================================
# push.sh
#
# Atualiza o GitHub criando o controle de versão.
#
# O que faz, em uma única execução:
#   1. Regenera o mapa de busca do site (create_tipuesearch).
#   2. Faz o commit de todas as alterações.
#   3. Sincroniza com o remoto (pull --rebase).
#   4. Cria uma nova tag incremental, por exemplo v0.207.3-Alpha.
#   5. Envia o commit e a tag para o GitHub.
#
# Uso:
#   ./push.sh "Texto descrevendo as mudanças"
#
# Requisitos:
#   - git instalado e configurado
#   - chave SSH cadastrada no GitHub (o remoto usa git@github.com:...)
#   - comando create_tipuesearch disponível no PATH
#   - execução dentro do diretório do repositório
#
# Códigos de saída:
#   0 - sucesso, ou nenhuma alteração a commitar
#   1 - texto do commit não informado, fora de um repositório git,
#       ou create_tipuesearch não encontrado
#   Qualquer outro erro do git interrompe o script (set -e).
# =============================================================================

# Interrompe o script em qualquer erro, variável não definida ou falha em pipe
set -euo pipefail

# Texto com as mudanças que estão sendo realizadas neste push
TextoCommit="${1:-}"

# Verifica se o texto do commit foi passado como argumento
# (feito antes de qualquer outra ação para não gerar arquivos à toa)
if [ -z "$TextoCommit" ]; then
    echo "Parâmetro deve ser texto diferente de nulo" >&2
    exit 1
fi

# Tipo de versão (pode ser alterado para "Beta", "Release", etc.)
VERSION_TYPE="Alpha"

# Nome do repositório GitHub (formato: usuario/repositorio)
REPO_NAME="paulosspacheco/blog.pssp.app.br"

# Versão inicial, usada quando ainda não existe nenhuma tag no padrão.
# O prefixo "0.207" daqui define a série das tags; para avançar o minor,
# altere para v0.208.0-$VERSION_TYPE
INITIAL_VERSION="v0.207.0-$VERSION_TYPE"

# Verifica se está dentro de um repositório git
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Execute este script dentro de um repositório git" >&2
    exit 1
fi

# Verifica se o comando que cria o mapa do site está disponível
if ! command -v create_tipuesearch >/dev/null 2>&1; then
    echo "Comando create_tipuesearch não encontrado" >&2
    exit 1
fi

# Verifica se o repositório remoto já está associado
if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin "git@github.com:$REPO_NAME.git"
fi

# Garante que estamos na branch main
git checkout main

# Cria o mapa do site (índice de busca do blog)
create_tipuesearch

# Verifica se há mudanças a serem commitadas.
# git status --porcelain também enxerga arquivos novos ainda não rastreados.
if [ -z "$(git status --porcelain)" ]; then
    echo "Nenhuma alteração a ser commitada"
    exit 0
fi

# Adiciona todas as mudanças ao commit
git add -A

# Cria o commit com a mensagem passada
git commit -m "$TextoCommit"

# Atualiza o repositório local com os dados do remoto, reaplicando o commit
# por cima. Se houver conflito, o script para; resolva, execute
# "git rebase --continue" e rode o script de novo.
git pull --rebase origin main

# Baixa as tags do remoto para não repetir uma versão já publicada
git fetch --tags origin

# Extrai a versão principal e secundária do INITIAL_VERSION (ex: "0.207")
MAIN_VERSION_PREFIX=$(echo "$INITIAL_VERSION" | sed -E 's/^v([0-9]+\.[0-9]+)\..*/\1/')

# Versão do prefixo com os pontos escapados para uso na expressão regular
PREFIX_REGEX="${MAIN_VERSION_PREFIX//./\\.}"

# Tenta obter a última tag que segue o padrão v0.207.X-Alpha
LAST_TAG=$(git tag --sort=-v:refname | grep -E "^v${PREFIX_REGEX}\.[0-9]+-${VERSION_TYPE}$" | head -n 1 || true)

# Se não houver uma última tag no formato esperado, usa a INITIAL_VERSION
if [ -z "$LAST_TAG" ]; then
    NEW_TAG="$INITIAL_VERSION"
else
    # Extrai o número do patch da última tag (ex: v0.207.9-Alpha -> 9)
    PATCH="${LAST_TAG#"v${MAIN_VERSION_PREFIX}."}"
    PATCH="${PATCH%-*}"

    # Incrementa o patch; 10# evita que números com zero à esquerda
    # sejam interpretados como octal
    NEW_TAG="v${MAIN_VERSION_PREFIX}.$((10#$PATCH + 1))-${VERSION_TYPE}"
fi

# Exibe as informações sobre o que será feito
echo "Criando a versão: $NEW_TAG"
echo "Mensagem do commit: $TextoCommit"

# Cria a nova tag anotada, guardando a mensagem do commit
git tag -a "$NEW_TAG" -m "$TextoCommit"

# Envia o commit e a nova tag para o repositório remoto
git push origin main "$NEW_TAG"

# Imprime o status atual do repositório
git status

# Mensagem de sucesso
echo "Versão $NEW_TAG publicada com sucesso no repositório $REPO_NAME."