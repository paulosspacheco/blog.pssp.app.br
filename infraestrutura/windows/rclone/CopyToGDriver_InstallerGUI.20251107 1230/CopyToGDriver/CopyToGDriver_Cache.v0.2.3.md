# 📘 Documentação do Script CopyToGDriver_Cache.sh

## 🧩 Visão Geral

O módulo **CopyToGDriver_Cache.sh** faz parte do projeto **CopyToGDriver** e é responsável por **gerenciar o cache do Rclone** e **verificar o espaço em disco disponível** antes das sincronizações.  
Esta versão é totalmente **autônoma**, **multiplataforma** e **corrigida**, garantindo compatibilidade com **Linux, macOS e Windows (Git Bash)**.

---

## ⚙️ Objetivos Principais

- 🧹 Limpar diretórios de cache do Rclone.  
- 🔍 Detectar e encerrar processos ativos do Rclone.  
- 💽 Verificar espaço livre no disco antes da sincronização.  
- 🧠 Fornecer informações diagnósticas sobre o cache.  

---

## 🔧 Variáveis e Configurações

| Variável | Descrição |
|-----------|------------|
| `DRY_RUN` | Indica se a execução está em modo de simulação (sem excluir arquivos). |
| `USERNAME` | Nome de usuário (usado para detectar cache no Windows). |
| `HOME` | Diretório principal do usuário (usado para localizar caches). |

---

## 🧠 Funções Principais

### `write_color_output(message, color)`
Exibe mensagens coloridas no terminal para facilitar a leitura.  
Cores suportadas: `Red`, `Green`, `Yellow`, `Blue`, `Cyan`.

Exemplo:
```bash
write_color_output "Limpando cache..." "Yellow"
```

---

### `check_rclone_processes()`
Verifica se existem processos **rclone** em execução no sistema.  
Funciona em múltiplas plataformas:

- 🐧 Linux/macOS → via `pgrep`  
- 🪟 Windows (Git Bash) → via `tasklist`

Retorna `0` se nenhum processo estiver ativo, `1` caso contrário.

---

### `stop_rclone_processes()`
Finaliza todos os processos **rclone** ativos.  
Métodos de parada:
- `pkill -f "rclone"` (Linux/macOS)  
- `taskkill //F //IM "rclone.exe"` (Windows)

---

### `cleanup_rclone_cache()`
Função principal de **limpeza do cache Rclone**.  
Executa as seguintes ações:

1. Verifica se há processos rclone ativos e os finaliza.  
2. Localiza diretórios de cache em diferentes sistemas:  
   - `~/.cache/rclone`  
   - `/c/Users/<username>/AppData/Local/rclone/cache`  
   - `$HOME/AppData/Local/rclone/cache`  
3. Calcula tamanho aproximado do cache antes da exclusão.  
4. Remove arquivos temporários (exceto em modo `DRY_RUN`).  
5. Exibe mensagens de progresso e resultado.

Exemplo:
```bash
cleanup_rclone_cache
```

---

### `check_disk_space_for_sync(local_folder)`
Verifica se há espaço suficiente em disco no diretório local antes da sincronização.

- Mostra o espaço livre em gigabytes (usando `df -BG`).
- Exibe aviso se o diretório não existir.

Exemplo:
```bash
check_disk_space_for_sync "/mnt/data/projetos"
```

---

### `get_cache_info()`
Exibe informações básicas de diagnóstico sobre o cache do Rclone.

---

### `validate_cache_module()`
Valida se o módulo de cache foi carregado corretamente.  
Usado em scripts principais para garantir integridade do ambiente.

---

## 💻 Compatibilidade

| Sistema | Suporte | Observações |
|----------|----------|-------------|
| **Linux** | ✅ Total | Suporte a `pgrep`, `pkill`, `df`, `du` |
| **macOS** | ✅ Total | Compatível com comandos POSIX |
| **Windows (Git Bash)** | ✅ Total | Usa `tasklist` e `taskkill` |
| **Outros ambientes** | ⚠️ Parcial | Pode exigir ajustes manuais |

---

## 🧾 Estrutura de Execução

```
CopyToGDriver_Cache.sh
 ├── write_color_output()          # Exibe mensagens coloridas
 ├── check_rclone_processes()      # Detecta processos rclone
 ├── stop_rclone_processes()       # Encerra processos rclone
 ├── cleanup_rclone_cache()        # Limpa diretórios de cache
 ├── check_disk_space_for_sync()   # Verifica espaço em disco
 ├── get_cache_info()              # Exibe informações do cache
 ├── validate_cache_module()       # Confirma carregamento do módulo
 └── Execução direta (diagnóstico)
```

---

## 🧰 Exemplo de Saída

```
✅ [CACHE] Versão corrigida carregada (2025-11-07 15:20:33)
[LIMPEZA DE CACHE RCLONE]
  🔍 Verificando processos Rclone...
  ✅ Nenhum processo Rclone ativo
  📁 Cache encontrado: /home/usuario/.cache/rclone
     Tamanho: 25MB
     ✅ Cache limpo
  ✅ Verificação de cache concluída
```

---

## 🧪 Execução Direta

Quando executado diretamente no terminal, o script exibe as funções disponíveis:

```bash
=== MÓDULO DE CACHE ===
✅ Carregado com sucesso
🔍 Funções disponíveis:
declare -F | grep -E "(cleanup_rclone_cache|check_disk_space_for_sync)"
```

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | CopyToGDriver_Cache.sh |
| **Versão** | 0.2.3 |
| **Autores** | Paulo S. Pacheco + ChatGPT (GPT-5) |
| **Data** | 01/11/2025 |
| **Licença** | Uso pessoal / interno |

---

© 2025 Paulo S. Pacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
