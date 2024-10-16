#!/bin/bash

# Criando o indice
create_tipuesearch

# Nome do repositório GitHub (formato: usuario/repositorio)
REPO_NAME="usuario/repositorio"

# Solicita a mensagem de commit do usuário
read -p "Digite a mensagem do commit: " COMMIT_MSG

# Se a mensagem estiver vazia, use uma mensagem padrão
if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Nova versão publicada automaticamente"
fi

# Incrementa a versão com base na tag anterior
LAST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
if [ -z "$LAST_TAG" ]; then
    NEW_TAG="v0.1.0"
else
    # Extrai os componentes da versão
    IFS='.' read -ra PARTS <<< "${LAST_TAG//v/}"
    MAJOR=${PARTS[0]}
    MINOR=${PARTS[1]}
    PATCH=${PARTS[2]}

    # Incrementa o patch
    PATCH=$((PATCH + 1))

    # Nova tag
    NEW_TAG="v${MAJOR}.${MINOR}.${PATCH}"
fi

# Exibe as informações sobre o que será feito
echo "Criando a versão: $NEW_TAG"
echo "Mensagem do commit: $COMMIT_MSG"

# Adiciona todas as mudanças
git add .

# Faz o commit
git commit -m "$COMMIT_MSG"

# Cria a nova tag
git tag "$NEW_TAG"

# Push das mudanças e da nova tag
git push origin main
git push origin "$NEW_TAG"

# Mensagem de sucesso
echo "Versão $NEW_TAG publicada com sucesso no repositório $REPO_NAME."
