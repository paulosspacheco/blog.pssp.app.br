# 📘 Documentação do Script CopyToGDriver_CopyCurrent.v.0.0.1.sh

## 🧩 Visão Geral

O script **CopyToGDriver_CopyCurrent.v.0.0.1.sh** tem como objetivo sincronizar a **pasta corrente** com o **Google Drive** usando o **rclone**.  
Ele detecta automaticamente o disco de origem, constrói o caminho remoto correspondente e mantém logs centralizados para auditoria.

---

## ⚙️ Parâmetros e Variáveis Principais

Abaixo estão descritos os parâmetros e variáveis utilizados pelo script:

### 🔹 Variáveis de Configuração

| Variável | Descrição | Valor Padrão |
|-----------|------------|---------------|
| `COPYTOGDRIVER_PATH` | Caminho base onde o script principal do CopyToGDriver está instalado. | `/c/scripts/CopyToGDriver` |
| `SCRIPT_NAME` | Caminho completo do script principal (`CopyToGDriver.sh`). | `${COPYTOGDRIVER_PATH}/CopyToGDriver.sh` |
| `BASE_REMOTE_FOLDER` | Pasta base no Google Drive para sincronização. | `rclone` |
| `DELETED_BASE_FOLDER` | Pasta onde são armazenados backups/exclusões. | `rclone.deleted` |
| `REMOTE_NAME` | Nome do remoto configurado no rclone. | `gdriver` |
| `ORIGEM` | Pasta local de origem a ser sincronizada. | `./` |
| `EXCECOES` | Arquivo de exclusões (`ignore list`). | `./CopyToGDriver_ignore.txt` |
| `LOG_ROOT` | Diretório raiz onde os logs serão armazenados. | `$HOME/CopyToGDriver_Log` |
| `LOG_DIR` | Subpasta de logs do sistema. | `$LOG_ROOT/system` |
| `RESTORE_MARKER` | Arquivo marcador que impede sincronização após restauração. | `$LOG_ROOT/.restore_aborted` |
| `DISK_REGISTRY` | Registro de discos usados para detectar caminhos relativos. | `$HOME/.config/CopyToGDriver/disks_registry.conf` |

---

### 🔹 Parâmetros de Execução

O script aceita o seguinte parâmetro de linha de comando:

| Parâmetro | Descrição | Tipo | Exemplo |
|------------|------------|-------|----------|
| `--auto` | Executa em modo automático, sem solicitações de confirmação do usuário. | Opcional | `./CopyToGDriver_CopyCurrent.v.0.0.1.sh --auto` |

---

## 🧠 Funções Internas

### `get_disk_base_path()`
Detecta automaticamente o **disco base** a partir do diretório atual, consultando o arquivo `disks_registry.conf`.  
Se nenhum disco for encontrado, utiliza `/mnt` como fallback.

---

### `run_sync(mode)`
Executa a sincronização de forma **simulada** (`dry`) ou **real** (`real`), montando os parâmetros corretos para o script principal `CopyToGDriver.sh`.

- **Modo Dry-run**: Apenas simula a sincronização, sem alterar arquivos.  
- **Modo Real**: Executa a sincronização efetivamente.  
- Aplica exclusões do arquivo `CopyToGDriver_ignore.txt` (se existir).  
- Gera log detalhado em `$LOG_DIR`.

---

## 🧾 Estrutura de Log

Os logs são armazenados em:  
`~/CopyToGDriver_Log/system/sync-<nome_da_pasta>-<timestamp>.log`

Cada execução contém:

- Informações do diretório local e remoto
- Parâmetros utilizados
- Resultado da simulação e execução
- Últimas 40 linhas exibidas ao final

---

## 🧭 Fluxo de Execução

1. **Detecta o disco base** e calcula o caminho relativo.  
2. **Exibe cabeçalho informativo** com detalhes da sincronização.  
3. **Verifica dependências** (rclone e script principal).  
4. **Executa simulação (dry-run)**.  
5. **Solicita confirmação** (exceto se `--auto` for usado).  
6. **Executa sincronização real**.  
7. **Registra e exibe log final**.

---

## 🚫 Mecanismos de Proteção

- Impede sincronização caso seja detectada restauração recente (`.restore_aborted`).  
- Protege contra sobrescrita acidental após restauração.  
- Interrompe execução se o script principal estiver na Lixeira.  

---

## 🧰 Exemplo de Uso

```bash
# Execução manual com confirmação
./CopyToGDriver_CopyCurrent.v.0.0.1.sh

# Execução automática (sem prompts)
./CopyToGDriver_CopyCurrent.v.0.0.1.sh --auto
```

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | CopyToGDriver_CopyCurrent.v.0.0.1.sh |
| **Versão** | 0.4.1 |
| **Autores** | Paulo SSPacheco + ChatGPT (GPT-5) |
| **Data** | 01/11/2025 |
| **Licença** | Uso pessoal / interno |

---

© 2025 Paulo SSPacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
