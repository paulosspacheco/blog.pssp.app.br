# 📘 Documentação do Script CopyToGDriver_Installer.sh

## 🧩 Visão Geral

O módulo **CopyToGDriver_Installer.sh** é o **instalador oficial do sistema CopyToGDriver**, responsável por preparar o ambiente, configurar o **Rclone**, registrar discos, instalar os módulos e criar aliases globais.  

Ele garante que o sistema esteja totalmente funcional após a instalação, em qualquer plataforma compatível (Linux, macOS ou Windows via Git Bash).

---

## ⚙️ Função Principal

O objetivo deste script é **automatizar a instalação completa** do CopyToGDriver, incluindo:

1. Instalação e configuração do **Rclone**.  
2. Criação automática do remote **gdriver**.  
3. Registro de discos do sistema.  
4. Cópia de todos os scripts do projeto para o diretório padrão.  
5. Criação de **aliases globais** (copydrive, copycheck, copyrestore).  
6. Exibição de informações de finalização.  

---

## 📦 Estrutura de Instalação

| Componente | Caminho padrão |
|-------------|----------------|
| Diretório de instalação | `$HOME/scripts/CopyToGDriver` |
| Logs do sistema | `$HOME/CopyToGDriver_Log/system` |
| Configuração do Rclone | `$HOME/.config/rclone/rclone.conf` |
| Registro de discos | `$HOME/.config/CopyToGDriver/disks_registry.conf` |
| Flag de instalação | `$HOME/CopyToGDriver_Log/system/.rclone_installed_by_copytogdriver` |

---

## 🔧 Etapas da Instalação

### **1. Verificação e Instalação do Rclone**

O script verifica se o Rclone está instalado com:
```bash
command -v rclone
```

Se não estiver disponível, ele executa automaticamente:
```bash
curl -fsSL https://rclone.org/install.sh | sudo bash
```

Após a instalação, cria uma flag indicando que o Rclone foi instalado pelo próprio CopyToGDriver em:
```
~/.CopyToGDriver_Log/system/.rclone_installed_by_copytogdriver
```

Se o Rclone já estiver presente, apenas exibe sua versão.

---

### **2. Criação e Verificação do Remote `gdriver`**

A segunda etapa garante que o **remote do Google Drive (`gdriver`)** esteja configurado.  

- Verifica o arquivo `rclone.conf`:
  ```bash
  grep "^\[gdriver\]" ~/.config/rclone/rclone.conf
  ```
- Se não existir, cria automaticamente o remote:
  ```bash
  rclone config create gdriver drive scope=drive
  ```
- Solicita autenticação via navegador Google e executa:
  ```bash
  rclone config reconnect gdriver:
  ```

✅ Ao final, o remote “gdriver” fica disponível para uso em todos os módulos CopyToGDriver.

---

### **3. Registro de Discos do Sistema**

O script cria ou atualiza o arquivo de registro de discos, usado para detectar automaticamente o disco base durante sincronizações.

Arquivo:  
```
~/.config/CopyToGDriver/disks_registry.conf
```

**Funcionamento:**
- Captura todos os pontos de montagem ativos (`mount`).
- Filtra apenas sistemas de arquivos válidos (`ext4`, `xfs`, `btrfs`, `ntfs`).
- Salva entradas no formato:
  ```
  /mnt/data=ACTIVE
  /=ACTIVE
  ```
- Se nenhum disco for encontrado, adiciona `/mnt=DEFAULT` como fallback.

---

### **4. Instalação dos Scripts Principais**

Todos os arquivos que começam com `CopyToGDriver` (incluindo o script principal sem sufixo) são copiados para:

```
~/scripts/CopyToGDriver/
```

O script executa:
```bash
cp -r ./CopyToGDriver* "$INSTALL_DIR"
chmod +x "$INSTALL_DIR"/*.sh
```

✅ Garante que todos os módulos estejam prontos para execução com permissão total.

---

### **5. Criação de Aliases Globais**

O instalador adiciona automaticamente três **aliases globais** no arquivo `~/.bashrc`:

| Alias | Comando | Função |
|--------|----------|--------|
| `copydrive` | `bash ~/scripts/CopyToGDriver/CopyToGDriver_CopyCurrent.sh` | Sincroniza a pasta atual |
| `copycheck` | `bash ~/scripts/CopyToGDriver/CopyToGDriver.sh --check-only` | Verifica ambiente e dependências |
| `copyrestore` | `bash ~/scripts/CopyToGDriver/CopyToGDriver_Restore.sh` | Restaura backup mais recente |

Após a instalação, recomenda-se recarregar o bash:
```bash
source ~/.bashrc
```

---

### **6. Finalização e Resumo**

Ao concluir, o script exibe um resumo completo da instalação:

```
======================================================
✅ Instalação concluída com sucesso!
======================================================
📂 Scripts instalados em: /home/user/scripts/CopyToGDriver
📜 Logs armazenados em:   /home/user/CopyToGDriver_Log/system
💽 Registro de discos:    /home/user/.config/CopyToGDriver/disks_registry.conf
```

Ele também indica se o Rclone foi instalado pelo próprio instalador ou se já existia.

---

## ⚙️ Variáveis Internas

| Variável | Descrição |
|-----------|------------|
| `INSTALL_DIR` | Caminho de instalação dos scripts CopyToGDriver |
| `LOG_ROOT` | Diretório raiz de logs do sistema |
| `RCLONE_CONFIG` | Caminho do arquivo de configuração do Rclone |
| `FLAG_FILE` | Marca que o Rclone foi instalado pelo CopyToGDriver |
| `REMOTE_NAME` | Nome do remote padrão criado (`gdriver`) |
| `DISK_REGISTRY` | Caminho do arquivo que lista discos e montagens |

---

## 🧰 Comandos Pós-Instalação

Após finalizar a instalação, execute:

```bash
source ~/.bashrc
```

E utilize os comandos:

| Comando | Ação |
|----------|------|
| `copydrive` | Sincroniza a pasta atual |
| `copycheck` | Verifica dependências e ambiente |
| `copyrestore` | Restaura backup da pasta atual |

---

## 🧠 Requisitos

| Requisito | Descrição |
|------------|------------|
| **Sistema** | Linux, macOS ou Windows com Git Bash |
| **Permissões** | Acesso `sudo` para instalar o Rclone |
| **Internet** | Necessária para baixar o Rclone e autenticar com o Google |

---

## 🧩 Mensagens Importantes

- Caso o Rclone já esteja instalado, nenhuma reinstalação é feita.  
- Se o remote `gdriver` já existir, o instalador pula a criação.  
- Se nenhum disco montado for detectado, `/mnt` é registrado por padrão.  
- Todos os scripts recebem permissão automática de execução (`chmod +x`).  

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | CopyToGDriver_Installer.sh |
| **Versão** | 0.5.3 |
| **Autores** | Paulo SSPacheco + ChatGPT (GPT-5) |
| **Função** | Instala o sistema CopyToGDriver e configura o Rclone |
| **Data** | 01/11/2025 |

---

© 2025 Paulo SSPacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
