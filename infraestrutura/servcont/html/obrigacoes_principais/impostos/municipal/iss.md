# Imposto Sobre Serviços (ISS)

   1. **O que será feito** ?
      1. Baixar as Notas Fiscais de serviços emitidas na site da prefeitura;

      2. Importar as notas fiscais emitidas no período para o sistema **FORTES - Setor Fiscal** na opção **/Menu/Movimentos/Importar**;

      3. No sistema **FORTES - Setor Fiscal** opção **/menu/relatórios/Listagem das saídas/ISS**, gerar relatório com os valores usados para preencher o **DAM**;

      4. Perguntar para o cliente quanto foi suas vendas de serviços no período;

      5. Emitir o Documento de Arrecadação Municipal (DAM) para pagar o ISS no site da prefeitura;

      6. Enviar o **DAM** para o cliente pagar antes do prazo de vencimento;

      7. Confirmar com o cliente se ele recebeu o **DAM**;

      8. Encerramento do período.

   2. **Por que será feito** ?
      1. O não pagamento do ISS no dia 10 cada mês, acarreta em multa para empresas cliente da SERVCONT, além de outras sanções definidas em [lei](https://www.sefin.fortaleza.ce.gov.br/Canal/16/Generico/1255/Ler).

   3. **Onde será feito** ?
      1. [ISS Fortaleza](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=265817);
      2. [ISS Eusébio](http://iss.speedgov.com.br/eusebio/login)
      3. [ISS Horizonte](http://iss.speedgov.com.br/horizonte/login)
      4. [ISS Paracuru](http://iss.speedgov.com.br/paracuru/login)
      5. Pasta comum compartilhada para de transferência de **xml**:
         1. _//dat/Nome do setor/xml_
      6. Sistema **FORTES - Setor Fiscal** opções:
         1. _/Menu/Movimentos/Importar_
         2. _/menu/Movimentos/Importar/Procurar/NFS-e Padrão ABRASF_
         3. _/menu/relatórios/Listagem das saídas/ISS_.

   4. **Quando será feito** ?
      1. Prazos para pagamentos do ISS:
         1. Dia 10 do mês subsequente.
      2. Até que data a SERVCONT deve entrega a guia para o cliente:
         1. Entre 5 a 3 dias antes do vencimento da guia.

   5. **Por quem será feito** ?
      1. Quem emitirá o  Documento de Arrecadação Municipal (DAM) para pagamento do ISS?
         1. Auxiliar do setor fiscal;

      2. Quem confere o Documento de Arrecadação Municipal (DAM) para pagar o ISS?
         1. Encarregado do setor fiscal;

      3. Quem deve pagar o Documento de Arrecadação Municipal (DAM) do ISS?
         1. Setor financeiro da empresa cliente.

   6. **Como será feito** ?
      1. Baixar as Notas Fiscais de serviços emitidas na site da prefeitura;
         1. Exemplo - Portal ISS Fortaleza.
            1. **Passo a passo**:
               1. [Entrar no site **ISS Fortaleza**](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=265817);
               2. Selecionar a empresa a ser baixado os **.XML** das  **NFS-e**;
               3. Selecionar a opção: **Consultar NFS-e**;
                  1. Selecionar o tipo de serviço;
                  2. Selecionar a guia competência/tomador;
                  3. Selecionar o mês de referência;
                  4. Selecionar se o tipo de tomador. Obs: Pode ser pessoa física (CPF) ou jurídica (CNPJ);
                  5. Pressione o botão **Consultar**;
                  6. Na grade de **resultado da consulta**:
                     1. Pressionar o botão **Selecionar todas da pagina atual**;
                     2. Pressionar o botão **Exportar XML das Notas Selecionadas**;
                     3. Escolha a pasta usada para compartilhar arquivos entre máquinas.
                     4. Escolha um nome para o arquivo **XML** a ser exportado, pois você vai precisar dele ao importar para o **FORTES - Setor Fiscal**.

            2. Exemplo - Portal ISS [das cidades de Eusébio, Paracuru, Horizonte](http://iss.speedgov.com.br/)
               1. ...

      2. Importar as notas fiscais emitidas no período para o sistema **FORTES - Setor Fiscal** na opção **/Menu/Movimentos/Importar**:
         1. Passo a passo:
            1. Pressione o botão **Procurar** do formulário de importação;
            2. Localize o arquivo **XML** criado no passo anterior (3.1);
            3. 

      3. O DAM é emitido no site da prefeitura.
         1. Exemplo:
            1. [Entrar no site **ISS Fortaleza**](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=265817)
               1. Baixar Notas Ficais de serviços na opção: **/menu/Recolhimento/Emitir DAM**
               2. Emitir o DAM na opção **/menu/Recolhimento/Emitir DAM**.
                  1. Preencher os campos abaixo:
                     1. Informar o mês de Competência:
                        1. Mês de referência do recolhimento.

                     2. Selecionar o tipo de Imposto:
                        1. ISS próprio;
                        2. ISS retido - Substituição tributária;
                        3. ISS retido - Responsabilidade tributária.

                     3. Informar o tipo de DAM:
                        1. Normal;
                        2. Avulso.

      4. No sistema **FORTES - Setor Fiscal** opções:
         1. _/menu/Movimentos/Importar/Procurar/NFS-e Padrão ABRASF_;
            1. **Nota**: Selecione o arquivo **XML** gerado no site da prefeitura;
         2. _/menu/relatórios/Listagem das saídas/ISS_.
         3. ..
   7. **Quanto custará**?
      1. Tempo gasto para executar as tarefas:
         1. 1 minutos para entrar no site da SEFAZ;
         2. 15 minutos para emitir a guia do icms;
         3. 5 minutos para lembrar o cliente de pagar o imposto;
         4. Soma.: **21** minutos.

      2. Cálculo do custo:
         1. Custo por minuto da mão de **obra direta** empregada:
            1. ((Salários do setor + encargos setor) / ((220 x N) / 60)) x **21** .
