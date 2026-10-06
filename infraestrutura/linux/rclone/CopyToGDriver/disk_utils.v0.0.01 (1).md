# CopyToGDriver - disk_utils.sh (v0.0.01)

## 📘 Descrição Geral

O script **disk_utils.sh** é um utilitário universal de gerenciamento e diagnóstico de discos desenvolvido para o projeto **CopyToGDriver**.  
Ele foi projetado para funcionar de forma **multiplataforma**, sendo compatível com **Linux**, **macOS** e **Windows (via Git Bash ou WSL)**.

O objetivo deste módulo é fornecer funções reutilizáveis para verificar o espaço livre, listar discos, calcular uso de diretórios e validar requisitos de armazenamento — tudo em um único script leve e independente.

---

## 🧠 Finalidade e Contexto

Este módulo faz parte da suíte de automação do **CopyToGDriver**, e pode ser usado tanto:

- De forma **interna**, por outros scripts do sistema (instaladores, verificadores, restauradores);  
- Quanto de forma **isolada**, diretamente pelo usuário no terminal (bash, zsh ou Git Bash).

Ele substitui ferramentas específicas de cada plataforma (como `wmic`, `df`, `du`, `Get-Volume`) por uma camada unificada, mantendo consistência no output.

---

## ⚙️ Funções Principais

### 🔹 `detect_os()`
Detecta automaticamente o sistema operacional atual e retorna:
- `Linux`
- `macOS`
- `Windows`
- `Unknown`

### 🔹 `list_disks()`
Lista todos os discos e partições montadas, exibindo espaço total e livre.  
O comportamento se adapta ao SO detectado:
- Linux/macOS → usa `df -h`
- Windows → usa `wmic logicaldisk` (ou `df` via WSL, se `wmic` indisponível)

### 🔹 `disk_free_space <caminho>`
Mostra o espaço livre do ponto de montagem especificado, com saída em formato legível (`df -h`).

### 🔹 `get_disk_space_gb <caminho>`
Retorna o espaço livre em **GB** como valor numérico (sem unidades).  
Ideal para validações automáticas.

### 🔹 `get_disk_usage_gb <caminho>`
Calcula o uso do diretório informado (em GB), com suporte a Linux/macOS.

### 🔹 `check_available_space <caminho> <gb_necessarios>`
Verifica se há espaço suficiente disponível e exibe:
- ✅ **Espaço suficiente**
- ❌ **Espaço insuficiente**

Retorna `0` (sucesso) ou `1` (falha), podendo ser usado em condicionais bash.

### 🔹 `disk_info <caminho>`
Mostra um resumo completo do estado do disco, incluindo:
- Sistema operacional detectado
- Caminho alvo
- Espaço livre e uso do diretório
- Tabela detalhada de filesystem (`df -h`)

### 🔹 `main()`
Função principal com interface de linha de comando, permitindo uso direto:

```
disk_utils.sh {list|free|space|usage|check|info} [caminho] [gb_necessarios]
```

---

## 🧩 Exemplos de Uso

### ✅ Listar discos montados
```bash
bash disk_utils.sh list
```

### ✅ Ver espaço livre de uma pasta
```bash
bash disk_utils.sh free /home
```

### ✅ Obter espaço disponível em GB
```bash
bash disk_utils.sh space /mnt
# Saída: 82
```

### ✅ Verificar se há pelo menos 10 GB disponíveis em /tmp
```bash
bash disk_utils.sh check /tmp 10
# Saída: ✅ Espaço suficiente: 85GB disponíveis em /tmp
```

### ✅ Mostrar informações completas do disco atual
```bash
bash disk_utils.sh info .
```

### ✅ Usar funções no modo interativo (source)
```bash
source ./disk_utils.sh
echo "Espaço livre: $(get_disk_space_gb /) GB"
```

---

## 🧱 Estrutura do Código

- O script usa **`uname -s`** para detectar o sistema operacional.
- Todas as funções são compatíveis com **bash 4+**.
- Para evitar dependências, apenas comandos nativos são utilizados (`df`, `du`, `awk`, `sed`).
- Em **Windows**, usa `wmic` quando disponível (ou `df /mnt/?` via WSL).

---

## 💻 Compatibilidade

| Sistema Operacional | Compatível | Mecanismo Usado |
|----------------------|-------------|------------------|
| 🐧 Linux | ✅ | df / du |
| 🍎 macOS | ✅ | df / du |
| 🪟 Windows (Git Bash / WSL) | ✅ | wmic / df / awk |
| 🪟 Windows (PowerShell) | ⚠️ | Use versão `disk_utils.ps1` |

---

## 📄 Licença e Créditos

- **Autor:** Paulo SSPacheco + ChatGPT (GPT‑5)  
- **Versão:** v0.0.01  
- **Projeto:** CopyToGDriver  
- **Licença:** Uso livre para fins pessoais e educacionais

---

## 🧩 Histórico de Versões

| Versão | Data | Descrição |
|--------|------|------------|
| v0.0.01 | 2025‑11‑07 | Primeira versão universal (Linux/macOS/Windows) com funções de listagem, cálculo e verificação de espaço. |

---

## 💡 Dica de Integração

Você pode importar este módulo em outros scripts com segurança:

```bash
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/disk_utils.sh"

if check_available_space "/mnt/data" 5; then
    echo "Espaço OK. Continuando..."
else
    echo "Erro: espaço insuficiente."
    exit 1
fi
```
