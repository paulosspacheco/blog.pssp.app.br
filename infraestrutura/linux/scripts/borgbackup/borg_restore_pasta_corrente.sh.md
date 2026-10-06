# ♻️ Manual do Script `borg_restore_pasta_corrente.sh`

## 📘 Descrição Geral

O script **`borg_restore_pasta_corrente.sh`** automatiza a **restauração de backups** da pasta corrente (diretório atual) criados com o **BorgBackup**, utilizando o script base [`borg_restore.sh`](./borg_restore.sh).

Ele identifica automaticamente o repositório Borg correspondente à pasta em questão e restaura os arquivos de backup diretamente dentro de uma subpasta chamada `restaurado`.

Este script é ideal para **usuários domésticos ou técnicos** que desejam restaurar uma pasta de backup de forma rápida, interativa e segura — sem precisar digitar comandos longos do Borg manualmente.

---

## 🧠 Objetivo

- Restaurar backups criados com o **BorgBackup** para a pasta corrente.  
- Localizar automaticamente o repositório Borg correto com base no nome da pasta.  
- Automatizar o processo via script base **`borg_restore.sh`**.  
- Garantir uma experiência interativa e validada (com confirmações).  
- Criar a pasta de destino `restaurado/` para armazenar os arquivos restaurados.  

---

## ⚙️ Parâmetros e Variáveis Internas

O script **não requer parâmetros externos**.  
Todas as variáveis são configuradas automaticamente com base no diretório atual.

| Variável | Descrição | Exemplo |
|-----------|------------|----------|
| `SCRIPT_BASE` | Caminho absoluto para o script base de restauração | `/home/paulosspacheco/scripts/borg_restore.sh` |
| `DESTINO_BASE` | Caminho base onde os repositórios Borg estão armazenados | `/media/paulosspacheco/Novo volume/borg_backup` |
| `CRIPTO` | Tipo de criptografia (padrão: `none`) | `none` |
| `ORIGEM` | Diretório atual (`pwd`) | `/home/paulosspacheco/scripts` |
| `NOME` | Nome da pasta corrente (basename) | `scripts` |
| `REPO` | Caminho completo para o repositório Borg correspondente | `/media/paulosspacheco/Novo volume/borg_backup/scripts/borg-repo` |
| `DESTINO_RESTAURACAO` | Caminho de destino onde os arquivos serão restaurados | `/home/paulosspacheco/scripts/restaurado` |

---

## 🧰 Exemplo de Uso

### 🔹 Exemplo 1 — Restaurar o backup da pasta atual
```bash
cd ~/scripts
./borg_restore_pasta_corrente.sh
````

Saída esperada:

```
======================================================
♻️  Restauração da pasta corrente com BorgBackup
======================================================
Nome ...........: scripts
Repositório ....: /media/paulosspacheco/Novo volume/borg_backup/scripts/borg-repo
Destino final ..: /home/paulosspacheco/scripts/restaurado
Script base ....: /home/paulosspacheco/scripts/borg_restore.sh
Criptografia ...: none
======================================================

Deseja restaurar a pasta 'scripts' para '/home/paulosspacheco/scripts/restaurado'? (s/n): s
```

---

## 🧩 Estrutura do Script

### 1️⃣ Exibição Inicial

Apresenta um resumo das configurações detectadas automaticamente:

```bash
echo "Nome ...........: $NOME"
echo "Repositório ....: $REPO"
echo "Destino final ..: $DESTINO_RESTAURACAO"
echo "Script base ....: $SCRIPT_BASE"
echo "Criptografia ...: $CRIPTO"
```

---

### 2️⃣ Validações Iniciais

Antes da execução, o script garante que tudo está correto:

* **Verifica se o script base existe e é executável:**

  ```bash
  if [ ! -x "$SCRIPT_BASE" ]; then
      echo "❌ O script base '$SCRIPT_BASE' não foi encontrado ou não tem permissão de execução."
      exit 1
  fi
  ```

* **Verifica se o repositório Borg existe:**

  ```bash
  if [ ! -d "$REPO" ]; then
      echo "❌ O repositório '$REPO' não foi encontrado!"
      exit 1
  fi
  ```

* **Cria o diretório de restauração caso não exista:**

  ```bash
  mkdir -p "$DESTINO_RESTAURACAO"
  ```

---

### 3️⃣ Confirmação do Usuário

Antes de prosseguir, o script confirma a intenção de restauração:

```bash
read -p "Deseja restaurar a pasta '$NOME' para '$DESTINO_RESTAURACAO'? (s/n): " CONFIRMA
```

Se o usuário responder `n`, a operação é cancelada imediatamente.

---

### 4️⃣ Execução da Restauração

A restauração é feita chamando o script base (`borg_restore.sh`) com os parâmetros adequados:

```bash
"$SCRIPT_BASE" "$REPO" "$DESTINO_RESTAURACAO" "" "$CRIPTO"
```

Isso inicia o fluxo completo de restauração, incluindo:

* Verificação de snapshots disponíveis,
* Simulação (*dry-run*),
* Execução real da restauração.

---

### 5️⃣ Resultado Final

Após a execução, o script exibe o status final com base no código de retorno:

```bash
if [ $? -eq 0 ]; then
    echo "✅ Restauração da pasta '$NOME' concluída com sucesso!"
    echo "Arquivos restaurados em: $DESTINO_RESTAURACAO"
else
    echo "❌ Ocorreu um erro durante a restauração."
fi
```

---

## 📂 Estrutura de Arquivos Após a Restauração

Após a execução bem-sucedida, a estrutura final será semelhante a:

```
/home/paulosspacheco/scripts/
 ├── borg_restore_pasta_corrente.sh
 ├── borg_restore.sh
 ├── borg_backup.sh
 ├── ...
 └── restaurado/
      ├── borg_backup_pasta_corrente.sh
      ├── borg_backup.sh
      ├── borg_restore.sh
      └── outros arquivos do backup
```

---

## ⚙️ Dependências

| Dependência               | Descrição                                                                    |
| ------------------------- | ---------------------------------------------------------------------------- |
| **borgbackup**            | Ferramenta principal de backup e restauração                                 |
| **bash (5.x)**            | Shell de execução                                                            |
| **borg_restore.sh**       | Script base obrigatório                                                      |
| **Acesso ao repositório** | O caminho `/media/paulosspacheco/Novo volume/borg_backup` deve estar montado |

---

## 🧪 Exemplo Completo de Execução

```
======================================================
♻️  Restauração da pasta corrente com BorgBackup
======================================================
Nome ...........: scripts
Repositório ....: /media/paulosspacheco/Novo volume/borg_backup/scripts/borg-repo
Destino final ..: /home/paulosspacheco/scripts/restaurado
Script base ....: /home/paulosspacheco/scripts/borg_restore.sh
Criptografia ...: none
======================================================

Deseja restaurar a pasta 'scripts' para '/home/paulosspacheco/scripts/restaurado'? (s/n): s

======================================================
🚀 Iniciando restauração com borg_restore.sh ...
======================================================
======================================================
♻️  Restaurador genérico de backups BorgBackup
======================================================
Repositório ....: /media/paulosspacheco/Novo volume/borg_backup/scripts/borg-repo
Destino ........: /home/paulosspacheco/scripts/restaurado
Snapshot .......: backup-2025-10-30
Criptografia ...: none
======================================================

🧪 Etapa 1: Simulação (dry-run)
borg_backup.sh
borg_restore.sh
...
✅ Restauração concluída com sucesso!
Arquivos restaurados em: /home/paulosspacheco/scripts/restaurado
```

---

## ⚠️ Cuidados e Boas Práticas

1. **Monte o disco externo** antes da restauração:

   ```bash
   mount | grep "Novo volume"
   ```
2. **Não execute dentro da pasta `restaurado/`**, para evitar sobrescrita.
3. **Confirme o snapshot** correto durante o processo.
4. **Evite restaurar diretamente sobre o diretório original** sem revisar a simulação (`dry-run`).
5. **Mantenha o script base sincronizado** com a versão testada (`borg_restore.sh`).

---

## 🔗 Referências

* 📘 **Site oficial do BorgBackup:**
  [https://www.borgbackup.org/](https://www.borgbackup.org/)

* 📖 **Documentação completa:**
  [https://borgbackup.readthedocs.io/en/stable/](https://borgbackup.readthedocs.io/en/stable/)

* 💬 **Comunidade e suporte:**
  [https://github.com/borgbackup/borg/discussions](https://github.com/borgbackup/borg/discussions)

---

## 🧾 Histórico de Versões

| Versão | Data       | Alterações                                                              |
| ------ | ---------- | ----------------------------------------------------------------------- |
| 1.0    | 2025-10-30 | Versão inicial funcional                                                |
| 1.1    | 2025-10-31 | Integração com script base e criação automática da pasta de restauração |

---

## ✅ Autor

**Paulo SSPacheco**
💻 Automação e Infraestrutura Linux
📅 Outubro de 2025

---
