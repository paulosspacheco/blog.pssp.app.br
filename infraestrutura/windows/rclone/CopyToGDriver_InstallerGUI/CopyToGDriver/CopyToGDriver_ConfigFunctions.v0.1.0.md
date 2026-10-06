# 📘 Documentação do Script CopyToGDriver_ConfigFunctions.sh

## 🧩 Visão Geral

O módulo **CopyToGDriver_ConfigFunctions.sh** é responsável por implementar as **funções de configuração e parsing de parâmetros** do projeto **CopyToGDriver**.  
Ele centraliza toda a lógica relacionada à leitura de argumentos de linha de comando, confirmação de execução, detecção de ambiente e exibição de ajuda.

---

## ⚙️ Funções Principais

### 1. `detect_platform()`
Detecta automaticamente o sistema operacional e retorna um dos seguintes valores:

| Sistema | Valor retornado |
|----------|----------------|
| Linux | `linux` |
| macOS | `macos` |
| Windows (Git Bash, Cygwin, MSYS) | `windows` |
| Outros | `unknown` |

O resultado é armazenado na variável global `PLATFORM` e utilizado em várias funções para ajustar o comportamento do script.

---

### 2. `write_color_output()`

Função utilitária para exibir mensagens coloridas no terminal, compatível com múltiplas plataformas.

**Parâmetros:**  
- `$1`: mensagem a ser exibida.  
- `$2`: cor desejada (`Red`, `Green`, `Yellow`, `Blue`, `Magenta`, `Cyan`).  

No Windows, o suporte a cores ANSI é automaticamente desativado se o terminal não for compatível.

**Exemplo de uso:**
```bash
write_color_output "Sincronização concluída com sucesso!" "Green"
```

---

### 3. `confirm_sync()`

Solicita confirmação interativa do usuário antes de iniciar a sincronização, exibindo as informações detectadas.

**Fluxo de execução:**
1. Exibe a pasta local e remota detectadas.  
2. Solicita confirmação (`s` ou `S` para continuar).  
3. Cancela a execução se o usuário responder qualquer outra coisa.  

**Exemplo:**
```
Deseja sincronizar a pasta corrente '/home/user/docs'? (s/N): s
Prosseguindo com a sincronização...
```

> ⚠️ No modo automático, a confirmação é pulada e o processo continua sem interação.

---

### 4. `calculate_defaults()`

Define valores padrão caso não tenham sido informados pelo usuário:

| Variável | Descrição | Valor Padrão |
|-----------|------------|---------------|
| `DEFAULT_LOCAL_FOLDER` | Pasta local usada para sincronização. | Diretório atual (`pwd`) |
| `DEFAULT_REMOTE_FOLDER` | Caminho remoto de destino no Drive. | `rclone/<nome_da_pasta_atual>` |
| `DEFAULT_REMOTE_FOLDER` (fallback) | Caso o nome não possa ser determinado. | `rclone/sync-<data>` |

Essa função é executada automaticamente durante o parsing de parâmetros.

---

### 5. `is_effectively_empty()`

Verifica se a pasta local está **efetivamente vazia**, ignorando scripts e arquivos internos do sistema CopyToGDriver.

**Critérios ignorados:**
- `CopyToGDriver_*.sh`
- `CopyToGDriver_CopyCurrent.sh`
- `CopyToGDriver_Restore.sh`
- `CopyToGDriver_ignore.txt`

Se não encontrar arquivos úteis, retorna `0` (verdadeiro).

**Uso típico:**
```bash
if is_effectively_empty "$LOCAL_FOLDER"; then
    echo "Pasta está vazia — restauração necessária."
fi
```

---

### 6. `show_help()`

Exibe a ajuda completa e estruturada com exemplos de uso.

**Exemplo de saída resumida:**
```
🧭  CopyToGDriver - Ajuda de Uso
Uso: CopyToGDriver.sh [OPÇÕES]

OPÇÕES DISPONÍVEIS:
  -l, --local-folder DIR      Define pasta local
  -r, --remote-name NAME      Define remote (padrão: gdriver)
  -f, --remote-folder PATH    Define pasta remota
  -a, --auto-create           Cria pastas automaticamente
  -c, --clean-cache           Limpa cache antes da sincronização
  -n, --dry-run               Simula execução (sem enviar nada)
  -v, --verbose               Ativa logs detalhados
  -R, --resync                Força resincronização completa
  -h, --help                  Exibe esta ajuda
```

---

### 7. `parse_parameters()`

Função central de leitura e interpretação dos parâmetros passados ao script.

**Função:** lê e interpreta as opções da linha de comando, aplicando valores padrão quando necessário.

#### Parâmetros aceitos:

| Opção | Nome longo | Descrição |
|--------|-------------|------------|
| `-l` | `--local-folder` | Define a pasta local a ser sincronizada |
| `-r` | `--remote-name` | Define o nome do remoto do rclone |
| `-f` | `--remote-folder` | Define a pasta remota de destino |
| `-n` | `--dry-run` | Ativa modo simulação |
| `-v` | `--verbose` | Ativa logs detalhados |
| `-R` | `--resync` | Força resincronização completa |
| `-a` | `--auto-create` | Cria pastas ausentes no destino |
| `-c` | `--clean-cache` | Limpa cache antes da sincronização |
| `-h` | `--help` | Exibe ajuda e encerra o programa |

#### Regras internas:
1. Se nenhum parâmetro for informado, chama `confirm_sync()` para confirmação interativa.  
2. Se a pasta local estiver “vazia”, tenta **restaurar automaticamente** seu conteúdo a partir do Google Drive usando `CopyToGDriver_Restore.sh`.  
3. Exibe mensagens de depuração sobre o caminho remoto usado (padrão ou definido manualmente).  

---

### 🧠 Restauração Automática

Ao detectar que a pasta local contém apenas arquivos do sistema, o script tenta restaurar o conteúdo original automaticamente:

1. Localiza `CopyToGDriver_Restore.sh` no mesmo diretório.  
2. Executa-o com o parâmetro `--remote-folder "<nome_da_pasta>"`.  
3. Interpreta o código de retorno e age conforme o resultado:

| Código | Ação |
|--------|------|
| `11` | Restauração concluída, sincronização abortada para evitar sobrescrita. |
| `0` | Restauração completa, sincronização encerrada normalmente. |
| Outro | Erro na restauração — execução interrompida. |

---

## 🧩 Variáveis Globais Importantes

| Variável | Descrição | Origem |
|-----------|------------|--------|
| `LOCAL_FOLDER` | Caminho local da pasta a sincronizar | Parâmetro `-l` ou padrão |
| `REMOTE_NAME` | Nome do remoto do rclone | Parâmetro `-r` ou padrão |
| `REMOTE_FOLDER` | Caminho remoto no Drive | Parâmetro `-f` ou padrão |
| `DRY_RUN` | Define modo simulação | Flag `-n` |
| `VERBOSE` | Exibe logs detalhados | Flag `-v` |
| `AUTO_CREATE` | Cria pastas automaticamente | Flag `-a` |
| `CLEAN_CACHE` | Limpa cache antes de sincronizar | Flag `-c` |
| `RESYNC` | Força resincronização completa | Flag `-R` |
| `SHOW_HELP` | Exibe ajuda e encerra o script | Flag `-h` |

---

## 💻 Compatibilidade

| Sistema | Suporte | Observações |
|----------|----------|-------------|
| **Linux** | ✅ Completo | Suporte nativo a cores ANSI e paths POSIX |
| **macOS** | ✅ Completo | Comportamento idêntico ao Linux |
| **Windows (Git Bash)** | ✅ Parcial | Cores ANSI podem não funcionar em todos os terminais |
| **Outros** | ⚠️ Parcial | Detectado como “unknown”; comportamento básico |

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | CopyToGDriver_ConfigFunctions.sh |
| **Versão** | 0.1.0 |
| **Autores** | Paulo SSPacheco + ChatGPT (GPT-5) |
| **Data** | 01/11/2025 |
| **Licença** | Uso pessoal / interno |

---

© 2025 Paulo SSPacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
