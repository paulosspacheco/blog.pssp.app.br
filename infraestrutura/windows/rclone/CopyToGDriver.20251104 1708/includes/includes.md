# includes

- Estrutura de arquivos multi plataforma


```text

    includes/
    ├── common/
    │   ├── logging.sh              ← write_color_output()
    │   ├── common_functions.sh     ← file_count(), resolve_path(), ensure_directory()
    │   └── config.sh               ← variáveis padrão
    ├── linux/
    │   ├── disk_utils.sh           ← df/du adaptados
    │   ├── process_utils.sh        ← pgrep/pkill
    │   └── path_utils.sh           ← readlink -f
    └── windows/
        ├── disk_utils.sh           ← wmic/tasklist adaptados
        ├── process_utils.sh        ← taskkill/tasklist
        └── path_utils.sh           ← conversão /c/Users → C:\Users
```