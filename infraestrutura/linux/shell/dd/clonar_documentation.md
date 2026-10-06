# Documentação do Script de Clonagem de Discos (`clonar.sh`)

Este documento descreve detalhadamente o funcionamento, recursos de segurança e opções do script `clonar.sh`, usado para clonar HDs ou SSDs no Linux de forma segura.

---

## **1. Verificação de parâmetros**
- O script exige **dois parâmetros obrigatórios**: o disco de origem e o disco de destino.
- Caso os parâmetros estejam ausentes, exibe instruções de uso.
- Detecta e rejeita **opções desconhecidas**.

**Exemplos:**
```bash
sudo ./clonar.sh /dev/sda /dev/sdb
sudo ./clonar.sh --dry-run /dev/sda /dev/sdb
sudo ./clonar.sh --gzip /dev/sda /dev/sdb
```

---

## **2. Verificação de existência dos dispositivos**
- Confirma que tanto **origem quanto destino existem** e são dispositivos de bloco (`-b`).
- Evita que o script tente clonar algo que não seja um disco real.

---

## **3. Comparação de tamanhos**
- Mede o **tamanho em bytes da origem e do destino**.
- Bloqueia a clonagem se o **destino for menor que a origem**, prevenindo perda de dados.

---

## **4. Informações detalhadas dos discos**
- Exibe **nome, tamanho, modelo e serial** de ambos os discos usando `lsblk -d`.
- Permite ao usuário confirmar visualmente que os discos selecionados são os corretos.

---

## **5. Confirmação explícita do usuário**
- O script solicita ao usuário digitar **`sim`** para prosseguir.
- Qualquer outra resposta cancela a operação imediatamente.

---

## **6. Modo simulação (`--dry-run`)**
- Permite **visualizar o que seria feito** sem executar o comando `dd`.
- Mostra o comando completo que seria executado.
- Pode ser combinado com `--gzip` para testar a criação e compactação do log sem mexer nos discos.

---

## **7. Execução segura do `dd`**
- O comando `dd` é executado com as opções:
  - `bs=64K` → tamanho de bloco equilibrado para velocidade e segurança.
  - `conv=noerror,sync` → continua mesmo se houver erros, mantendo alinhamento de blocos.
  - `status=progress` → mostra progresso em tempo real.
- Ao final, `sync` garante que todos os dados foram gravados.

---

## **8. Log detalhado e único**
- Cada execução gera um **log exclusivo** com data e hora no diretório do usuário:
```
~/clonar.log/clonar-YYYYMMDD-HHMMSS.log
```
- Contém informações detalhadas dos discos, comandos executados e saída do `dd`.
- Permite manter histórico das clonagens realizadas.

---

## **9. Compactação opcional do log (`--gzip`)**
- Log pode ser **compactado automaticamente** em `.log.gz`.
- Funciona também no **modo dry-run**.

---

## **10. Medição de tempo e velocidade**
- Calcula o **tempo total da clonagem**.
- Calcula a **velocidade média em MB/s**.
- Resultados exibidos na tela e registrados no log.

---

## **Resumo das Proteções de Segurança**
1. **Parâmetros obrigatórios:** impede execução sem origem e destino.
2. **Verificação de existência:** evita discos inválidos.
3. **Comparação de tamanhos:** não permite clonar para discos menores.
4. **Informações detalhadas:** modelo e serial visíveis antes da execução.
5. **Confirmação explícita:** operação só prossegue se digitar `sim`.
6. **Modo simulação:** permite verificar tudo sem riscos.
7. **Execução segura do `dd`:** continua em caso de erro e mantém alinhamento.
8. **Logs exclusivos e detalhados:** cada execução gera um arquivo único.
9. **Compactação opcional:** economiza espaço e mantém histórico.
10. **Medição de tempo e velocidade:** fornece métricas de performance.

---

O script `clonar.sh` é projetado para ser **robusto, seguro e à prova de acidentes**, garantindo que a clonagem de discos seja confiável, rastreável e auditável.

---

**Autor:** Paulo Sérgio da Silva Pacheco  
**Última atualização:** 2025-10-06

