# 📘 Documentação – `CopyToGDriver.sh` (v0.2.1)

## 🧭 Descrição geral

O script **`CopyToGDriver.sh`** é o **núcleo orquestrador** do projeto **CopyToGDriver**.
Ele é responsável por **detectar automaticamente o sistema operacional**, **carregar os módulos corretos** (crossplatform, Windows, Linux ou macOS), e **executar a rotina principal** de sincronização de arquivos.

Essa arquitetura modular e multiplataforma garante que o projeto funcione de forma consistente em **Windows (via Git Bash/WSL)**, **Linux** e **macOS**, sem precisar editar o código para cada ambiente.

---

## ⚙️ Função principal

> “Carregar dinamicamente o ambiente correto e orquestrar os módulos essenciais do CopyToGDriver.”

O script:

1. **Corrige CRLF automaticamente** em ambientes Unix (evitando falhas de execução);
2. **Detecta a plataforma** (Linux, macOS, Windows);
3. **Carrega bibliotecas crossplatform e específicas da plataforma**;
4. **Verifica a integridade dos módulos obrigatórios**;
5. **Executa o fluxo principal (`main`)** definido nos módulos;
6. **Oferece modo de diagnóstico (--check-only)**.

---

## 🧩 Estrutura funcional

### 1. Cabeçalho e metadados

Contém informações sobre:

* Projeto, módulo e função;
* Autor, versão e descrição;
* Indica que é **multiplataforma**.

### 2. Proteção CRLF

Bloco de 5 linhas que garante execução correta em Linux/macOS mesmo que o script tenha sido salvo com quebras de linha do Windows (`\r\n`).

```bash
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi
```

---

### 3. Detecção da plataforma

Detecta automaticamente o ambiente e armazena o resultado em `$PLATFORM`.

| Sistema                 | Valor atribuído |
| ----------------------- | --------------- |
| Linux                   | `linux`         |
| macOS                   | `macos`         |
| Git Bash / WSL / Cygwin | `windows`       |
| Outro                   | `unknown`       |

---

### 4. Normalização de caminhos (`normalize_path`)

Ajusta caminhos automaticamente entre sistemas:

* Converte `/c/Users/...` para `C:\Users\...` em Windows;
* Retorna o caminho inalterado em Linux/macOS.

---

### 5. Includes principais

O script carrega **módulos universais e específicos da plataforma**:

| Include                     | Caminho                   | Função                                                   |
| --------------------------- | ------------------------- | -------------------------------------------------------- |
| 🧠 `crossplatform_utils.sh` | `includes/crossplatform/` | Funções de detecção, logging, path e dependências        |
| 🛡️ `crlf_protect.sh`       | `includes/crossplatform/` | Corrige CRLF e reinicia execução                         |
| 🌍 `platform_loader.sh`     | `includes/crossplatform/` | Carrega módulos corretos por sistema operacional         |
| 💽 `disk_utils.sh`          | `includes/crossplatform/` | Gerencia espaço e uso de disco                           |
| 🪟 `path_utils.sh`          | `includes/windows/`       | Conversão de caminhos Windows ↔ Git Bash                 |
| ⚙️ `platform_detector.sh`   | Raiz do projeto           | Detecta e define variáveis do ambiente                   |
| 🔗 `include_loader.sh`      | Raiz do projeto           | Responsável por inicializar todos os includes principais |

---

### 6. Verificação de dependências

A função `verify_dependencies` confirma se todos os módulos obrigatórios do projeto estão presentes:

| Módulo          | Nome do arquivo                    |
| --------------- | ---------------------------------- |
| Utils           | `CopyToGDriver_Utils.sh`           |
| Config          | `CopyToGDriver_Config.sh`          |
| ConfigFunctions | `CopyToGDriver_ConfigFunctions.sh` |
| Checks          | `CopyToGDriver_Checks.sh`          |
| Cache           | `CopyToGDriver_Cache.sh`           |
| Setup           | `CopyToGDriver_Setup.sh`           |
| Sync            | `CopyToGDriver_Sync.sh`            |

Caso algum módulo esteja ausente, o script exibe uma mensagem de erro e finaliza a execução.

---

### 7. Modo de verificação (`--check-only`)

Permite testar a integridade da instalação sem executar sincronização:

```bash
./CopyToGDriver.sh --check-only
```

Saída esperada:

```
🔍 Verificando módulos do CopyToGDriver...
✅ Todas as dependências foram verificadas com sucesso!
✅ Verificação concluída. Nenhuma sincronização executada.
```

---

### 8. Execução principal

Após carregar todos os módulos, o script:

* Localiza a função `main`;
* Executa `main "$@"` com os parâmetros originais.

Se `main` não for encontrada, exibe um erro informando para verificar `CopyToGDriver_Sync.sh`.

---

### 9. Debug opcional

O script inclui variáveis de debug comentadas, que podem ser ativadas para diagnóstico rápido:

```bash
# echo "DEBUG: PLATFORM=$PLATFORM"
# echo "DEBUG: SCRIPT_DIR=$SCRIPT_DIR"
# echo "DEBUG: Includes carregados com sucesso."
```

---

## 🧪 Exemplo de uso

### Execução normal:

```bash
./CopyToGDriver.sh
```

### Verificação de módulos:

```bash
./CopyToGDriver.sh --check-only
```

### Execução forçada em Windows (Git Bash):

```bash
bash CopyToGDriver.sh
```

---

## 💡 Requisitos e compatibilidade

| Requisito                | Descrição                         |
| ------------------------ | --------------------------------- |
| `bash >= 4.0`            | Shell mínimo suportado            |
| `df`, `du`, `awk`, `sed` | Utilitários nativos de Unix       |
| `wmic` (opcional)        | Para leitura de discos no Windows |
| `Git Bash` / `WSL`       | Para execução no Windows          |

---

## 🧱 Estrutura recomendada do projeto

```
CopyToGDriver/
├── CopyToGDriver.sh               ← Script principal (este)
├── CopyToGDriver_Utils.sh
├── CopyToGDriver_Config.sh
├── CopyToGDriver_Sync.sh
├── includes/
│   ├── crossplatform/
│   │   ├── crossplatform_utils.sh
│   │   ├── crlf_protect.sh
│   │   ├── platform_loader.sh
│   │   ├── disk_utils.sh
│   ├── windows/
│   │   ├── path_utils.sh
│   ├── linux/
│   │   ├── (opcional)
│   ├── macos/
│   │   ├── (opcional)
```

---

## 🧩 Histórico de versões

| Versão    | Data                   | Alterações                                                    |
| --------- | ---------------------- | ------------------------------------------------------------- |
| 0.1.0     | Inicial                | Estrutura básica e verificação de módulos                     |
| 0.2.0     | Prévia multiplataforma | Adicionada detecção automática e `normalize_path`             |
| **0.2.1** | Atual                  | Inclusões automáticas, proteção CRLF e crossplatform completo |

---

## 🧠 Próximos passos recomendados

1. Criar o arquivo `includes/crossplatform/platform_loader.sh` (v1.0.0)
   → Responsável por escolher automaticamente os módulos corretos de cada SO.

2. Padronizar a função `main` dentro de `CopyToGDriver_Sync.sh`.

3. Criar `CopyToGDriver_Installer.sh` com integração automática e autodetecção de plataforma (baseado neste mesmo modelo).

---

