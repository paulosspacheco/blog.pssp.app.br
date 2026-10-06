# 🧭 CopyToGDriver – Módulo `path_utils.sh` (v1.0.2)

## 📄 Descrição

O módulo `path_utils.sh` fornece **funções utilitárias para conversão de caminhos** entre o formato **Windows nativo (C:\Users\...)** e o formato **Git Bash/WSL (/c/Users/...)**.  
Ele é parte integrante da camada **cross-platform** do projeto **CopyToGDriver**, mas pode ser usado de forma **independente** em outros scripts Bash.

---

## 💡 Funcionalidade principal

| Função | Descrição | Compatibilidade |
|--------|------------|----------------|
| `to_windows_path` | Converte caminhos do Git Bash (`/c/Users/...`) para o formato Windows (`C:\Users\...`) | Windows / Git Bash |
| `to_gitbash_path` | Converte caminhos do Windows (`C:\Users\...`) para o formato Git Bash (`/c/Users/...`) | Windows / Git Bash |
| `is_windows_path` | Detecta se o caminho informado está em formato Windows (`C:\...`) | Todos os sistemas |

---

## ⚙️ Estrutura do Arquivo

```bash
includes/
├── crossplatform/
│   ├── disk_utils.sh
│   ├── crossplatform_utils.sh
│   ├── platform_loader.sh
│   └── ...
└── windows/
    └── path_utils.sh   ← (este módulo)
