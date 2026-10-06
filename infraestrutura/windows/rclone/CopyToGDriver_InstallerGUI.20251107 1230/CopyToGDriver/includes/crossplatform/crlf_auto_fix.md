# CRLF Protect - Proteção Centralizada contra CRLF

## 📋 Informações do Script

- **Projeto:** CopyToGDriver
- **Arquivo:** `crlf_protect.sh` (v1.0.0)
- **Função:** Proteção Centralizada contra CRLF (auto-correção)
- **Autor:** Paulo SSPacheco + ChatGPT (GPT-5)

## 🎯 Descrição

Esta função detecta e remove automaticamente caracteres CRLF (caracteres de final de linha de origem Windows) em scripts Bash executados em ambientes Unix-like (Linux ou macOS).

Isso evita erros comuns como:
- `bad interpreter: No such file or directory`
- `command not found` causados por `\r`

## 💡 Compatibilidade

- ✅ **Linux** - Aplica correção automaticamente
- ✅ **macOS** - Aplica correção automaticamente  
- ⚙️ **Windows** - Não aplica (apenas detecta e ignora)

## 🛡️ Função: `crlf_auto_fix`

### Fluxo de Execução

1. **Detecta o sistema operacional** via `uname -s`
2. **Se for Linux ou macOS**, continua a verificação
3. **Verifica se o script contém CRLF** usando `grep -q $'\r' "$0"`
4. **Se houver CRLF**, executa `sed -i 's/\r$//' "$0"` para remover os `\r`
5. **Reexecuta o script limpo** com `exec "$0" "$@"` (mantendo argumentos)
6. **Encerra o processo antigo** com `exit $?`

### Código da Função

```bash
crlf_auto_fix() {
    # 🔍 1. Verifica se o sistema é Linux ou macOS
    if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then

        # ⚙️ 2. Remove todos os caracteres CR (\r) do final das linhas
        sed -i 's/\r$//' "$0"

        # 🔁 3. Reexecuta o script com os mesmos argumentos
        exec "$0" "$@"

        # 🚪 4. Encerra o processo antigo imediatamente
        exit $?
    fi
}
```

## 🚀 Como Usar

### Incluir em Seus Scripts

Adicione estas linhas no **topo** de cada script Bash:

```bash
#!/bin/bash

# Inclui a proteção CRLF
source ./crlf_protect.sh

# Executa a verificação (PRIMEIRA instrução após includes)
crlf_auto_fix "$@"

# ... resto do seu código abaixo
```

### Exemplo Prático

```bash
#!/bin/bash
# meu_script.sh

source ./crlf_protect.sh
crlf_auto_fix "$@"

echo "✅ Script executando sem problemas de CRLF!"
# ... código principal do script
```

## 🔧 Comportamento

### No Linux/macOS com CRLF:
```
1. Script é executado (com CRLF)
2. Função detecta CRLF
3. Remove automaticamente os \r
4. Reexecuta o script limpo
5. Executa normalmente
```

### No Windows:
```
1. Script é executado
2. Função detecta Windows
3. Ignora a verificação
4. Continua execução normal
```

## 📝 Notas Importantes

- **Sempre coloque** `crlf_auto_fix "$@"` como **primeira instrução** após os includes
- Mantenha `crlf_protect.sh` no mesmo diretório ou ajuste o caminho no `source`
- A função é **totalmente transparente** - usuários nem percebem a correção
- **Não afeta performance** em sistemas onde não é necessário

## 🐛 Problemas Resolvidos

- ✅ Elimina `\r: command not found`
- ✅ Corrige `bad interpreter` errors  
- ✅ Permite edição cross-platform sem preocupações
- ✅ Mantém compatibilidade entre Windows e Unix

---

**🎉 Agora seus scripts são à prova de CRLF!**