# CrossPlatform Utils - Turbo Utilities for Cross-Platform Projects

## 📋 Informações do Script

- **Arquivo:** `crossplatform_utils.sh` 
- **Versão:** 2.2.0
- **Compatibilidade:** Linux, macOS, Windows (Git Bash/WSL)
- **Projeto:** CopyToGDriver
- **Função:** Biblioteca definitiva para projetos multiplataforma

## 🚀 Descrição Turbo

Biblioteca completa que oferece funções para auto-correção de CRLF, detecção de SO, normalização de caminhos e validação de ambiente. Garante que seus scripts funcionem em qualquer sistema operacional!

## ⚡ Funcionalidades Turbo

- ✅ Auto-detecção e correção de CRLF
- ✅ Normalização inteligente de caminhos  
- ✅ Validação de dependências cross-platform
- ✅ Logging colorido e informativo
- ✅ Backup automático de arquivos
- ✅ Resolução de caminhos absolutos

## 🎯 Como Usar

```bash
source ./crossplatform_utils.sh
auto_fix_current_script "$@"  # ← ADICIONE ESTA LINHA no topo dos seus scripts
```

---

## 🛡️ Proteção CRLF Automática

O script inclui proteção embutida contra problemas de CRLF:

```bash
# 🛡️ Proteção CRLF (5 linhas mágicas)
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi
```

---

## 🧠 Funções Core Turbo

### `detect_os_type` - Detecção avançada de SO

Detecta o sistema operacional de forma inteligente, incluindo WSL.

**Saídas possíveis:** `Linux`, `macOS`, `Windows`, `WSL`, `BSD`, `Unknown`

```bash
os_type=$(detect_os_type)
echo "Sistema: $os_type"
```

### `turbo_log` - Logging colorido turbo

Exibe mensagens coloridas com timestamp e níveis de log.

**Níveis:** `ERROR`, `SUCCESS`, `WARNING`, `INFO`, `DEBUG`, `TURBO`

```bash
turbo_log "SUCCESS" "Operação concluída com sucesso"
turbo_log "ERROR" "Falha na execução"
```

### `normalize_path` - Normalização inteligente de caminhos

Converte caminhos entre formatos Windows ↔ Unix.

```bash
normalize_path "C:\Users\Documentos"
# → /c/Users/Documentos

normalize_path "C:/Windows/System32"  
# → /c/Windows/System32
```

---

## 🛡️ Funções de Proteção CRLF Turbo

### `check_and_fix_crlf` - Verificação e correção turbo de CRLF

Verifica e corrige arquivos com CRLF usando múltiplos métodos de detecção.

```bash
check_and_fix_crlf "./meuscript.sh"
# [WARNING] CRLF detectado (file command) em: meuscript.sh
# [INFO] Backup criado: meuscript.sh.crlf.bak
# [SUCCESS] Conversão LF concluída: meuscript.sh
```

**Métodos de detecção:**
- `file command` - Mais preciso
- `grep` - Fallback básico  
- `hexdump` - Ultra preciso

### `auto_fix_current_script` - Auto-correção turbo do script atual

Corrige o script em execução automaticamente se necessário.

```bash
#!/bin/bash
source ./crossplatform_utils.sh
auto_fix_current_script "$@"  # ← PRIMEIRA instrução

# Seu código abaixo...
```

### `fix_project_scripts` - Correção em lote turbo

Corrige todos os scripts `.sh` de um projeto.

```bash
fix_project_scripts "./meu_projeto"
# [SUCCESS] Concluído! Verificados: 15 | Corrigidos: 3
```

---

## 🔍 Funções de Validação Turbo

### `validate_dependencies` - Valida dependências cross-platform

Verifica comandos essenciais e sugere instalação específica por SO.

```bash
validate_dependencies "curl" "git" "python3" "docker"
```

**Saída exemplo:**
```
[INFO] Validando dependências para: Linux
[DEBUG] ✅ curl
[WARNING] Dependência não encontrada: docker
[INFO] No Debian/Ubuntu tente: sudo apt install docker
```

### `get_script_directory` - Diretório do script (cross-platform)

Retorna o caminho absoluto do diretório do script atual.

```bash
script_dir=$(get_script_directory)
echo "Executando de: $script_dir"
```

---

## 📍 Função Adicional: `resolve_path`

### Resolução de caminhos absolutos cross-platform

Converte caminhos relativos em absolutos, compatível com Linux, macOS e WSL.

```bash
resolve_path "./docs"
# → /home/paulo/docs

resolve_path "../CopyToGDriver"  
# → /v/LazarusProjects/CopyToGDriver_InstallerGUI/CopyToGDriver
```

**Métodos utilizados:**
- `readlink -f` - Linux/WSL
- `perl -MCwd` - macOS (fallback)
- Fallback padrão se necessário

```bash
local abs_path
abs_path=$(resolve_path "$1")
echo "Caminho absoluto: $abs_path"
```

---

## 🎪 Demonstração e Ajuda

### `demo_crossplatform` - Demonstração interativa

Mostra todas as capacidades da biblioteca de forma prática.

```bash
./crossplatform_utils.sh
# Pergunta: "Executar demonstração interativa? (s/N)"
```

### `show_usage` - Ajuda integrada

Exibe instruções resumidas de uso.

```bash
source ./crossplatform_utils.sh
show_usage
```

**Modo CLI disponível:**
```bash
./crossplatform_utils.sh --help      # Mostra ajuda
./crossplatform_utils.sh             # Mostra ajuda e pergunta sobre demo
```

---

## 💡 Dicas Turbo para Desenvolvimento Multiplataforma

### 🚀 Melhores Práticas:

1. **Sempre use** `#!/bin/bash` (não `#!/bin/sh`)
2. **Use** `source` em vez de `.` para melhor compatibilidade
3. **Teste** caminhos com espaços e caracteres especiais
4. **Use** `[[ ]]` em vez de `[ ]` para condicionais
5. **Sempre normalize** caminhos de entrada

### 🐛 Problemas Comuns:

| Problema | Solução |
|----------|---------|
| CRLF no Linux | `auto_fix_current_script` |
| Caminhos Windows | `normalize_path` |
| Permissões de execução | `chmod +x seus_scripts` |
| Encoding | Use UTF-8 sem BOM |

### 🔧 Comandos Úteis:

- `file meuscript.sh` - Verifica encoding
- `dos2unix` - Conversão manual (se disponível)  
- `hexdump -C` - Análise hexadecimal

---

## 🧪 Exemplo de Uso Prático

```bash
#!/bin/bash
# meu_script_turbo.sh

source ./crossplatform_utils.sh
auto_fix_current_script "$@"

echo "🧩 CrossPlatform Utils carregado!"
echo "📋 Sistema: $(detect_os_type)"
echo "📁 Diretório: $(get_script_directory)"

# Normalizar caminho de entrada
input_path=$(normalize_path "$1")
echo "🔧 Caminho normalizado: $input_path"

# Validar dependências
validate_dependencies "curl" "git" "jq"

# Verificar espaço em disco
available_gb=$(get_disk_space_gb "$input_path")
echo "💾 Espaço livre: ${available_gb}GB"

echo "✅ Script turbo funcionando em qualquer plataforma! 🎉"
```

---

## 🎉 Conclusão

Com **CrossPlatform Utils v2.2.0**, seus scripts Bash tornam-se:

- ✅ **Auto-corretivos** - Protegidos contra CRLF
- ✅ **Multiplataforma** - Funcionam em Windows, Linux, macOS
- ✅ **Robustos** - Validação completa de ambiente
- ✅ **Profissionais** - Logging e tratamento de erros
- ✅ **Manuteníveis** - Código organizado e documentado

**🎯 Escreva uma vez, execute em qualquer sistema!**

> *"Seu projeto agora é Turbo Multiplataforma!"* 🚀