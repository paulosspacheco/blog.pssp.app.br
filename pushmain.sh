#!/bin/bash

# Texto com as mudanças que estão sendo realizadas neste push.
TextoCommit="$1"

# Verifica se o texto do commit foi passado como argumento
if [ -z "$TextoCommit" ]; then
   echo "Parâmetro deve ser texto diferente de nulo"
   exit 1
fi

# Verifica se o repositório remoto já está associado
if ! git remote | grep -q origin; then
    git remote add origin git@github.com:paulosspacheco/blog.pssp.app.br.git
fi

# Verifica se o branch atual é 'main' e renomeia se necessário
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    git branch -M main
fi

# Atualiza o repositório local com os dados do repositório remoto
git pull

# Adiciona todas as alterações ao commit
git add .

# Verifica se há mudanças a serem commitadas
if git diff-index --quiet HEAD --; then
    echo "Nenhuma alteração a ser commitada"
    exit 0
fi

# Cria o commit com a mensagem passada
git commit -m "$TextoCommit"

# Envia as alterações para o repositório remoto
git push -u origin main

# Imprime o status atual do repositório
git status
