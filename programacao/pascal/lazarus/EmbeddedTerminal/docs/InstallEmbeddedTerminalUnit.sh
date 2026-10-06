#!/bin/bash


# INSTALA AS DEPENDÊNCIAS DA UNIT embeddedterminalunit.pas


# Atualizar lista de pacotes
echo "Atualizando lista de pacotes..."
sudo apt-get update

# Instalar dependências básicas
echo "Instalando dependências básicas..."
sudo apt-get install -y bash libc6 libutil-dev

# Instalar o compilador Free Pascal e Lazarus (caso ainda não estejam instalados)
echo "Instalando Free Pascal e Lazarus... Obs: Não precisa pq você ja deve ter instalado"
#sudo apt-get install -y fpc lazarus

# Verificar se os shells padrão estão disponíveis
if ! command -v /bin/bash &> /dev/null; then
    echo "Erro: /bin/bash não encontrado. Abortando."
    exit 1
fi

if ! command -v /bin/sh &> /dev/null; then
    echo "Erro: /bin/sh não encontrado. Abortando."
    exit 1
fi

# Criar diretório para o histórico de comandos (opcional)
echo "Criando diretório para o histórico de comandos..."
sudo mkdir -p /var/lib/embedded-terminal
sudo chmod 755 /var/lib/embedded-terminal

# Criar arquivo de histórico inicial (opcional)
HISTORY_FILE="/var/lib/embedded-terminal/command_history.json"
if [ ! -f "$HISTORY_FILE" ]; then
    echo "[]" | sudo tee "$HISTORY_FILE" > /dev/null
    sudo chmod 644 "$HISTORY_FILE"
fi

# Mensagem de conclusão
echo "Dependências instaladas com sucesso!"