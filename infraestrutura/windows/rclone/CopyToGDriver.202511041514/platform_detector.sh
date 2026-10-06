#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: platform_detector.sh
# Função: Detectar a plataforma atual (Linux, Windows, macOS)
# ===========================================================

detect_platform() {
    case "$OSTYPE" in
        linux-gnu*|linux*)
            echo "linux"
            ;;
        darwin*)
            echo "macos"
            ;;
        cygwin*|msys*|win32*)
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

export PLATFORM=$(detect_platform)
export PLATFORM_INCLUDE_PATH=$(get_platform_include_path)
