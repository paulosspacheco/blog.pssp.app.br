Perfeito! Vou reformular todas as tabelas da documentação com alinhamento adequado para visualização em editores de texto comum.

**CopyToGDriver_7zSFX_Config.md**

```markdown
# 📋 CopyToGDriver_7zSFX_Config.txt - Documentação

## 📁 Informações do Arquivo

| Propriedade       | Valor                                 |
|-------------------|---------------------------------------|
| Nome do Arquivo   | `CopyToGDriver_7zSFX_Config.txt`      |
| Localização       | `include/packagers/windows/`          |
| Plataforma        | Windows                               |
| Versão            | 1.1.0                                 |
| Codificação       | UTF-8                                 |
| Função            | Configuração do instalador autoextraível 7-Zip SFX |

## 🎯 Propósito

Este arquivo configura o comportamento do instalador autoextraível do CopyToGDriver para Windows, definindo parâmetros de execução e interface para o módulo SFX do 7-Zip.

## 📝 Conteúdo do Arquivo

```txt
;!@Install@!UTF-8!
; ===========================================================
; CONFIGURAÇÃO 7-ZIP SFX - COPYTOGDRIVER
; Localização: include/packagers/windows/config.txt
; Plataforma: Windows
; Versão: 1.1.0
; ===========================================================

Title="CopyToGDriver - Instalador Multiplataforma"
RunProgram="powershell -ExecutionPolicy Bypass -File CopyToGDriver_PlatformInstaller.ps1"
;!@InstallEnd@!
```

## 🔧 Análise dos Parâmetros

### **Delimitadores da Seção SFX**

```txt
;!@Install@!UTF-8!
```
- **Função**: Inicia a seção de configuração do SFX
- **Formato**: UTF-8 (suporte a caracteres especiais)
- **Obrigatório**: Sim

```txt
;!@InstallEnd@!
```
- **Função**: Finaliza a seção de configuração do SFX
- **Obrigatório**: Sim

### **Comentários de Cabeçalho**

```txt
; ===========================================================
; CONFIGURAÇÃO 7-ZIP SFX - COPYTOGDRIVER
; Localização: include/packagers/windows/config.txt
; Plataforma: Windows
; Versão: 1.1.0
; ===========================================================
```

- **Formato**: Comentários com `;` (único formato aceito no SFX)
- **Função**: Documentação interna e metadados
- **Nota**: Comentários com `#` não são suportados

### **Parâmetro `Title`**

```txt
Title="CopyToGDriver - Instalador Multiplataforma"
```

| Propriedade | Descrição                               |
|-------------|-----------------------------------------|
| Função      | Define o título da janela do instalador |
| Valor       | String entre aspas                      |
| Exibição    | Barra de título da janela do SFX        |
| Exemplo     | `CopyToGDriver - Instalador Multiplataforma` |

### **Parâmetro `RunProgram`**

```txt
RunProgram="powershell -ExecutionPolicy Bypass -File CopyToGDriver_PlatformInstaller.ps1"
```

| Componente                  | Descrição                                           |
|-----------------------------|-----------------------------------------------------|
| `powershell`                | Invoca o PowerShell para execução de scripts        |
| `-ExecutionPolicy Bypass`   | Ignora políticas de execução restritivas           |
| `-File CopyToGDriver_PlatformInstaller.ps1` | Executa o script principal do instalador |

## 🚀 Fluxo de Execução

### **Sequência do Instalador:**
1. **Usuário executa** `CopyToGDriver_Setup.exe`
2. **SFX extrai** automaticamente todos os arquivos para diretório temporário
3. **Executa automaticamente** o comando definido em `RunProgram`
4. **PowerShell executa** `CopyToGDriver_PlatformInstaller.ps1`
5. **Dispatcher detecta** plataforma e inicia instalação adequada

### **Comportamento do SFX:**
- ✅ Extrai arquivos silenciosamente
- ✅ Executa comando automaticamente
- ✅ Fecha após conclusão do script
- ✅ Mostra título personalizado na janela

## ⚙️ Integração com o Build System

### **Arquivo `build.bat` relacionado:**
```batch
copy /b "7zS.sfx" + "CopyToGDriver_7zSFX_Config.txt" + "!TEMP_7Z!" "%DIST_DIR%\CopyToGDriver_Setup.exe"
```

### **Dependências:**
- `7zS.sfx` - Módulo autoextraível do 7-Zip
- `CopyToGDriver_PlatformInstaller.ps1` - Script dispatcher principal
- `build.bat` - Script de empacotamento

## 📁 Estrutura do Projeto

```
CopyToGDriver/
├── include/
│   └── packagers/
│       └── windows/
│           ├── 📄 7zS.sfx
│           ├── 📄 CopyToGDriver_7zSFX_Config.txt    ← Este arquivo
│           ├── 📄 build.bat
│           └── 📄 CopyToGDriver_PlatformInstaller.ps1
├── includes/
│   ├── windows/
│   ├── linux/
│   └── macos/
└── dist/
    └── 🎯 CopyToGDriver_Setup.exe                    ← Instalador gerado
```

## ⚠️ Considerações Importantes

### **Restrições Técnicas:**
- ❌ Comentários com `#` não funcionam dentro da seção SFX
- ✅ Apenas `;` é aceito para comentários
- ✅ Codificação UTF-8 obrigatória para caracteres especiais
- ✅ Caminhos relativos baseados na raiz do arquivo extraído

### **Segurança:**
- 🔒 `ExecutionPolicy Bypass` necessário para scripts não-assinados
- ⚠️ Usuário pode ver aviso de segurança do PowerShell
- ✅ Scripts são executados em contexto temporário

## 🔄 Versionamento

| Versão | Data    | Alterações                     |
|--------|---------|--------------------------------|
| 1.1.0  | 2024    | Nome específico do projeto     |
| 1.0.0  | 2024    | Versão inicial                 |

## 🛠️ Solução de Problemas

### **Erro Comum: Script não executa**
```txt
; Verificar se o caminho do arquivo está correto
RunProgram="powershell -ExecutionPolicy Bypass -File CopyToGDriver_PlatformInstaller.ps1"
```

### **Debug:**
1. Verificar se `CopyToGDriver_PlatformInstaller.ps1` está na raiz do .7z
2. Testar comando manualmente no PowerShell
3. Verificar políticas de execução do sistema

---

**📋 Arquivo:** `CopyToGDriver_7zSFX_Config.txt`  
**🏷️ Projeto:** CopyToGDriver  
**🔧 Tipo:** Configuração 7-Zip SFX  
**🐛 Mantenedor:** Equipe CopyToGDriver
```

Agora todas as tabelas estão perfeitamente alinhadas para visualização em editores de texto comum, terminal, ou qualquer visualizador Markdown! 🎯