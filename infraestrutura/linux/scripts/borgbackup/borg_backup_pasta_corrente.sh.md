# 💾 Manual do Script `borg_backup_pasta_corrente.sh`

## 📘 Descrição Geral

O script **`borg_backup_pasta_corrente.sh`** automatiza o backup incremental da **pasta corrente** (diretório onde é executado)  
utilizando o script principal [`borg_backup.sh`](./borg_backup.sh).  

Ele identifica automaticamente:
- O nome da pasta atual (como identificador do backup),
- O caminho completo de origem,
- O destino padrão (`/media/paulosspacheco/Novo volume/borg_backup`),
- E executa o backup de forma segura e validada.

Este script é ideal para quem deseja **realizar backups rápidos e consistentes** sem precisar digitar longos comandos.

---

## 🧠 Objetivo

- Criar backups incrementais da **pasta corrente** usando o BorgBackup.  
- Garantir que o **disco de backup esteja montado** antes da execução.  
- Integrar com o script base **`borg_backup.sh`** para padronizar a execução.  
- Automatizar o processo com **verificações e confirmações interativas**.

---

## ⚙️ Parâmetros e Variáveis

O script não recebe parâmetros externos — ele trabalha automaticamente com a pasta onde é executado.

| Variável | Descrição | Exemplo |
|-----------|------------|----------|
| `SCRIPT_BASE` | Caminho absoluto para o script `borg_backup.sh` | `/home/paulosspacheco/scripts/borg_backup.sh` |
| `DESTINO` | Caminho base onde os backups são armazenados | `/media/paulosspacheco/Novo volume/borg_backup` |
| `MONTAGEM` | Ponto de montagem do disco de backup | `/media/paulosspacheco/Novo volume` |
| `ORIGEM` | Diretório atual (`pwd`) | `/home/paulosspacheco/scripts` |
| `NOME` | Nome lógico do backup (basename da pasta atual) | `scripts` |
| `CRIPTO` | Tipo de criptografia (padrão: `none`) | `none` |

---

## 🧰 Exemplo de Uso

### 🔹 Exemplo 1 — Executar backup da pasta corrente
```bash
cd ~/scripts
./borg_backup_pasta_corrente.sh
````

Resultado:

```
======================================================
💾 Backup da pasta corrente com BorgBackup
======================================================
Nome ...........: scripts
Origem .........: /home/paulosspacheco/scripts
Destino ........: /media/paulosspacheco/Novo volume/borg_backup
Ponto de montagem: /media/paulosspacheco/Novo volume
Script base ....: /home/paulosspacheco/scripts/borg_backup.sh
Criptografia ...: none
======================================================

Deseja iniciar o backup da pasta corrente '/home/paulosspacheco/scripts'? (s/n): s
```

---

## 🧩 Estrutura do Script

### 1️⃣ Exibição Inicial

Exibe um resumo amigável dos parâmetros detectados:

```bash
echo "Nome ...........: $NOME"
echo "Origem .........: $ORIGEM"
echo "Destino ........: $DESTINO"
echo "Ponto de montagem: $MONTAGEM"
echo "Script base ....: $SCRIPT_BASE"
```

---

### 2️⃣ Validações Iniciais

Antes de executar o backup, o script valida:

* **Se o script base existe e é executável:**

  ```bash
  if [ ! -x "$SCRIPT_BASE" ]; then
      echo "❌ O script base '$SCRIPT_BASE' não foi encontrado ou não tem permissão de execução."
      exit 1
  fi
  ```

* **Se o ponto de montagem está ativo:**

  ```bash
  if ! mountpoint -q "$MONTAGEM"; then
      echo "⚠️ O destino '$MONTAGEM' não está montado!"
      exit 1
  fi
  ```

* **Se o diretório de destino existe:**

  ```bash
  if [ ! -d "$DESTINO" ]; then
      mkdir -p "$DESTINO"
  fi
  ```

Essas verificações evitam falhas como backup em disco não montado ou caminho incorreto.

---

### 3️⃣ Confirmação do Usuário

Antes de iniciar o processo, há uma confirmação interativa:

```bash
read -p "Deseja iniciar o backup da pasta corrente '$ORIGEM'? (s/n): " CONFIRMA
```

Se o usuário responder “n”, a operação é cancelada com segurança.

---

### 4️⃣ Execução do Backup

Após a confirmação, o script executa o backup chamando diretamente o script base:

```bash
"$SCRIPT_BASE" "$NOME" "$ORIGEM" "$DESTINO" "$CRIPTO"
```

Isso garante que o backup use exatamente a mesma lógica padronizada definida em `borg_backup.sh`.

---

### 5️⃣ Resultado Final

Ao concluir, o script valida o retorno da execução (`$?`) e exibe a mensagem apropriada:

```bash
if [ $? -eq 0 ]; then
    echo "✅ Backup da pasta '$ORIGEM' concluído com sucesso!"
else
    echo "❌ Ocorreu um erro durante o backup."
fi
```

---

## 📂 Estrutura de Destino do Backup

Após a execução bem-sucedida, o backup é salvo dentro do destino configurado:

```
/media/paulosspacheco/Novo volume/borg_backup/
 └── scripts/
     └── borg-repo/
         ├── config
         ├── data/
         ├── index.123456
         └── backups:
             ├── backup-2025-10-30
             ├── backup-2025-10-31
             └── backup-2025-11-01
```

Cada backup incremental é nomeado automaticamente com a data do dia.

---

## ⚙️ Dependências

| Dependência        | Descrição                                      |
| ------------------ | ---------------------------------------------- |
| **borgbackup**     | Ferramenta principal para backups incrementais |
| **bash (5.x)**     | Shell de execução                              |
| **mountpoint**     | Verifica se o disco está montado               |
| **borg_backup.sh** | Script base obrigatório                        |

---

## 🧪 Exemplo de Saída Completa

```
======================================================
💾 Backup da pasta corrente com BorgBackup
======================================================
Nome ...........: scripts
Origem .........: /home/paulosspacheco/scripts
Destino ........: /media/paulosspacheco/Novo volume/borg_backup
Ponto de montagem: /media/paulosspacheco/Novo volume
Script base ....: /home/paulosspacheco/scripts/borg_backup.sh
Criptografia ...: none
======================================================

Deseja iniciar o backup da pasta corrente '/home/paulosspacheco/scripts'? (s/n): s
======================================================
🚀 Iniciando backup com borg_backup.sh ...
======================================================
======================================================
💾 Backup genérico com BorgBackup
======================================================
Nome ...........: scripts
Origem .........: /home/paulosspacheco/scripts
Destino ........: /media/paulosspacheco/Novo volume/borg_backup
Repositório ....: /media/paulosspacheco/Novo volume/borg_backup/scripts/borg-repo
Criptografia ...: none
======================================================

📦 Criando repositório Borg...
💾 Iniciando backup incremental (modo relativo)...
🧹 Limpando backups antigos...
✅ Backup concluído com sucesso!

✅ Backup da pasta '/home/paulosspacheco/scripts' concluído com sucesso!
Arquivos armazenados em: /media/paulosspacheco/Novo volume/borg_backup
```

---

## ⚠️ Cuidados e Boas Práticas

1. **Monte o disco de backup** antes da execução:

   ```bash
   mount | grep "Novo volume"
   ```

2. **Mantenha o script base atualizado** (`borg_backup.sh`).

3. **Evite nomes de pasta com espaços** (ou use aspas `" "`).

4. **Execute como o usuário correto** (sem `sudo`, salvo se necessário).

5. **Verifique o log de backup** para acompanhar execuções automáticas (crontab).

---

## 🔗 Referências

* 📘 **Site oficial do BorgBackup:**
  [https://www.borgbackup.org/](https://www.borgbackup.org/)

* 📖 **Documentação completa:**
  [https://borgbackup.readthedocs.io/en/stable/](https://borgbackup.readthedocs.io/en/stable/)

* 💬 **Comunidade Borg:**
  [https://github.com/borgbackup/borg/discussions](https://github.com/borgbackup/borg/discussions)

---

## 🧾 Histórico de Versões

| Versão | Data       | Alterações                                                              |
| ------ | ---------- | ----------------------------------------------------------------------- |
| 1.0    | 2025-10-30 | Versão inicial funcional                                                |
| 1.1    | 2025-10-31 | Adicionadas verificações de montagem e criação automática de diretórios |

---

## ✅ Autor

**Paulo SSPacheco**
💻 Automação e Infraestrutura Linux
📅 Outubro de 2025

---
