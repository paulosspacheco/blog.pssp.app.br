# 🧭 CopyToGDriver – disk_utils.sh - Windows Disk Utilities

### Arquivo: `include/windows/disk_utils.sh`

### Versão: **v0.0.01**

### Autor: **Paulo SSPacheco + ChatGPT (GPT-5)**

---

## 📘 Descrição Geral

O script **`disk_utils.sh`** é um **módulo auxiliar** do projeto **CopyToGDriver**, criado para fornecer funções de inspeção de disco e medição de espaço livre em **ambientes Windows** com **Git Bash** instalado.

Ele é responsável por:

* Listar discos e partições disponíveis no sistema;
* Consultar o espaço livre de uma unidade (`C:`, `D:`, etc.);
* Medir o tamanho (em MB) de pastas específicas;
* Fornecer métricas de uso de disco em formato legível e automatizável.

⚙️ Este módulo é utilizado **internamente** por outros scripts (como `CopyToGDriver.sh` ou `CopyToGDriver_Installer.ps1`) para obter informações de armazenamento.

---

## 🗂️ Estrutura e Localização no Projeto

O arquivo deve estar localizado em:

```
CopyToGDriver/
 ├── include/
 │   ├── windows/
 │   │   └── disk_utils.sh   ← (este script)
 ├── utils/
 │   └── outros_utilitários.sh
 ├── CopyToGDriver.sh
 └── CopyToGDriver_Installer.ps1
```

Essa organização segue o padrão modular do projeto, onde **`include/windows/`** guarda scripts **específicos do sistema operacional**.

---

## ⚙️ Funções Disponíveis

| Função                            | Descrição                                                                               | Exemplo de Uso               |
| --------------------------------- | --------------------------------------------------------------------------------------- | ---------------------------- |
| **`list_disks`**                  | Lista os discos montados, mostrando nome, volume, espaço livre e total.                 | `list_disks`                 |
| **`disk_free_space <letra>`**     | Mostra espaço livre e total de uma unidade em formato bruto (útil para debug).          | `disk_free_space C`          |
| **`get_disk_space_gb <caminho>`** | Retorna o espaço livre em GB, calculado a partir do caminho informado (ex: `/c/Users`). | `get_disk_space_gb "/c"`     |
| **`get_disk_usage_gb <caminho>`** | Retorna o uso total da pasta informada em MB.                                           | `get_disk_usage_gb "$(pwd)"` |

---

## 💻 Exemplo de Uso Manual (no Git Bash – Windows)

1. **Importe o script:**

   ```bash
   source ./include/windows/disk_utils.sh
   ```

2. **Execute as funções:**

   ```bash
   echo "📀 Discos disponíveis:"
   list_disks

   echo "💾 Espaço livre no C: $(get_disk_space_gb "/c") GB"
   echo "📂 Uso da pasta atual: $(get_disk_usage_gb "$(pwd)") MB"
   ```

3. **Saída esperada:**

   ```
   📀 Discos disponíveis:
   C:   SYSTEM   47GB free   512GB total
   D:   DATA     104GB free  1024GB total
   💾 Espaço livre no C: 47 GB
   📂 Uso da pasta atual: 230 MB
   ```

---

## 🧩 Compatibilidade

| Ambiente                     | Compatível   | Observação                                                 |
| ---------------------------- | ------------ | ---------------------------------------------------------- |
| 🪟 **Windows (Git Bash)**    | ✅ Totalmente | Requer `wmic`, `awk`, `du`                                 |
| 🐧 **Linux (Ubuntu/Debian)** | ⚠️ Parcial   | Necessita adaptar `wmic → df`                              |
| 🍎 **macOS**                 | ⚠️ Parcial   | `wmic` indisponível, mas pode ser adaptado com `df` e `du` |

---

## 🧠 Notas Técnicas

* **`wmic`**: Utilizado para coletar informações de disco em sistemas Windows.

  * Substituível por `df` em Linux/macOS.
* **`awk`**: Usado para processar e formatar as saídas.
* **`du -sb`**: Calcula o tamanho de diretórios em bytes.

---

## 🧰 Uso Isolado (fora do projeto)

O script pode ser usado **isoladamente** como ferramenta de linha de comando.
Basta copiá-lo para uma pasta e importar com `source` no Git Bash:

```bash
source /c/scripts/disk_utils.sh
list_disks
```

Ou tornar executável (caso queira modificar para rodar direto):

```bash
chmod +x disk_utils.sh
./disk_utils.sh
```

*(por padrão, ele apenas define funções, não executa nada sozinho)*

---

## 🧾 Histórico de Versões

| Versão      | Data       | Descrição                                                 |
| ----------- | ---------- | --------------------------------------------------------- |
| **v0.0.01** | 2025-11-07 | Versão inicial adaptada para ambiente Windows (Git Bash). |

---

## ✍️ Autoria e Créditos

* **Autor principal:** Paulo SSPacheco
* **Assistência técnica e redação:** ChatGPT (GPT-5), DeepSeek e Glock
* **Projeto:** [CopyToGDriver](../CopyToGDriver.md)

> Este módulo faz parte do ecossistema de scripts de automação do CopyToGDriver, voltado à integração e cópia inteligente de arquivos para o Google Drive.

---
