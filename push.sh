#!/bin/bash

# Atualiza o GitHub criando o controle de versão.

# Função para criar o mapa do site
create_tipuesearch

# Texto com as mudanças que estão sendo realizadas neste push
TextoCommit="$1"

# Verifica se o texto do commit foi passado como argumento
if [ -z "$TextoCommit" ]; then
   echo "Parâmetro deve ser texto diferente de nulo"
   exit 1
fi

# Tipo de versão (pode ser alterado para "beta", "release", etc.)
VERSION_TYPE="Alpha"

# Nome do repositório GitHub (formato: usuario/repositorio)
REPO_NAME="paulosspacheco/blog.pssp.app.br"

# Verifica se o repositório remoto já está associado
if ! git remote | grep -q origin; then
    git remote add origin git@github.com:$REPO_NAME.git
fi

# Garante que estamos na branch main
git checkout main

# Atualiza o repositório local com os dados do repositório remoto
git pull origin main

# Verifica se há mudanças a serem commitadas
if git diff-index --quiet HEAD --; then
    echo "Nenhuma alteração a ser commitada"
    exit 0
fi

# Define a versão inicial como desejado
INITIAL_VERSION="v0.207.0-$VERSION_TYPE"

# Extrai a versão principal e secundária do INITIAL_VERSION (ex: "0.207")
MAIN_VERSION_PREFIX=$(echo "$INITIAL_VERSION" | sed -E 's/^v([0-9]+\.[0-9]+)\..*/\1/')

# Tenta obter a última tag que segue o padrão v0.207.X-Alpha
LAST_TAG=$(git tag --sort=-v:refname | grep -E "^v${MAIN_VERSION_PREFIX}\.[0-9]+-$VERSION_TYPE$" | head -n 1)

# Se não houver uma última tag no formato esperado, usa a INITIAL_VERSION como ponto de partida
if [ -z "$LAST_TAG" ]; then
    NEW_TAG="$INITIAL_VERSION"
else
    # Extrai os componentes da versão a partir da última tag encontrada
    IFS='.' read -ra PARTS <<< "${LAST_TAG//v/}"
    MAJOR=${PARTS[0]}
    MINOR=${PARTS[1]}
    PATCH=${PARTS[2]%-*}  # Remove o sufixo (ex: -Alpha)

    # Incrementa o patch mantendo o padrão de formatação
    PATCH=$((PATCH + 1))

    # Nova tag com o incremento
    NEW_TAG="v${MAJOR}.${MINOR}.${PATCH}-$VERSION_TYPE"
fi

# Verifica se a nova tag já existe
if git rev-parse "$NEW_TAG" >/dev/null 2>&1; then
    echo "A tag $NEW_TAG já existe. Nada a ser feito."
    exit 0
fi

# Exibe as informações sobre o que será feito
echo "Criando a versão: $NEW_TAG"
echo "Mensagem do commit: $TextoCommit"

# Adiciona todas as mudanças ao commit
git add .

# Cria o commit com a mensagem passada
git commit -m "$TextoCommit"

# Cria a nova tag
git tag "$NEW_TAG"

# Envia as alterações e a nova tag para o repositório remoto
git push origin main
git push origin "$NEW_TAG"

# Imprime o status atual do repositório
git status

# Mensagem de sucesso
echo "Versão $NEW_TAG publicada com sucesso no repositório $REPO_NAME."
