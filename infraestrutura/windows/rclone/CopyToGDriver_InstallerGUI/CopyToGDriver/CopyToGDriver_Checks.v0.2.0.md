# 📘 Documentação do Script CopyToGDriver_Checks.sh

## 🧩 Visão Geral

O módulo **CopyToGDriver_Checks.sh** faz parte do projeto **CopyToGDriver** e é responsável por **validar o ambiente e os pré-requisitos** antes de qualquer operação de sincronização com o Google Drive (via rclone).  

Ele verifica:

- Instalação e versão do **rclone**
- **Conectividade com a internet**
- **Pasta local** usada na sincronização
- **Remote** configurado no rclone
- **Espaço livre em disco**
- Se o diretório alvo não está em um **local sensível/perigoso**

---

## ⚙️ Dependências e Módulos Carregados

Logo no início, o script:

1. Descobre o diretório onde está localizado (`SCRIPT_DIR`).
2. Carrega o `include_loader.sh` e executa `load_all_modules`.
3. Importa módulos principais:
   - `CopyToGDriver_Utils.sh`
   - `CopyToGDriver_Config.sh`

Esses módulos fornecem funções auxiliares como `write_color_output`, `resolve_path`, `file_count`, `get_disk_usage_gb` e `get_disk_space_gb`, além de variáveis de configuração como `LOCAL_FOLDER` e `REMOTE_NAME`.

---

## 🌍 Detecção de Plataforma

### `detect_platform()`

Detecta o sistema operacional atual, retornando um dos valores:

- `linux`
- `macos`
- `windows`
- `unknown`

O resultado é armazenado em `PLATFORM` e utilizado para ajustar caminhos, mensagens e comandos sugeridos.

---

## 🔧 Funções de Verificação

### 1. `check_rclone_installed()`

Verifica se o **rclone** está instalado e disponível no `PATH`.

- Se **não** estiver instalado:
  - Exibe mensagem de erro.
  - Sugere comandos de instalação conforme a plataforma:
    - Linux → `sudo apt install rclone`
    - macOS → `brew install rclone`
    - Windows → `choco install rclone`
- Se estiver instalado:
  - Mostra a versão detectada, por exemplo: `v1.67.0`.

---

### 2. `check_internet_connection()`

Verifica se há **conexão ativa com a internet**, tentando acessar alguns endpoints conhecidos:

- `https://www.google.com`
- `https://www.cloudflare.com`
- `https://rclone.org`

Utiliza `curl` em modo silencioso, com timeout de 10 segundos.  
Se todos falharem, exibe mensagens de alerta sobre falta de conexão, DNS ou proxy.

---

### 3. `check_local_folder()`

Valida a pasta local que será usada na sincronização (`LOCAL_FOLDER`).

Passos executados:

1. Verifica se `LOCAL_FOLDER` está definida (não vazia).
2. Resolve o caminho para um formato absoluto usando `resolve_path`.
3. Se a pasta **não existir**, tenta criá-la automaticamente com `mkdir -p`.
4. Verifica se há **permissão de escrita**.
5. Calcula:
   - Quantidade de arquivos (`file_count`).
   - Tamanho estimado em MB (`get_disk_usage_gb`, convertido para MB na mensagem).

Se alguma etapa falhar (por exemplo, sem permissão), a função retorna erro (`1`).

---

### 4. `check_rclone_remote()`

Verifica se o **remote do rclone** configurado em `REMOTE_NAME` está disponível e funcional.

Passos:

1. Determina o arquivo de configuração do rclone:
   - Windows → `/c/Users/$USERNAME/AppData/Roaming/rclone/rclone.conf`
   - Linux/macOS → `$HOME/.config/rclone/rclone.conf`
2. Verifica se o arquivo existe.
3. Confere se há uma seção `[REMOTE_NAME]` definida no `rclone.conf`.
4. Testa o acesso ao remote com:
   ```bash
   rclone lsd "$REMOTE_NAME:" --max-depth 1
   ```
5. Exibe erro e lista remotes (`rclone listremotes`) se algo estiver errado.

---

### 5. `check_disk_space()`

Verifica o **espaço livre em disco** na unidade onde está a pasta local.

- Usa `get_disk_space_gb "$LOCAL_FOLDER"` (função utilitária) para obter o valor.
- Regras de aviso:
  - `< 2GB` → ❌ Espaço insuficiente
  - `2GB a < 5GB` → ⚠️ Espaço limitado
  - `≥ 5GB` → ✅ Espaço suficiente

---

### 6. `check_sensitive_location()`

Garante que a sincronização **não seja executada em locais sensíveis** do sistema.

- Em **Windows**, verifica caminhos como:
  - `/c/Windows`
  - `/c/Program Files`
  - `/c/Users/Public`
- Em **Linux/macOS**, verifica caminhos como:
  - `/`
  - `/usr`
  - `/var`
  - `/etc`
  - `/home` (raiz geral, não diretórios específicos do usuário)

Se o `LOCAL_FOLDER` for igual ou estiver contido em um desses caminhos, é emitido alerta e a função retorna erro.

---

## ✅ Função Principal: `check_prerequisites()`

Esta é a função que consolida todas as verificações.  
Ela é pensada para ser chamada por outros módulos (como o de sincronização), antes de qualquer operação crítica.

Ordem de execução:

1. `check_rclone_installed`
2. `check_internet_connection`
3. `check_local_folder`
4. `check_rclone_remote`
5. `check_disk_space`
6. `check_sensitive_location`

Se qualquer uma delas falhar (retornar diferente de `0`), a função interrompe o fluxo e retorna `1`.  
Caso todas passem, exibe:

```text
✅ Todos os pré-requisitos atendidos.
```

E retorna `0`.

---

## 🔧 Variáveis Importantes

| Variável | Origem | Descrição |
|----------|--------|-----------|
| `SCRIPT_DIR` | Detectado no início do módulo | Caminho absoluto do diretório onde o script está. |
| `PLATFORM` | `detect_platform()` | Plataforma atual (`linux`, `macos`, `windows`, `unknown`). |
| `LOCAL_FOLDER` | Configuração externa (Config) | Pasta local alvo da sincronização. |
| `REMOTE_NAME` | Configuração externa (Config) | Nome do remote configurado no rclone. |
| `USERNAME` | Ambiente do sistema | Usado para montar caminhos no Windows. |

---

## 💻 Compatibilidade

| Sistema | Suporte | Observações |
|--------|---------|------------|
| **Linux** | ✅ Total | Testes com `curl`, `df`, `rclone` e caminhos em `$HOME`. |
| **macOS** | ✅ Total | Usa mesmas funções POSIX de Linux. |
| **Windows (Git Bash/WSL)** | ✅ Total | Caminhos especiais para `rclone.conf` e comandos ilustrativos (`choco`). |
| **Outros** | ⚠️ Parcial | `PLATFORM=unknown`, algumas mensagens podem não ser específicas. |

---

## 🧰 Exemplo de Integração

Trecho típico em outro script (como o de sincronização):

```bash
if check_prerequisites; then
    echo "Ambiente OK, prosseguindo com a sincronização..."
    # chama função de sync aqui
else
    echo "Erro nos pré-requisitos. Verifique as mensagens acima."
    exit 1
fi
```

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | CopyToGDriver_Checks.sh |
| **Versão** | 0.2.0 |
| **Autores** | Paulo SSPacheco + ChatGPT (GPT-5) |
| **Função** | Verificação de pré-requisitos e ambiente |
| **Módulo** | Checks (multiplataforma) |

---

© 2025 Paulo SSPacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
