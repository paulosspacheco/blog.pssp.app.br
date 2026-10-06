# 🏗️ Script de Empacotamento Windows - CopyToGDriver

## 📁 Arquivo: `build.bat`

### 🎯 Propósito
Script automatizado para criar o instalador autoextraível do CopyToGDriver para Windows usando 7-Zip SFX.

### 📋 Estrutura do Projeto
```
CopyToGDriver/
├── includes/                   ← Scripts por plataforma
│   ├── windows/
│   │   ├── CopyToGDriver_Installer.ps1
│   │   └── CopyToGDriver_UnInstaller.ps1
│   ├── linux/
│   └── macos/
├── packagers/                  ← Sistema de empacotamento
│   └── windows/
│       ├── 🏗️ build.bat                    ← Este script
│       ├── ⚙️ 7zS.sfx                      ← Módulo SFX
│       ├── 📋 CopyToGDriver_7zSFX_Config.txt ← Configuração
│       └── 🔄 CopyToGDriver_PlatformInstaller.ps1 ← Dispatcher
├── docs/                       ← Documentação
├── src/                        ← Código fonte
└── dist/                       ← Instalador gerado
    └── CopyToGDriver_Setup.exe
```

### 📋 Pré-requisitos
| Componente | Descrição | Localização |
|------------|-----------|-------------|
| **7-Zip** | Instalado no PATH | Sistema |
| **7zS.sfx** | Módulo SFX do 7-Zip | `packagers/windows/` |
| **CopyToGDriver_7zSFX_Config.txt** | Configuração SFX | `packagers/windows/` |
| **CopyToGDriver_PlatformInstaller.ps1** | Dispatcher principal | `packagers/windows/` |
| **Pasta includes/** | Scripts específicos por plataforma | Raiz do projeto |

### 🚀 Uso
```cmd
cd packagers\windows
build.bat
```

### 🔧 Funcionalidades
- ✅ **Verificação completa** de pré-requisitos
- ✅ **Compactação inteligente** do projeto
- ✅ **Criação automática** do instalador SFX
- ✅ **Relatório detalhado** do build
- ✅ **Limpeza automática** de arquivos temporários

### 📦 Exclusões da Compactação
- `.git/` - Controle de versão
- `dist/` - Builds anteriores  
- `node_modules/` - Dependências Node.js
- `__pycache__/` - Cache Python
- Arquivos temporários e de build

### 🎯 Saída do Build
| Arquivo | Localização | Descrição |
|---------|-------------|-----------|
| `CopyToGDriver_Setup.exe` | `dist/` | Instalador final |
| **Tamanho** | Otimizado | Compressão máxima (-mx=9) |
| **Hash MD5** | Gerado automaticamente | Para verificação |

### ⚠️ Solução de Problemas

#### **Erro: 7-Zip não encontrado**
```cmd
where 7z
```
**Solução:** Instale o [7-Zip](https://www.7-zip.org/) e adicione ao PATH.

#### **Erro: Arquivos faltando**
```cmd
cd packagers\windows
dir 7zS.sfx
dir CopyToGDriver_7zSFX_Config.txt  
dir CopyToGDriver_PlatformInstaller.ps1
```
**Solução:** Certifique-se que todos os arquivos estão em `packagers/windows/`

#### **Erro: Estrutura includes/**
```cmd
dir ..\..\includes\windows\
```
**Solução:** Verifique se a pasta `includes/` existe na raiz com as subpastas de plataforma.

### 🔄 Fluxo de Execução

1. **Desenvolvedor** executa `packagers/windows/build.bat`
2. **Script** verifica todos os pré-requisitos
3. **Compacta** todo o projeto (exceto exclusões)
4. **Cria** instalador SFX com configuração personalizada
5. **Gera** `dist/CopyToGDriver_Setup.exe`
6. **Relatório** com tamanho e hash MD5

### 📊 Conteúdo do Instalador
- 🏠 `CopyToGDriver_PlatformInstaller.ps1` - Dispatcher multiplataforma
- 🪟 `/includes/windows/` - Scripts de instalação Windows
- 🐧 `/includes/linux/` - Scripts de instalação Linux  
-  `/includes/macos/` - Scripts de instalação macOS
- 📚 `/docs/` - Documentação completa
- 🔧 `/packagers/` - Sistema de empacotamento

### 🚀 Instalação pelo Usuário Final

1. **Execute** `CopyToGDriver_Setup.exe`
2. **SFX** extrai arquivos automaticamente
3. **Executa** `CopyToGDriver_PlatformInstaller.ps1`
4. **Dispatcher** detecta a plataforma
5. **Copia** scripts corretos da pasta `includes/`
6. **Inicia** instalação específica da plataforma

---

**📁 Localização:** `packagers/windows/build.bat`  
**🔧 Função:** Empacotamento Windows  
**✅ Status:** Pronto para uso