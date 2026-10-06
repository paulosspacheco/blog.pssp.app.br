# Comparativo entre o rcloneBrowser e o script copyToGDriver



```text

    ┌──────────────────────────────┐                   ┌──────────────────────────────┐
    │        RCLONE BROWSER        │                   │       COPYTOGDRIVER          │
    │  (Interface gráfica manual)  │                   │ (Sistema automatizado shell) │
    └──────────────────────────────┘                   └──────────────────────────────┘

        [Usuário abre app]                                   [Usuário executa script]
                    │                                                      │
                    ▼                                                      ▼
        Escolhe o remote (Drive)                            Detecta automaticamente:
                    │                                         • pasta local atual
                    │                                         • nome remoto (gdriver)
                    ▼                                         • pasta remota (rclone/)
        Seleciona pasta origem/destino                               │
                    │                                                    ▼
        Configura manualmente o caminho                    Exibe cabeçalho informativo
                    │                                                    │
                    ▼                                                    ▼
        Clica em "Upload" ou "Download"              🔍 Etapa 1: Simulação (dry-run)
                    │                                         • Verifica se há erros
                    │                                         • Testa conexão e cache
                    ▼                                                    │
            Execução simples do rclone                          Se OK → segue
            (sem verificação lógica)                            Se falha → aborta
                    │                                                    ▼
                    │                                         ⚙️ Etapa 2: Sincronização real
                    ▼                                         • Cria pastas automaticamente
            Copia arquivos                                 • Gera log detalhado
                    │                                         • Protege arquivos deletados
                    ▼                                                    │
            Se falha, exibe erro bruto                      Se pasta vazia → restaura backup
                    │                                                    │
                    ▼                                                    ▼
            Usuário precisa entender                         Backup versionado → rclone.deleted
            e corrigir manualmente                                    │
                    │                                                    ▼
                    ▼                                         ✅ Log e validação final
            (sem rollback automático)                         🚫 Aborta se risco de perda
                                                                ou confirma sucesso
```