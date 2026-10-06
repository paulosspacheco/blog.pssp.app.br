# 🚀 Guia de Instalação do CopyToGDriver (Windows)

## 📘 Visão Geral

O **CopyToGDriver** é um conjunto de scripts Bash que automatizam a sincronização de pastas locais com o **Google Drive**, utilizando o **Rclone**.

Este documento explica **como instalar, testar e remover** o CopyToGDriver em um ambiente **Windows** utilizando o script `install.ps1` (versão 1.3).

---

## ⚙️ Pré-requisitos

### 🧩 Requisitos mínimos
- **Windows 10/11** (ou Windows Server 2019+)
- **Permissão de Administrador** (para instalar o `rclone`)
- **PowerShell 5.1+** (ou PowerShell Core)
- **Conexão com a Internet**
- (Opcional, mas recomendado) **Git Bash**
  - [Download Git Bash](https://git-scm.com/downloads/win)

---

## 📁 Estrutura recomendada

Por padrão, o instalador copia os arquivos para:

```

C:\scripts\CopyToGDriver

````

Caso prefira outro local, use o parâmetro `--path`.

---

## 🔧 Passo a passo de instalação

### 1️⃣ Abrir o PowerShell
- Clique em **Iniciar → PowerShell**
- Clique com o botão direito e escolha **"Executar como Administrador"**

### 2️⃣ Permitir execução de scripts temporariamente

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
````

### 3️⃣ Acessar a pasta onde estão os arquivos

```powershell
cd C:\Downloads\CopyToGDriver
```

### 4️⃣ Executar o instalador

#### Instalação padrão

```powershell
.\install.ps1
```

#### Instalação personalizada

```powershell
.\install.ps1 --path "D:\Ferramentas\CopyToGDriver"
```

---

## 🧰 O que o instalador faz

| Etapa | Ação                                                                       |
| ----- | -------------------------------------------------------------------------- |
| 1     | Cria a pasta `C:\scripts\CopyToGDriver` (ou caminho definido por `--path`) |
| 2     | Copia todos os scripts `.sh` e subpastas (`includes/`, etc.)               |
| 3     | Verifica se o `rclone` está instalado                                      |
| 4     | Se não estiver, baixa e instala o `rclone.exe` em `C:\Windows\System32`    |
| 5     | Cria o arquivo de registro `~\.copytogdriver\install_record.json`          |
| 6     | Executa um teste rápido (`--check-only`)                                   |
| 7     | Mostra o resultado e o caminho final da instalação                         |

---

## ✅ Verificação pós-instalação

Após a execução, abra o **Git Bash** (como Administrador) e teste:

```bash
cd /c/scripts/CopyToGDriver
bash CopyToGDriver.sh --check-only
```

Se tudo estiver correto, você verá:

```
✅ Todas as dependências verificadas com sucesso!
TODOS OS PRÉ-REQUISITOS ATENDIDOS
```

---

## 🧾 Registro de Instalação

O instalador cria o arquivo:

```
%USERPROFILE%\.copytogdriver\install_record.json
```

Exemplo de conteúdo:

```json
{
  "install_path": "C:\\scripts\\CopyToGDriver",
  "rclone_installed_by_script": true
}
```

Esse registro é usado pelo **`uninstall.ps1`** para remover apenas o que foi instalado pelo script.

---

## 🧹 Desinstalação

Para remover completamente o CopyToGDriver:

```powershell
cd C:\Downloads\CopyToGDriver
.\uninstall.ps1
```

### Desinstalação silenciosa

```powershell
.\uninstall.ps1 --silent
```

🔹 O desinstalador:

* Lê o `install_record.json`
* Remove a pasta do projeto
* **Remove o rclone.exe apenas se ele foi instalado pelo script**

---

## 🧪 Testes adicionais

Após instalar, você pode rodar:

```bash
bash /c/scripts/CopyToGDriver/CopyToGDriver.sh --check-only
bash /c/scripts/CopyToGDriver/CopyToGDriver.sh
```

---

## 🧠 Dicas úteis

### Adicionar ao PATH (opcional)

Para poder executar `CopyToGDriver.sh` de qualquer lugar:

1. No **Painel de Controle → Sistema → Variáveis de ambiente**

2. Edite **PATH** e adicione:

   ```
   C:\scripts\CopyToGDriver
   ```

3. Reinicie o terminal.

---

## 🛠 Solução de Problemas

| Erro                              | Solução                                                    |
| --------------------------------- | ---------------------------------------------------------- |
| `bash: command not found`         | Instale o Git Bash                                         |
| `rclone not found`                | Reexecute o `install.ps1` como Administrador               |
| `Permissão negada`                | Execute PowerShell como **Administrador**                  |
| `O script não pode ser executado` | Execute `Set-ExecutionPolicy Bypass -Scope Process -Force` |

---

## 📦 Estrutura final esperada

Após a instalação, o sistema deve estar assim:

```
C:\scripts\CopyToGDriver\
├── CopyToGDriver.sh
├── CopyToGDriver_Cache.sh
├── CopyToGDriver_Checks.sh
├── CopyToGDriver_Config.sh
├── includes\
│   ├── common\
│   ├── linux\
│   └── windows\
└── install_record.json
```

---

## 🔄 Atualizações futuras

Para atualizar apenas os scripts (sem reinstalar rclone):

```powershell
.\install.ps1 --path "C:\scripts\CopyToGDriver"
```

ou, em breve:

```powershell
.\install.ps1 --update
```

---

## 🧩 Arquivos relacionados

| Arquivo               | Função                                 |
| --------------------- | -------------------------------------- |
| `install.ps1`         | Instala o CopyToGDriver                |
| `uninstall.ps1`       | Remove o CopyToGDriver                 |
| `pack.ps1`            | Gera o pacote `.zip` para distribuição |
| `install_record.json` | Registro interno de instalação         |

---

## 👨‍💻 Autor

**Paulo SSPacheco + ChatGPT (GPT-5)**
Versão da documentação: **v1.3.0**

---
