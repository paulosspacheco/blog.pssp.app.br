# 🚀 Guia do Usuário — CopyToGDriver Installer v2.2.4

---

## 📘 O que é o CopyToGDriver?
O **CopyToGDriver** é um conjunto de scripts que facilita o envio automático de arquivos e pastas do seu computador para o **Google Drive**.  
Este instalador (`CopyToGDriver_Installer.ps1`) prepara tudo para você no **Windows**, incluindo:

- Instalar e configurar o **Rclone** (ferramenta que faz o envio ao Google Drive)  
- Instalar o **Git Bash** (necessário para rodar os scripts em modo Linux no Windows)  
- Criar atalhos e comandos práticos no terminal  
- Adicionar a opção **“Send to Google Drive”** ao menu do clique direito no **Windows Explorer**  

Depois de instalado, você poderá usar comandos simples como `copydrive` para enviar arquivos ao seu Google Drive.

---

## 🧩 Como usar este instalador

1. **Baixe o instalador `CopyToGDriver_Installer.ps1`**  
   Coloque o arquivo em qualquer pasta do seu computador.

2. **Clique com o botão direito → Executar com PowerShell**  
   Ou abra o PowerShell e rode o comando:
   ```powershell
   powershell -ExecutionPolicy Bypass -File CopyToGDriver_Installer.ps1
   ```

3. O instalador mostrará o progresso passo a passo e criará o ambiente automaticamente.

4. Após a instalação, reinicie o **Git Bash** para ativar os novos comandos.

---

## ⚙️ Parâmetros disponíveis

Você pode personalizar a instalação com **parâmetros opcionais**.  
Esses parâmetros são digitados **após o nome do instalador** e começam com `--`.

### 🔹 Lista de parâmetros

| Parâmetro | Tipo | O que faz | Quando usar |
|------------|------|------------|--------------|
| `--auto-install-rclone` | Flag (sem valor) | Baixa e instala automaticamente o **Rclone** se ele não estiver instalado. | Use na primeira instalação. |
| `--auto-config-remote` | Flag (sem valor) | Cria e autentica automaticamente o **Google Drive** no Rclone (chamado de *remote gdriver*). | Use se quiser configurar o acesso ao Google Drive automaticamente. |
| `--auto-install-gitbash` | Flag (sem valor) | Instala o **Git Bash** automaticamente se ele não estiver presente. | Use se você nunca instalou o Git Bash. |
| `--path=<caminho>` | Texto | Define uma pasta personalizada onde o CopyToGDriver será instalado. | Use se não quiser instalar em `~/scripts/CopyToGDriver`. |
| `--silent` | Flag (sem valor) | Executa toda a instalação sem perguntar nada ao usuário. | Ideal para automação ou instalação corporativa. |

---

## 💡 Exemplos de uso

### 1️⃣ Instalação simples (modo padrão)
```powershell
powershell -ExecutionPolicy Bypass -File CopyToGDriver_Installer.ps1
```
👉 O script instalará o CopyToGDriver no caminho padrão `C:\Users\<usuário>\scripts\CopyToGDriver`  
Se o Rclone e o Git Bash já estiverem instalados, ele apenas configurará o sistema.

---

### 2️⃣ Instalação automática completa
```powershell
powershell -ExecutionPolicy Bypass -File CopyToGDriver_Installer.ps1 --auto-install-rclone --auto-install-gitbash --auto-config-remote
```
👉 Essa opção:
- Instala o **Rclone**
- Instala o **Git Bash** (se não houver)
- Configura automaticamente o acesso ao **Google Drive**

Sem necessidade de interação manual.

---

### 3️⃣ Instalação em um local personalizado
```powershell
powershell -ExecutionPolicy Bypass -File CopyToGDriver_Installer.ps1 --path="D:\Projetos\CopyToGDriver"
```
👉 Instala o sistema no diretório `D:\Projetos\CopyToGDriver` em vez do caminho padrão.

---

### 4️⃣ Instalação silenciosa (sem prompts)
```powershell
powershell -ExecutionPolicy Bypass -File CopyToGDriver_Installer.ps1 --silent --auto-install-rclone --auto-config-remote
```
👉 Ideal para uso em ambientes corporativos ou automação.  
Nenhum prompt será exibido; tudo é feito automaticamente.

---

## 🧠 Após a instalação

Depois que a instalação terminar, você poderá usar os seguintes comandos no **Git Bash**:

| Comando | Função |
|----------|--------|
| `copydrive` | Envia os arquivos da pasta atual para o Google Drive. |
| `copycheck` | Faz uma verificação dos arquivos que seriam enviados (sem enviar). |
| `copyrestore` | Recupera arquivos do Google Drive para a pasta local. |

Esses comandos são criados automaticamente no seu arquivo `~/.bashrc`.

---

## 🖱️ Opção no menu do Windows

O instalador também cria um atalho no menu do **clique direito** no Windows Explorer:  
🖱️ **Send to Google Drive** → envia o arquivo ou pasta clicado direto para seu Drive!

---

## 📄 Onde ficam os arquivos de instalação?

| Tipo | Caminho |
|------|----------|
| Pasta principal | `C:\Users\<usuário>\scripts\CopyToGDriver` |
| Configuração | `C:\Users\<usuário>\.copytogdriver` |
| Log de instalação | `install_log.txt` |
| Registro da instalação | `install_record.json` |

---

## 🔚 Como remover o CopyToGDriver

Para desinstalar completamente, execute o script:  
`CopyToGDriver_UnInstaller.ps1`  
Ele removerá todos os arquivos, variáveis e atalhos criados.

---

## ✅ Conclusão

O **CopyToGDriver Installer v2.2.4** foi feito para ser simples, seguro e automático.  
Mesmo sem conhecimento técnico, você pode configurar seu ambiente para enviar arquivos ao **Google Drive** em minutos.

---
**Autor:** Paulo SSPacheco + ChatGPT (GPT-5)  
**Versão documentada:** 2.2.4  
**Compatibilidade:** Windows 10+, PowerShell 5+, Git Bash 2.4+  
**Requisitos:** Conexão com a Internet e uma conta Google válida.
