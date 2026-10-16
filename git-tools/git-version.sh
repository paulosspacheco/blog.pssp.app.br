#!/bin/bash
# =============================================================================
# git-version.sh — Atualização automática de versão do projeto + Pascal
# =============================================================================
# Versão: 0.1.0
# Data:   2026-10-08
#
# Objetivo da versão:
#   - version-pas.inc só é gerado quando a pasta é um projeto Pascal/Lazarus
#     (*.lpi, *.lpr, *.lpk ou *.dpr até 2 níveis de profundidade)
#   - Atualiza também a versão em package.json, pyproject.toml, Cargo.toml,
#     gradle.properties e pubspec.yaml, quando existirem na pasta
#   - Pasta sem linguagem reconhecida não recebe nenhum arquivo de versão
#   - Demais comportamentos mantidos como na versão anterior
#
# Observações de uso:
#   - Executar na raiz do repositório, que deve conter .git e .gitproject
#   - .gitproject precisa ter a linha VERSION=x.y.z
#   - Requer /usr/local/bin/git-lib.sh (instalado pelo git-install.sh)
#   - feat: sobe MINOR, fix: sobe PATCH, feat! sobe MAJOR
#   - Só altera arquivos de linguagem que já tenham campo de versão;
#     versão dinâmica (ex.: setuptools_scm) é preservada
#   - Um arquivo version-pas.inc já existente em pasta sem projeto Pascal
#     não é apagado; deve ser removido manualmente (git rm version-pas.inc)
#   - Usa sed do GNU (Linux)
# =============================================================================

# =============================================================================
# CORREÇÃO PARA NEMO/NAUTILUS/DOLPHIN - Propagar variáveis de display
# =============================================================================
# Garante que zenity funcione quando executado por gerenciadores de arquivos
export DISPLAY="${DISPLAY:-:0}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# Se ainda assim não funcionar, tenta usar o display padrão
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi
# =============================================================================

source "/usr/local/bin/git-lib.sh"
load_config

# =============================================================================
# Arquivos de versão por linguagem
# =============================================================================
VERSION_FILES=(package.json pyproject.toml Cargo.toml gradle.properties pubspec.yaml)
GENERATED_FILES=()

is_pascal_project() {
  [ -n "$(find . -maxdepth 2 -not -path './.git/*' \( -name '*.lpi' -o -name '*.lpr' -o -name '*.lpk' -o -name '*.dpr' \) -print -quit)" ]
}

version_pattern() {
  case "$1" in
    package.json)              echo '"version"[[:space:]]*:[[:space:]]*"[^"]*"' ;;
    pyproject.toml|Cargo.toml) echo '^version[[:space:]]*=[[:space:]]*"[^"]*"' ;;
    gradle.properties)         echo '^version[[:space:]]*=.*' ;;
    pubspec.yaml)              echo '^version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+' ;;
  esac
}

version_replacement() {
  case "$1" in
    package.json)              echo "\"version\": \"$2\"" ;;
    pyproject.toml|Cargo.toml) echo "version = \"$2\"" ;;
    gradle.properties)         echo "version=$2" ;;
    pubspec.yaml)              echo "version: $2" ;;
  esac
}

# =============================================================================
# Função para gerar version-pas.inc (incorporada do version-pas-inc.sh)
# e atualizar os arquivos de versão das demais linguagens
# =============================================================================
generate_version_files() {
  local version="$1"
  local build_date=$(date "+%Y-%m-%d %H:%M:%S")
  local f

  GENERATED_FILES=()

  if is_pascal_project; then
    echo ""
    echo "🔧 Gerando version-pas.inc para Pascal/Lazarus..."

    # Gera o arquivo
    cat > version-pas.inc <<EOF
const
  VERSION_STR = '$version';
  BUILD_DATE  = '$build_date';
EOF
    GENERATED_FILES+=(version-pas.inc)
  fi

  for f in "${VERSION_FILES[@]}"; do
    [ -f "$f" ] || continue
    grep -Eq "$(version_pattern "$f")" "$f" || continue
    echo ""
    echo "🔧 Atualizando versão em $f..."
    sed -E -i "0,/$(version_pattern "$f")/s//$(version_replacement "$f" "$version")/" "$f"
    GENERATED_FILES+=("$f")
  done

  [ ${#GENERATED_FILES[@]} -eq 0 ] && return 0

  # Adiciona ao Git
  git add "${GENERATED_FILES[@]}"

  # Verifica se houve mudança antes de commitar
  if ! git diff --cached --quiet -- "${GENERATED_FILES[@]}"; then
    if git commit -m "chore: update ${GENERATED_FILES[*]} to v$version"; then
      echo "  ✔ ${GENERATED_FILES[*]} gerado e commitado"
    else
      echo "  ⚠ Falha no commit do ${GENERATED_FILES[*]}"
    fi
  else
    echo "  ℹ ${GENERATED_FILES[*]} já está atualizado"
  fi

  echo "     Versão: $version"
  echo "     Data:   $build_date"
}

# =============================================================================
# Script principal
# =============================================================================

if [ ! -d ".git" ]; then
  # Usar notify_error se disponível, ou zenity diretamente
  if command -v zenity >/dev/null 2>&1; then
    zenity --error --title="Git Tools" --text="Nenhum repositório Git encontrado.\n\nExecute git-ini.sh primeiro." --width=380
  else
    echo "❌ Nenhum repositório Git encontrado. Execute git-ini.sh primeiro." >&2
  fi
  exit 1
fi

if [ -z "$VERSION" ]; then
  if command -v zenity >/dev/null 2>&1; then
    zenity --error --title="Git Tools" --text="VERSION não definida em .gitproject" --width=380
  else
    notify_info "❌ VERSION não definida em .gitproject"
  fi
  exit 1
fi

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)

if [ -z "$LAST_TAG" ]; then
  notify_info "ℹ Nenhuma tag encontrada — analisando todos os commits"
  COMMITS=$(git log --pretty=format:"%s" 2>/dev/null)
  IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"
else
  COMMITS=$(git log "${LAST_TAG}..HEAD" --pretty=format:"%s" 2>/dev/null)
  IFS='.' read -r MAJOR MINOR PATCH <<< "${LAST_TAG#v}"
fi

if [ -z "$COMMITS" ]; then
  notify_info "⚠ Nenhum commit novo desde v$VERSION — versão mantida"
  generate_version_files "$VERSION"
  exit 0
fi

BUMP_MAJOR=0
BUMP_MINOR=0
BUMP_PATCH=0

while read -r line; do
  if [[ "$line" == *"feat!"* ]]; then
    BUMP_MAJOR=1
  elif [[ "$line" == feat:* ]]; then
    BUMP_MINOR=1
  elif [[ "$line" == fix:* ]]; then
    BUMP_PATCH=1
  fi
done <<< "$COMMITS"

if [ $BUMP_MAJOR -eq 1 ]; then
  ((MAJOR++)); MINOR=0; PATCH=0
elif [ $BUMP_MINOR -eq 1 ]; then
  ((MINOR++)); PATCH=0
elif [ $BUMP_PATCH -eq 1 ]; then
  ((PATCH++))
else
  notify_info "⚠ Nenhum commit relevante (feat/fix) — versão mantida: $MAJOR.$MINOR.$PATCH"
  generate_version_files "$VERSION"
  exit 0
fi

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Confirma - Usa zenity diretamente para garantir que funcione no Nemo
if command -v zenity >/dev/null 2>&1; then
  zenity --question \
    --title="Git Tools" \
    --text="Confirma a atualização de versão?\n\nv$VERSION → v$NEW_VERSION" \
    --ok-label="Confirmar" \
    --cancel-label="Cancelar" \
    --width=380 || exit 0
else
  ask_confirm CONFIRM "Confirma a atualização de versão?\n\nv$VERSION → v$NEW_VERSION"
  if [ "$CONFIRM" != "s" ]; then
    notify_info "❌ Atualização cancelada"
    exit 0
  fi
fi

# Atualiza .gitproject
sed -i "s/^VERSION=.*/VERSION=$NEW_VERSION/" .gitproject
git add .gitproject
git commit -m "chore: bump version to v$NEW_VERSION"
git tag "v$NEW_VERSION"

# Gera os arquivos de versão das linguagens encontradas na pasta
generate_version_files "$NEW_VERSION"

# Mensagem final - com zenity para GUI
GENERATED_MSG=""
if [ ${#GENERATED_FILES[@]} -gt 0 ]; then
  GENERATED_MSG="\n\ne também gerado:\n$(printf '%s\n' "${GENERATED_FILES[@]}")"
fi

if command -v zenity >/dev/null 2>&1; then
  zenity --info \
    --title="Git Tools" \
    --text="✔ Versão atualizada com sucesso!\n\nv$VERSION → v$NEW_VERSION$GENERATED_MSG" \
    --width=380
else
  notify_info "✔ Versão atualizada: v$VERSION → v$NEW_VERSION"
fi