# 📘 Documentação do Script CopyToGDriver.v0.2.0.sh

## 🧩 Visão Geral

O script **CopyToGDriver.sh** é o **módulo orquestrador principal** do projeto **CopyToGDriver**.  
Ele é responsável por detectar o sistema operacional, carregar os módulos auxiliares e executar o processo de sincronização completo entre pastas locais e o Google Drive (via `rclone`).

---

## ⚙️ Estrutura e Fluxo Geral

O fluxo principal do script é dividido nas seguintes etapas:

1. **Detectar o diretório base** do script.  
2. **Identificar a plataforma** (Linux, macOS ou Windows).  
3. **Normalizar caminhos** para compatibilidade entre sistemas.  
4. **Carregar scripts auxiliares** (`platform_detector.sh`, `include_loader.sh`).  
5. **Inicializar e verificar módulos** do sistema (`Utils`, `Config`, `Sync`, etc.).  
6. **Executar o módulo principal de sincronização** (`main()` em `CopyToGDriver_Sync.sh`).  

---

## 🔧 Variáveis Principais

| Variável | Descrição | Valor / Origem |
|-----------|------------|----------------|
| `SCRIPT_DIR` | Diretório onde o script está localizado. | Detectado automaticamente |
| `PLATFORM` | Plataforma atual (linux, macos, windows). | Detectada via `uname -s` |
| `mod_file` | Caminho de cada módulo carregado. | `${SCRIPT_DIR}/CopyToGDriver_<mod>.sh` |

---

## 🧠 Funções Internas

### `detect_platform()`
Detecta automaticamente o sistema operacional e define a variável `PLATFORM`.  
Retornos possíveis:
- `linux`
- `macos`
- `windows`
- `unknown`

Exemplo de uso:
```bash
PLATFORM=$(detect_platform)
```

---

### `normalize_path(path)`
Normaliza um caminho de arquivo de acordo com o sistema operacional.  
- Em **Windows**, converte caminhos do formato `/c/Users/...` para `C:\Users\...`  
- Em **Linux/macOS**, mantém o formato original.

Exemplo:
```bash
normalize_path "/c/Users/Paulo/docs"
# Saída: C:\Users\Paulo\docs
```

---

### `verify_dependencies()`
Verifica a existência de todos os módulos obrigatórios do CopyToGDriver.  
Caso algum esteja ausente, exibe um erro e encerra a execução.

Módulos obrigatórios:
- `CopyToGDriver_Utils.sh`
- `CopyToGDriver_Config.sh`
- `CopyToGDriver_ConfigFunctions.sh`
- `CopyToGDriver_Checks.sh`
- `CopyToGDriver_Cache.sh`
- `CopyToGDriver_Setup.sh`
- `CopyToGDriver_Sync.sh`

Exemplo de uso isolado:
```bash
./CopyToGDriver.sh --check-only
```

---

### Carregamento de Módulos

Os módulos são carregados dinamicamente com base em seus nomes.  
O script utiliza `source` para incluir cada módulo, permitindo reutilização e modularidade.

```bash
for mod in Utils Config ConfigFunctions Checks Cache Setup Sync; do
    source "$SCRIPT_DIR/CopyToGDriver_${mod}.sh"
done
```

Caso um módulo não seja encontrado, é exibido um aviso, mas o processo continua se possível.

---

### Execução Principal

A execução principal é delegada à função `main()`, definida no módulo `CopyToGDriver_Sync.sh`.  
O script verifica se a função `main` está disponível antes de chamá-la:

```bash
if declare -f main >/dev/null; then
    main "$@"
else
    echo "❌ ERRO: Função 'main' não encontrada."
    exit 1
fi
```

---

## 🧰 Parâmetros Suportados

| Parâmetro | Descrição |
|------------|------------|
| `--check-only` | Apenas verifica os módulos e dependências, sem executar sincronização. |
| *(demais parâmetros)* | São repassados ao módulo principal (`CopyToGDriver_Sync.sh`). |

---

## 🧾 Estrutura Modular do Projeto

```
CopyToGDriver/
├── CopyToGDriver.sh                # Script principal (orquestrador)
├── platform_detector.sh            # Detector de plataforma
├── include_loader.sh               # Carregador de módulos
├── CopyToGDriver_Utils.sh          # Funções utilitárias
├── CopyToGDriver_Config.sh         # Configurações base
├── CopyToGDriver_ConfigFunctions.sh# Parser de parâmetros
├── CopyToGDriver_Checks.sh         # Verificações de ambiente
├── CopyToGDriver_Cache.sh          # Gerenciamento de cache
├── CopyToGDriver_Setup.sh          # Instalação e inicialização
└── CopyToGDriver_Sync.sh           # Execução da sincronização principal
```

---

## 💡 Funcionalidades de Segurança e Robustez

- ✅ Detecção automática de plataforma  
- ✅ Execução multiplataforma (Windows/Linux/macOS)  
- ✅ Verificação de dependências antes da execução  
- ✅ Carregamento modular dinâmico  
- ✅ Modo de verificação sem execução (`--check-only`)  
- ✅ Logs centralizados via `log_info()`  

---

## 🧰 Exemplo de Uso

```bash
# Verificar módulos e dependências apenas
./CopyToGDriver.sh --check-only

# Executar sincronização completa
./CopyToGDriver.sh --local-folder ./docs --remote-folder backups/docs
```

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | CopyToGDriver.sh |
| **Versão** | 0.2.0 |
| **Autores** | Paulo SSPacheco + ChatGPT (GPT-5) |
| **Data** | 01/11/2025 |
| **Licença** | Uso pessoal / interno |

---

© 2025 Paulo SSPacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
