# 📘 Documentação do Script includes/crossplatform/alias_manager.sh

## 🧩 Visão Geral

O script **includes/crossplatform/alias_manager.sh** faz parte do projeto **CopyToGDriver** e tem como objetivo **instalar aliases globais** no shell do usuário para simplificar o uso diário das ferramentas de sincronização.  
Ele cria comandos curtos como `copydrive` e `copycheck`, tornando o uso do sistema mais prático e intuitivo.

---

## ⚙️ Funcionalidade Principal

O script detecta automaticamente o sistema operacional e adiciona aliases aos arquivos de inicialização do shell, como `~/.bashrc`, `~/.bash_profile` ou `~/.zshrc`, conforme disponíveis.  
Esses aliases permitem executar as principais funções do CopyToGDriver com comandos simples.

---

## 🔧 Variáveis e Caminhos

| Variável | Descrição | Valor Padrão |
|-----------|------------|---------------|
| `PLATFORM` | Plataforma atual detectada. | Detectada via `uname -s` |
| `BASE_DIR` | Diretório base onde o CopyToGDriver está instalado. | `/c/scripts/CopyToGDriver` (Windows) / `$HOME/scripts/CopyToGDriver` (Linux/macOS) |
| `ALIAS_LINE_DRIVE` | Linha do alias principal para sincronização. | `alias copydrive='bash "$BASE_DIR/CopyToGDriver_CopyCurrent.sh"'` |
| `ALIAS_LINE_CHECK` | Linha do alias de verificação. | `alias copycheck='bash "$BASE_DIR/CopyToGDriver.sh" --check-only'` |

---

## 🧠 Funções Internas

### `detect_platform()`
Detecta o sistema operacional atual.  
Retorna um dos seguintes valores:

- `linux`
- `macos`
- `windows`
- `unknown`

Exemplo:
```bash
PLATFORM=$(detect_platform)
echo "Rodando em: $PLATFORM"
```

---

### `add_alias(alias_line, rc_file)`
Adiciona um alias a um arquivo de inicialização do shell, se ele ainda não existir.

- **Parâmetros:**
  - `alias_line`: linha de alias a ser adicionada.
  - `rc_file`: caminho do arquivo (`~/.bashrc`, `~/.bash_profile`, `~/.zshrc`).

Exemplo:
```bash
add_alias "alias copydrive='bash ~/scripts/CopyToGDriver/CopyToGDriver_CopyCurrent.sh'" ~/.bashrc
```

---

### `install_aliases()`
Função principal do script.  
Executa os seguintes passos:

1. Detecta o sistema operacional.  
2. Determina os arquivos de inicialização disponíveis (`.bashrc`, `.bash_profile`, `.zshrc`).  
3. Adiciona os aliases `copydrive` e `copycheck` em cada arquivo existente.  
4. Exibe instruções de pós-instalação.  

---

## 🧰 Aliases Criados

| Alias | Função | Comando Executado |
|--------|---------|------------------|
| `copydrive` | Sincroniza a pasta atual com o Google Drive. | `bash "$BASE_DIR/CopyToGDriver_CopyCurrent.sh"` |
| `copycheck` | Executa verificação de dependências e ambiente. | `bash "$BASE_DIR/CopyToGDriver.sh" --check-only` |

Após a instalação, basta digitar os comandos abaixo em qualquer terminal:

```bash
copydrive   # Sincroniza a pasta corrente
copycheck   # Verifica o ambiente e dependências
```

---

## 💻 Compatibilidade

| Sistema | Suporte | Observação |
|----------|----------|------------|
| **Linux** | ✅ Total | Adiciona aliases em `~/.bashrc` |
| **macOS** | ✅ Total | Adiciona aliases em `~/.bash_profile` |
| **Windows (Git Bash / WSL)** | ✅ Total | Adiciona aliases em `~/.bashrc` |
| **Outros** | ⚠️ Parcial | Pode exigir configuração manual |

---

## 🧾 Estrutura de Execução

```
includes/crossplatform/alias_manager.sh
 ├── detect_platform()     # Identifica o sistema operacional
 ├── add_alias()           # Adiciona linha ao rc file
 ├── install_aliases()     # Executa instalação dos aliases
 └── Execução direta       # Chama install_aliases() ao rodar o script
```

---

## 🧠 Exemplo de Saída

Ao executar o script, você verá algo como:

```
======================================================
🔗 Instalando aliases globais do CopyToGDriver
======================================================
🔗 Alias adicionado em: /home/usuario/.bashrc
✅ Alias já existe em: /home/usuario/.zshrc

✅ Aliases adicionados com sucesso!
📦 Comandos disponíveis:
   • copydrive → sincroniza a pasta atual
   • copycheck → verifica o ambiente CopyToGDriver

💡 Dica: execute 'source ~/.bashrc' ou reinicie o terminal.
```

---

## 🧰 Exemplo de Uso

```bash
# Executar instalação dos aliases
bash includes/crossplatform/alias_manager.sh

# Recarregar shell atual (necessário após instalação)
source ~/.bashrc

# Usar os comandos
copydrive    # Inicia sincronização
copycheck    # Verifica módulos
```

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | includes/crossplatform/alias_manager.sh |
| **Versão** | 1.1.0 |
| **Autores** | Paulo SSPacheco + ChatGPT (GPT-5) |
| **Data** | 01/11/2025 |
| **Licença** | Uso pessoal / interno |

---

© 2025 Paulo SSPacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
