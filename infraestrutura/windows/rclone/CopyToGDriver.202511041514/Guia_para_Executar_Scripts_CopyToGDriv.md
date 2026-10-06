# Guia para Executar Scripts CopyToGDriver no Windows

## 📋 Pré-requisitos

### Opção 1: Git Bash (Recomendado - Mais Simples)
1. **Baixe e instale o Git Bash**:
   - Acesse: https://git-scm.com/downloads/win
   - Instale com todas as opções padrão
   - **Importante**: Marque "Add Git Bash to PATH"

### Opção 2: WSL (Alternativa - 100% Compatível)
```bash
# No PowerShell como Administrador:
wsl --install -d Ubuntu
```

## 🔧 Instalação das Dependências

### 1. Instalar rclone no Windows
```bash
# Abra o Git Bash como Administrador (Botão direito → "Run as Administrator")

# Método 1: Via script oficial
curl https://rclone.org/install.sh | bash

# Método 2: Manual
# Baixe de https://rclone.org/downloads/
# Extraia rclone.exe para C:\Windows\System32\
```

### 2. Verificar instalação
```bash
rclone version
```

## 📁 Configuração dos Scripts

### 1. Preparar estrutura de diretórios
```bash
# No Git Bash:
mkdir -p /c/scripts/CopyToGDriver
cd /c/scripts/CopyToGDriver
```

### 2. Copiar os scripts
- Cole todos os arquivos `.sh` na pasta `C:\scripts\CopyToGDriver\`

### 3. Dar permissões de execução
```bash
chmod +x *.sh
```

## ⚙️ Adaptações Necessárias

### 1. Corrigir paths Linux → Windows
Edite os scripts substituindo:

**Antes (Linux):**
```bash
/home/usuario/
/mnt/
/media/
```

**Depois (Windows):**
```bash
/c/Users/SeuUsuario/
/c/
/d/
```

### 2. Adaptar comandos específicos

**No arquivo `CopyToGDriver_Cache.sh` (linhas com pgrep/pkill):**
```bash
# Substituir:
pkill rclone
pgrep rclone

# Por:
taskkill /f /im rclone.exe 2>/dev/null
tasklist | grep rclone.exe
```

**No arquivo `CopyToGDriver_Checks.sh` (detecção de discos):**
```bash
# Adicionar no início:
if [[ "$OSTYPE" == "msys" ]]; then
    # Windows: usar wmic para detectar discos
    mounted_disks=$(wmic logicaldisk where "drivetype=3" get deviceid | grep :)
else
    # Linux: comando original
    mounted_disks=$(mount | grep -E '/dev/sd|/dev/nvme' | awk '{print $1}')
fi
```

## 🚀 Execução

### 1. Primeira configuração
```bash
# No Git Bash como Administrador:
./CopyToGDriver_Installer.sh

# Pule qualquer comando com sudo
```

### 2. Configurar rclone
```bash
rclone config
```
Siga o assistente para conectar com Google Drive.

### 3. Testar sincronização
```bash
./CopyToGDriver_Sync.sh
```

## 🛠️ Solução de Problemas Comuns

### Erro: "sudo: command not found"
**Solução**: Execute o Git Bash como Administrador e remova `sudo` dos comandos.

### Erro: "pgrep: command not found"
**Solução**: Use as adaptações acima com `taskkill` e `tasklist`.

### Erro: Paths não encontrados
**Solução**: Verifique se os paths estão no formato Windows (`/c/Users/...`).

### Erro: Permissão negada
**Solução**: Execute como Administrador ou ajuste permissões:
```bash
chmod 755 *.sh
```

## 📝 Configuração de Alias (Opcional)

Adicione ao `~/.bashrc` no Git Bash:
```bash
alias copydrive='/c/scripts/CopyToGDriver/CopyToGDriver_Sync.sh'
alias drive-config='rclone config'
```

Recarregue:
```bash
source ~/.bashrc
```

## 🔄 Script de Adaptação Automática

Crie `fix_windows.sh`:
```bash
#!/bin/bash
echo "Aplicando adaptações para Windows..."

# Backup dos scripts originais
cp CopyToGDriver_Cache.sh CopyToGDriver_Cache.sh.backup
cp CopyToGDriver_Checks.sh CopyToGDriver_Checks.sh.backup

# Substituir pgrep/pkill
sed -i 's/pkill rclone/taskkill \/f \/im rclone.exe 2>\/dev\/null/g' CopyToGDriver_Cache.sh
sed -i 's/pgrep rclone/tasklist | grep rclone.exe/g' CopyToGDriver_Cache.sh

# Corrigir paths
sed -i 's/\/home\/usuario/\/c\/Users\/%USERNAME%/g' *.sh
sed -i 's/\/mnt\//\/c\//g' *.sh

echo "Adaptações aplicadas! Backup criado."
```

Execute:
```bash
chmod +x fix_windows.sh
./fix_windows.sh
```

## ✅ Verificação Final

Teste cada componente:
```bash
# 1. rclone
rclone about drive:

# 2. Scripts básicos
./CopyToGDriver_Checks.sh
./CopyToGDriver_Config.sh

# 3. Sincronização completa
./CopyToGDriver_Sync.sh
```

## 📞 Suporte

Se encontrar problemas:
1. Execute com debug: `bash -x CopyToGDriver_Sync.sh`
2. Verifique logs em `~/.copytogdriver/logs/`
3. Teste no WSL como alternativa

## 🏗️ Arquitetura Proposta

```
CopyToGDriver/
├── core/
│   ├── main_scripts.sh          # Script principal unificado
│   └── includes/                # Sistema de includes
│       ├── common_functions.sh  # Funções compatíveis com todas as plataformas
│       ├── linux/               # Implementações Linux
│       │   ├── disk_utils.sh
│       │   ├── process_utils.sh
│       │   └── path_utils.sh
│       └── windows/             # Implementações Windows
│           ├── disk_utils.sh
│           ├── process_utils.sh
│           └── path_utils.sh
└── platforms/
    ├── linux.sh                 # Loader Linux
    └── windows.sh               # Loader Windows
```

## 🔧 Implementação

### 1. **Script de Detecção de Plataforma** (`platform_detector.sh`)

```bash
#!/bin/bash

detect_platform() {
    case "$OSTYPE" in
        linux-gnu*)
            echo "linux"
            ;;
        darwin*)
            echo "macos"
            ;;
        msys*|cygwin*|win32*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

get_platform_include_path() {
    local platform=$(detect_platform)
    echo "$(dirname "$0")/includes/$platform"
}

# Exportar para uso em outros scripts
export PLATFORM=$(detect_platform)
export PLATFORM_INCLUDE_PATH=$(get_platform_include_path)
```

### 2. **Loader de Includes** (`include_loader.sh`)

```bash
#!/bin/bash

# Carregar detector de plataforma
source "$(dirname "$0")/platform_detector.sh"

# Função para carregar includes específicos da plataforma
load_platform_module() {
    local module_name=$1
    local platform_module="$PLATFORM_INCLUDE_PATH/${module_name}_utils.sh"
    
    if [[ -f "$platform_module" ]]; then
        source "$platform_module"
        return 0
    else
        echo "ERRO: Módulo $module_name não encontrado para plataforma $PLATFORM"
        return 1
    fi
}

# Função para carregar includes comuns
load_common_module() {
    local module_name=$1
    local common_module="$(dirname "$0")/includes/common/${module_name}.sh"
    
    if [[ -f "$common_module" ]]; then
        source "$common_module"
        return 0
    else
        echo "ERRO: Módulo comum $module_name não encontrado"
        return 1
    fi
}

# Carregar todos os módulos necessários
load_all_modules() {
    load_common_module "common_functions"
    load_common_module "logging"
    load_common_module "config"
    
    load_platform_module "disk"
    load_platform_module "process"
    load_platform_module "path"
    load_platform_module "network"
}
```

### 3. **Implementações Específicas por Plataforma**

#### **Linux** (`includes/linux/process_utils.sh`)

```bash
#!/bin/bash

kill_process() {
    local process_name=$1
    pkill "$process_name"
}

process_is_running() {
    local process_name=$1
    pgrep "$process_name" > /dev/null
}

get_process_info() {
    local process_name=$1
    ps aux | grep "$process_name" | grep -v grep
}
```

#### **Windows** (`includes/windows/process_utils.sh`)

```bash
#!/bin/bash

kill_process() {
    local process_name=$1
    taskkill /f /im "${process_name}.exe" 2>/dev/null
    return 0  # Sempre retorna sucesso, mesmo se processo não existir
}

process_is_running() {
    local process_name=$1
    tasklist /fi "imagename eq ${process_name}.exe" | findstr /i "${process_name}.exe" > /dev/null
}

get_process_info() {
    local process_name=$1
    tasklist /fi "imagename eq ${process_name}.exe"
}
```

#### **Linux** (`includes/linux/disk_utils.sh`)

```bash
#!/bin/bash

get_mounted_disks() {
    mount | grep -E '/dev/sd|/dev/nvme' | awk '{print $1}'
}

get_disk_space() {
    local path=$1
    df -h "$path" | awk 'NR==2 {print $4}'
}

get_disk_usage() {
    local path=$1
    du -sh "$path" 2>/dev/null | awk '{print $1}'
}
```

#### **Windows** (`includes/windows/disk_utils.sh`)

```bash
#!/bin/bash

get_mounted_disks() {
    wmic logicaldisk where "drivetype=3" get deviceid | grep : | tr -d ':'
}

get_disk_space() {
    local path=$1
    # Converter path Git Bash para Windows
    local win_path=$(echo "$path" | sed 's/^\///' | sed 's/\//\\/g' | sed 's/^\([a-z]\)\\/\1:\\/')
    wmic logicaldisk where "deviceid='${win_path:0:2}'" get size,freespace | awk 'NR==2 {print $2}'
}

get_disk_usage() {
    local path=$1
    du -sh "$path" 2>/dev/null | awk '{print $1}'
}
```

### 4. **Script Principal Atualizado** (`main_script.sh`)

```bash
#!/bin/bash

# Carregar sistema de includes
source "$(dirname "$0")/include_loader.sh"

# Inicializar módulos
load_all_modules

# Função principal
main() {
    log_info "Iniciando CopyToGDriver na plataforma: $PLATFORM"
    
    # Verificar dependências (agora multiplataforma)
    if ! check_dependencies; then
        log_error "Dependências não satisfeitas"
        exit 1
    fi
    
    # Verificar espaço em disco (usando implementação específica)
    local available_space=$(get_disk_space "/c")
    log_info "Espaço disponível: $available_space"
    
    # Parar processos rclone existentes (usando implementação específica)
    if process_is_running "rclone"; then
        log_warning "Processo rclone encontrado, parando..."
        kill_process "rclone"
    fi
    
    # Continuar com a sincronização...
    perform_sync
}

# Função de verificações de dependência unificada
check_dependencies() {
    local missing_deps=()
    
    # Verificar rclone
    if ! command -v rclone &> /dev/null; then
        missing_deps+=("rclone")
    fi
    
    # Verificar dependências específicas da plataforma
    if ! check_platform_dependencies; then
        return 1
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Dependências missing: ${missing_deps[*]}"
        return 1
    fi
    
    return 0
}

# Executar main
main "$@"
```

### 5. **Módulo Comum** (`includes/common/common_functions.sh`)

```bash
#!/bin/bash

# Funções que funcionam igual em todas as plataformas
normalize_path() {
    local path=$1
    echo "$path" | sed 's/\\/\//g'
}

generate_timestamp() {
    date +"%Y-%m-%d_%H-%M-%S"
}

validate_config() {
    local config_file=$1
    # Implementação comum de validação
    [[ -f "$config_file" ]] && return 0 || return 1
}
```

## 🎯 Vantagens Desta Abordagem

### ✅ **Vantagens:**
1. **Código Limpo**: Sem condicionais espalhados
2. **Manutenção Fácil**: Modificações por plataforma isoladas
3. **Extensível**: Adicionar nova plataforma = nova pasta de includes
4. **Testável**: Pode testar cada implementação isoladamente
5. **Reutilizável**: Outros projetos podem usar o mesmo sistema

### 🔧 **Como Usar:**

```bash
# No script principal, simplesmente:
source "$(dirname "$0")/include_loader.sh"
load_all_modules

# Usar funções (a implementação correta será chamada automaticamente)
kill_process "rclone"
get_mounted_disks
```

### 📁 **Estrutura Final Recomendada:**
```
project/
├── main.sh
├── platform_detector.sh
├── include_loader.sh
└── includes/
    ├── common/
    │   ├── common_functions.sh
    │   ├── logging.sh
    │   └── config.sh
    ├── linux/
    │   ├── disk_utils.sh
    │   ├── process_utils.sh
    │   └── path_utils.sh
    └── windows/
        ├── disk_utils.sh
        ├── process_utils.sh
        └── path_utils.sh
```

## 🚀 **Próximos Passos:**

1. **Criar a estrutura de diretórios**
2. **Migrar funções existentes** para os módulos apropriados
3. **Implementar as versões Windows** dos módulos críticos
4. **Atualizar scripts principais** para usar o novo sistema