# 📘 Documentação – alias_manager.sh (v1.2.0)

## 🧭 Descrição
O **alias_manager.sh** é um **gerenciador universal de aliases de terminal**, projetado para ambientes **Linux, macOS e Windows (Git Bash / WSL)**.  
Ele permite criar, remover e verificar aliases globais de forma automatizada e padronizada.

Pode ser usado:
- ✅ No projeto **CopyToGDriver**
- ✅ Ou em qualquer outro projeto open source / pessoal

---

## ⚙️ Funcionalidades

| Comando | Função |
|----------|--------|
| `--install` | Instala os aliases definidos no script |
| `--remove` | Remove aliases instalados |
| `--reinstall` | Remove e reinstala os aliases |
| `--check` | Verifica se os aliases estão configurados |
| `--help` | Mostra a ajuda detalhada |

---

## 🧩 Personalização

Edite o bloco abaixo dentro do script para ajustar os comandos ao seu projeto:

```bash
ALIASES=(
    "alias copydrive='bash \"$BASE_DIR/CopyToGDriver/CopyToGDriver_CopyCurrent.sh\"'"
    "alias copycheck='bash \"$BASE_DIR/CopyToGDriver/CopyToGDriver.sh\" --check-only'"
)
