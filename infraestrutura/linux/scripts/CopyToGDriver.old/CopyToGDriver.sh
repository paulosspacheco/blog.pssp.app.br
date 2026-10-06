#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Main.sh
# Função: Script principal que orquestra todos os módulos
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21
# ===========================================================

SCRIPT_DIR="$(dirname "$0")"

# ===========================================================
# 🔗 Importar todos os módulos
# ===========================================================
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"
source "$SCRIPT_DIR/CopyToGDriver_ConfigFunctions.sh"
source "$SCRIPT_DIR/CopyToGDriver_Checks.sh"
source "$SCRIPT_DIR/CopyToGDriver_Cache.sh"
source "$SCRIPT_DIR/CopyToGDriver_Sync.sh"

# ===========================================================
# ▶️ Execução principal
# ===========================================================
# Redireciona todos os parâmetros para a função main() do módulo Sync
# ===========================================================
main "$@"

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Main.sh
# ===========================================================
