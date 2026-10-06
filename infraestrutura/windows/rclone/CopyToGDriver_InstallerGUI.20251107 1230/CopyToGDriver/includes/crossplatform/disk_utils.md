# CopyToGDriver – Disk Utilities (v0.0.5)

## 📘 Descrição Geral
O script **`disk_utils.sh`** fornece utilitários essenciais para manipulação de discos e caminhos em ambientes **Windows**, **Git Bash**, **Linux** e **máquinas virtuais VirtualBox**.  
Ele foi desenvolvido como parte do projeto **CopyToGDriver**, garantindo compatibilidade total entre os diferentes ambientes e sistemas de arquivos.

---

## 🧭 Função do Script
O **disk_utils.sh (v0.0.5)** oferece recursos para:
- Listar discos disponíveis e seus volumes.
- Obter o espaço livre em uma unidade (em GB).
- Calcular o uso de um diretório (em MB).
- Converter caminhos entre os formatos **Windows (C:\...)** e **Git Bash (/c/...)**.
- Detectar e adaptar-se automaticamente ao ambiente VirtualBox, Linux ou Windows.

---

## ⚙️ Dependências
| Requisito | Descrição |
|------------|------------|
| `bash` | Shell principal de execução. |
| `wmic` | Ferramenta nativa do Windows para consultar informações de disco. |
| `awk`, `sed`, `tr` | Utilitários para manipulação de texto. |
| `du`, `df` | Usados no modo compatível (Linux ou VM). |
| `powershell` | Utilizado como fallback para calcular espaço livre. |

---

## 🧩 Funções Principais

### 1. `list_disks()`
Lista os discos disponíveis com informações básicas (nome, volume, espaço livre, tamanho total).

**Exemplo:**
```bash
list_disks
```

**Saída esperada:**
```
C:    Sistema       83GB livres de 100GB
D:    Dados         450GB livres de 500GB
```

---

### 2. `disk_free_space <letra_da_unidade>`
Exibe o espaço livre e total de uma unidade.

**Exemplo:**
```bash
disk_free_space "C"
```

---

### 3. `get_disk_space_gb <caminho>`
Retorna o espaço livre em **GB** de uma unidade ou diretório.

**Exemplo:**
```bash
get_disk_space_gb "/c"
# Saída: 83
```

---

### 4. `get_disk_usage_gb <caminho>`
Retorna o uso total de um diretório em **MB**.

**Exemplo:**
```bash
get_disk_usage_gb "$(pwd)"
# Saída: 1
```

---

### 5. `to_windows_path <caminho>`
Converte caminhos do formato Git Bash para o formato Windows.

**Exemplo:**
```bash
to_windows_path "/c/Users/Paulo/Documents"
# Saída: C:\Users\Paulo\Documents
```

---

### 6. `to_gitbash_path <caminho>`
Converte caminhos do formato Windows para o formato Git Bash.

**Exemplo:**
```bash
to_gitbash_path "C:\Temp"
# Saída: /c/Temp
```

---

### 7. `is_windows_path <caminho>`
Verifica se o caminho informado está no formato Windows.

**Exemplo:**
```bash
is_windows_path "C:\Users\Paulo" && echo "É Windows" || echo "Não é Windows"
# Saída: É Windows
```

---

### 8. `path_convert_auto <caminho>`
Detecta automaticamente o formato do caminho e realiza a conversão correta.

**Exemplo:**
```bash
path_convert_auto "/c/Users/Paulo"
# Saída: C:\Users\Paulo
```

---

## 🧠 Compatibilidade Automática
O script detecta automaticamente o ambiente em que está rodando:

| Ambiente | Comportamento |
|-----------|----------------|
| **Git Bash / Cygwin** | Usa `wmic` e PowerShell para cálculos. |
| **VirtualBox** | Usa `df` e `du` nativos (modo compatível). |
| **Linux / macOS** | Usa apenas comandos POSIX (`df`, `du`). |

---

## 🧪 Exemplo Completo de Uso

```bash
# Carregar o módulo
source ./disk_utils.sh

echo "📀 Discos disponíveis:"
list_disks

echo "💾 Espaço livre no C: $(get_disk_space_gb "/c") GB"
echo "📂 Uso da pasta atual: $(get_disk_usage_gb "$(pwd)") MB"
echo "🪟 Caminho Windows atual: $(to_windows_path "$(pwd)")"
echo "🐧 Caminho Git Bash de C:\Temp: $(to_gitbash_path "C:\Temp")"
```

**Saída esperada (Git Bash em VM VirtualBox):**
```
📀 Listando discos disponíveis...
C:    83GB livres
V:    100GB livres
💾 Espaço livre no C: 83 GB
📂 Uso da pasta atual: 1 MB
🪟 Caminho Windows atual: v:\LazarusProjects\CopyToGDriver\includes\windows
🐧 Caminho Git Bash de C:\Temp: /c/Temp
```

---

## 📁 Localização Recomendada
Coloque este script em:
```
~/scripts/CopyToGDriver/includes/windows/disk_utils.sh
```
e carregue-o a partir de outros módulos com:
```bash
source "$COPYTOGDRIVER_PATH/includes/windows/disk_utils.sh"
```

---

## 🧾 Histórico de Versões

| Versão | Data | Alterações |
|--------|------|-------------|
| **v0.0.5** | 2025-11-08 | Adicionadas funções de conversão e suporte para VirtualBox. |
| **v0.0.4** | 2025-11-08 | Substituição de WMIC por PowerShell. |
| **v0.0.3** | 2025-11-08 | Melhorias no tratamento de CRLF e detecção de volume. |
| **v0.0.2** | 2025-11-07 | Compatibilidade com Git Bash. |
| **v0.0.1** | 2025-11-07 | Versão inicial. |

---

## ✍️ Autor
**Paulo SSPacheco**  
Com assistência de **ChatGPT (GPT‑5)**, **DeepSeek**, e **Glock**  
Parte integrante do projeto **CopyToGDriver**.
