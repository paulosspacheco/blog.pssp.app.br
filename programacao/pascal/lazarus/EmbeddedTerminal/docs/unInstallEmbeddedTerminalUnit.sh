#!/bin/bash

# REMOVE AS DEPENDÊNCIAS DA UNIT embeddedterminalunit.pas

# Mensagem inicial
echo "Iniciando a remoção das dependências..."

# Remover o diretório de histórico de comandos
HISTORY_DIR="/var/lib/embedded-terminal"
if [ -d "$HISTORY_DIR" ]; then
    echo "Removendo diretório de histórico de comandos: $HISTORY_DIR"
    sudo rm -rf "$HISTORY_DIR"
else
    echo "Diretório de histórico de comandos não encontrado. Ignorando..."
fi

# Remover pacotes instalados (bash, libc6, libutil-dev, fpc, lazarus)
echo "Removendo pacotes instalados..."
sudo apt-get remove -y bash libc6 libutil-dev #fpc lazarus

# Limpar pacotes desnecessários (dependências que não são mais usadas)
echo "Limpando pacotes desnecessários..."
sudo apt-get autoremove -y

# Atualizar lista de pacotes
echo "Atualizando lista de pacotes..."
sudo apt-get update

# Mensagem de conclusão
echo "Desinstalação concluída. Todas as dependências foram removidas."