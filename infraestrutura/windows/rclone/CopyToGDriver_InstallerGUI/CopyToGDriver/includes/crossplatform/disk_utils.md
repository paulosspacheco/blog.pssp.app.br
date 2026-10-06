Perfeito ✅ — aqui está a documentação **completa e padronizada** para o seu script **`disk_utils.sh (v0.0.01)`**, no mesmo estilo técnico e elegante das versões anteriores que você adotou:

---

# 📘 Documentação Técnica – `disk_utils.sh (v0.0.01)`

## 🧭 Descrição

O script **`disk_utils.sh`** fornece um conjunto de **utilitários universais de gerenciamento de disco**, compatíveis com **Linux**, **macOS** e **Windows** (via **Git Bash**, **WSL** ou **Cygwin**).

Ele permite:

* Listar discos e partições disponíveis;
* Consultar espaço livre de diretórios e volumes;
* Calcular o uso de um diretório;
* Verificar se há espaço disponível suficiente para operações críticas;
* Exibir informações detalhadas sobre o sistema de arquivos atual.

---

## ⚙️ Informações Gerais

**Projeto:** CopyToGDriver
**Script:** `disk_utils.sh`
**Versão:** `v0.0.01`
**Autor:** Paulo SSPacheco + ChatGPT (GPT-5)
**Compatibilidade:**

* ✅ Linux
* ✅ macOS
* ✅ Windows (Git Bash / WSL / Cygwin)

---

## 🛡️ Proteção CRLF Automática

O script inclui uma **autocorreção de CRLF**, evitando falhas de execução quando o arquivo é copiado do Windows para Linux/macOS.
Esse trecho é executado **antes de qualquer função**:

```bash
# 🛡️ Proteção CRLF (5 linhas mágicas)
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi
```

**Função:**

* Detecta se o sistema é Unix-like;
* Corrige automaticamente quebras de linha `CRLF`;
* Reexecuta o script limpo sem intervenção manual.

---

## 🔧 Dependências

| Comando | Descrição                                   | Disponibilidade |
| ------- | ------------------------------------------- | --------------- |
| `df`    | Relatório de uso do sistema de arquivos     | Unix            |
| `du`    | Calcula uso de diretórios                   | Unix            |
| `awk`   | Processamento de texto e formatação         | Unix            |
| `sed`   | Manipulação de strings e substituições      | Unix            |
| `wmic`  | Consulta de informações de disco (opcional) | Windows         |

---

## 🧩 Funções Principais

### 🔹 `detect_os()`

Detecta automaticamente o sistema operacional em execução.

**Retornos possíveis:**

* `Linux`
* `macOS`
* `Windows`
* `Unknown`

---

### 🔹 `list_disks()`

Lista todos os discos ou volumes disponíveis no sistema.
Em Windows, tenta usar `wmic`; caso indisponível, recorre ao `df`.

**Saída Exemplo (Linux):**

```
📀 Listando discos disponíveis...
Device     Mountpoint           Size       Available  Use%
/dev/sda1  /                   100G       74G        26%
```

**Saída Exemplo (Windows Git Bash):**

```
📀 Listando discos disponíveis...
C:   106GB  Livre: 79GB  Volume: VBOX_C
D:   10GB   Livre: 0GB   Volume: VBox_GAs
```

---

### 🔹 `disk_free_space <caminho>`

Mostra o espaço livre (human readable) de um ponto de montagem.

**Exemplo:**

```bash
disk_free_space "/home"
```

➡️ Exibe o resultado formatado pelo `df -h`.

---

### 🔹 `get_disk_space_gb <caminho>`

Retorna o espaço livre em **GB (número inteiro)**, ideal para validações automáticas.

**Exemplo:**

```bash
get_disk_space_gb "/"
# Saída: 78
```

---

### 🔹 `get_disk_usage_gb <caminho>`

Retorna o **uso total de um diretório** em GB.

**Exemplo:**

```bash
get_disk_usage_gb "/home/user"
# Saída: 2
```

---

### 🔹 `check_available_space <caminho> <gb_necessários>`

Verifica se há espaço suficiente em determinado diretório.

**Exemplo:**

```bash
check_available_space "/tmp" 5
# ✅ Espaço suficiente: 74GB disponíveis em /tmp
```

**Códigos de retorno:**

| Código | Significado         |
| ------ | ------------------- |
| `0`    | Espaço suficiente   |
| `1`    | Espaço insuficiente |
| `2`    | Erro ao consultar   |

---

### 🔹 `disk_info <caminho>`

Exibe informações detalhadas de um caminho, incluindo sistema, espaço livre e uso.

**Exemplo:**

```bash
disk_info "/home"
```

**Saída:**

```
=== Informações do Disco ===
Sistema: Linux
Caminho: /home

Espaço livre: 74GB
Uso do diretório: 2GB

Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       100G  26G   74G  26% /
```

---

## ⚙️ Execução via CLI

O script pode ser chamado diretamente no terminal:

```bash
./disk_utils.sh [comando] [caminho] [gb_necessários]
```

### 📜 Comandos disponíveis

| Comando                | Descrição                              |
| ---------------------- | -------------------------------------- |
| `list`                 | Lista discos montados                  |
| `free [caminho]`       | Mostra espaço livre em formato legível |
| `space [caminho]`      | Retorna espaço livre (GB)              |
| `usage [caminho]`      | Retorna uso do diretório (GB)          |
| `check [caminho] [gb]` | Verifica espaço disponível             |
| `info [caminho]`       | Mostra informações detalhadas          |

---

### 🧪 Exemplos de uso prático

```bash
# 1️⃣ Listar discos
./disk_utils.sh list

# 2️⃣ Espaço livre no diretório atual
./disk_utils.sh space "$(pwd)"

# 3️⃣ Verificar se há pelo menos 5GB disponíveis
./disk_utils.sh check /tmp 5

# 4️⃣ Exibir informações completas
./disk_utils.sh info /home
```

---

## 🧩 Exemplo com `source`

Para importar as funções em outro script:

```bash
source ./disk_utils.sh

echo "📀 Discos disponíveis:"
list_disks
echo "💾 Espaço livre no diretório atual: $(get_disk_space_gb "$(pwd)") GB"
echo "📂 Uso do diretório atual: $(get_disk_usage_gb "$(pwd)") GB"
check_available_space "$(pwd)" 1
disk_info "$(pwd)"
```

---

## 🧱 Estrutura Interna

| Seção                   | Descrição                                |
| ----------------------- | ---------------------------------------- |
| `detect_os`             | Identifica o sistema operacional         |
| `list_disks`            | Lista discos e volumes                   |
| `disk_free_space`       | Mostra espaço livre legível              |
| `get_disk_space_gb`     | Espaço livre numérico                    |
| `get_disk_usage_gb`     | Uso do diretório em GB                   |
| `check_available_space` | Verifica se há espaço suficiente         |
| `disk_info`             | Exibe relatório completo                 |
| `main()`                | Interface CLI principal                  |
| Proteção CRLF           | Corrige automaticamente quebras de linha |

---

## 🧩 Integração com outros módulos

Pode ser combinado com:

* `crossplatform_utils.sh` — para logging colorido e detecção de ambiente;
* `crlf_protect.sh` — para proteção global de scripts em projetos grandes.

---

## ✅ Conclusão

O **`disk_utils.sh` (v0.0.01)** é uma ferramenta **universal, autônoma e segura**, desenhada para funcionar de forma consistente em **qualquer sistema operacional**.
A proteção CRLF integrada elimina erros comuns ao copiar scripts entre Windows e Linux.

Ele é a **versão definitiva** para o gerenciamento de espaço de disco no projeto **CopyToGDriver**.

---

Quer que eu gere agora o arquivo `.md` pronto (`disk_utils.md`) e o `.sh` correspondente juntos no mesmo pacote (prontos para salvar na pasta `includes/linux/`)?
