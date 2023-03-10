unit uSetor_fiscal;
{:< O setor **@name** é responsável por apuração dos impostos  de cada
    empresa cliente baseado nas Notas Fiscais de entrada, Notas Fiscais
    de Saída e  Folha de Pagamento.
}
{$mode ObjFPC}{$H+}

interface

uses uAnalise5w2h;


Type
  { TFiscal_5W2H }
  {: Análise [5w2h](https://ferramentasdaqualidade.org/5w2h) do setor fiscal
     da Servcont tem como objetivo deixar transparente o motivo pelo qual as
     empresas nos contrata para atendermos suas necessidades referente ao
     fisco Federal, Estadual e Municial.

     - O setor fiscal é responsável por apuração dos impostos e encaminhar
       com antecedẽncia as guias de pagamentos para os clientes da Servcont
       e confirmar o recebimento das mesmas com os mesmos através de redes sociais
       ou telefone.
  }
  TFiscal_5W2H = class(TAnalise5w2h)

    {: **O QUE SERÁ FEITO**

       - **PAGAMENTO DOS IMPOSTOS**
         - **Imposto Sobre Serviços** ([ISS](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=265817))           
           - Baixar as Notas Fiscais de Serviço do portal do ISS do município da empresa;
           - Importar para o Fortes as Notas Fiscais baixadas.
             - Erros possíveis:
               - Nota fiscal já importada;
               - Arquivo corrompido;
           - Confirmar com o cliente quanto foi suas vendas de serviços;
           - Apuração do ISS sobre Venda de Serviços;
           - Emissão dos boletos de pagamento;
           - Envio dos boletos para a caixa postal do cliente
           - Confirmar com os clientes se o mesmo recebeu os boletos.

           - **NOTAS**
             - _Total de clientes que recolhem ISS_:
               - Ativos? :
               - Inativos?:
             - _Total de horas gastas no processo_:
               - Ativos?:
               - Inativos?:

         - **Guia de Pagamento do Simples Nacional** ([PGDAS](http://www8.receita.fazenda.gov.br/SimplesNacional/Servicos/Grupo.aspx?grp=t&area=1))
           - Baixar as Notas Fiscais de Serviço Prestados;
           - Baixar as Notas Fiscais de Serviço Tomados;
           - Baixar as Notas Fiscais de Saídas;
           - Baixar as Notas Fiscais de Entras;
           - Confirmar com o cliente quanto foi suas vendas de serviços;
           - Confirmar com o cliente quanto foi suas vendas de Mercadorias;
           - Apuração do PGDAS sobre Venda de Serviços e Mercadorias;
           - Emissão dos boletos de pagamento do PGDAS;
           - Envio dos boletos do PGDAS para a caixa postal do cliente
           - Confirmar com os clientes se o mesmo recebeu o boleto.
           - **NOTAS**
             - _Total de clientes do Simples Nacional_:
               - Ativos?:
               - Inativos?:
             - _Total de horas gastas no processo_:
               - Ativos?:
               - Inativos?:

         - **Guia de Pagamento do Micro Empreendedor Individual** (PGMAI)
           - Baixar as Notas Fiscais de Serviço Prestados;
           - Baixar as Notas Fiscais de Serviço Tomados;
           - Baixar as Notas Fiscais de Saídas;
           - Baixar as Notas Fiscais de Entras;

           - Apuração do PGMAI;

           - Emissão dos boletos de pagamento do PGMAI;

           - Envio dos boletos do PGMAI para a caixa postal do cliente;

           - Confirmar com os clientes se o mesmo recebeu o boleto.

           - **NOTAS**
             - _Total de clientes do PGMAI_:
               - Ativos:
               - Inativos:
             - _Total de horas gastas no processo_:
               - Ativos:
               - Inativos:


         - **Guia de Pagamento do ICMS Normal** (DAE-Normal)
           - Baixar as Notas Fiscais de Saídas;
           - Baixar as Notas Fiscais de Entradas;

           - Confirmar com o cliente quanto foi suas vendas de Mercadorias;

           - Apuração do DAE-Normal sobre Venda de Mercadorias;

           - Emissão dos boletos de pagamento do DAE-Normal;
           - Emissão do relatórios do icms Normal;

           - Envio dos boletos do DAE-Normal e do relatório de ICMS Nomral
             para a caixa postal do cliente.

           - Confirmar com os clientes se o mesmo recebeu o boleto.

           - **NOTAS**
             - _Total de clientes do DAE-Normal_:
               - Ativos:
               - Inativos:
             - _Total de horas gastas no processo_:
               - Ativos:
               - Inativos:


         - **Guia de Pagamento do ICMS Substituto** (DAE-ST)
           - Baixar as Notas Fiscais de Entradas;
           - Apuração do DAE-ST;


           - Emissão dos boletos de pagamento do DAE-ST;
           - Emissão do relatórios do icms Subtituto;

           - Envio dos boletos do DAE-ST e do relatório de ICMS Substtituto
             para a caixa postal do cliente;

           - Confirmar com os clientes se o mesmo recebeu o boleto.

           - **NOTAS**
             - _Total de clientes do DAE-ST_:
               - Ativos:
               - Inativos:
             - _Total de horas gastas no processo_:
               - Ativos:
               - Inativos:

       - **OUTROS SERVIÇOS**
         - Controle de estoque
         - Emissão de Nota Fiscal solicitado pelo cliente.
         - Emisão de boleto de cobrança.

         - Finalizar a escrita fiscal do mês anterior.
           - Checar se os dados do sistema Fortes está batendo com os
             dados dos clientes;
             - Cliente nos envia relatório de compra e vendas do mês anterior)
             - Cliente nos envia relatório da máquina de recebimento em cartão.
             - Caso haja não conformidade nos dados comparado o que a SEFAS informa:
               - Ignorar relatório do cliente.
               - Caso seja vendas com cartão de crédito o valor total do mesmo
                 deve bater com as emissão de Notas Fiscais. Obs: Avisar para o cliente
                 o risco de ser fiscalizado.
                 - Emissão de nota de acobertamento das vendas com catão.

           - Enviar [encerramento de iss](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=373082) para prefeitura;
           - Enviar sped [EFD ICMS/IPI](http://sped.rfb.gov.br/projeto/show/274)
           -


    }
    protected procedure O_que_sera_feito;override;// = 'WHAT';

    {: **POR QUE SERÁ FEITO**
      - A apuração dos impostos e emissão das guias de pagamento no  prazo,
       são obrigações de nossos cliente para com o fisco, onde, o não pagamento
       na data estabelecida pelo fisco, acarreta em multas e juros, que podem
       inviabilizar o funcionamento da organização.
    }
    protected procedure Por_que_sera_feito;override;// 'WHY' ;

    {: **ONDE SERÁ FEITO**

      1. **PAGAMENTO DOS IMPOSTOS**
         1. **IMPOSTO SOBRE SERVIÇOS** ([ISS](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=265817))
            1. **ONDE** Baixar as Notas Fiscais de Serviço do portal do ISS do município da empresa?
               1. **RESPOSTA**: Site da prefeitura do município
               2. **PASSO A PASSO**
                  1. Entrar no site: [ISS Fortaleza](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=549225)
                  2. Selecionar empresa a ser baixado a NFS-e;
                  3. Selecionar botão Consultar NFS-e;
                  4. Selecionar o botão competência;
                  5. Selecionar período e pressiona no botão consultar
                  6. Selecionar todas as notas fiscais a serem exportadas;
                     1. Obs: A resposta é feita página por página;
                  7. Marcar as NFS-e a serem baixadas;
                     1. Obs:
                        1. Cada página é preciso ser marcada;
                        2. O mesmo botão que seleciona marca e desmarca.
                  8. Exportar XML das NFS-e selecionadas.

               3. **VÍDEO AULA**: [Vídeo de como baixar xml do site da prefeitura](../videos/Baixar_as_Notas_Fiscais_de_Servico.html);

            2. **ONDE** importar **XML** das Notas Fiscais de Serviços para o **Sistema Fortes**;
               1. **RESPOSTA:** - Fortes Módulo fiscal
               2. **PASSO A PASSO**
                  1. Selecionar formulário importação no item do menu **_Movimentos/Importar_**;
                  2. Pressionar botão **Procurar**/_Item NFS-e Padrão ABRASF_;
                  3. Localizar o arquivo **XML** salvo na opção 1.1.2.8;
                  4. Ativar o botão **Marcar todas**
                  5. Pressionar o botão **Importar marcadas**.
                  6. Pressione o botão **SIM"" para confirmar a importação.

               3. **VÍDEO AULA**: [Vídeo de como baixar xml do site da prefeitura](../videos/Baixar_as_Notas_Fiscais_de_Servico.html);

      - Confirmar com o cliente quanto foi suas vendas de serviços;
             - Onde:

           - Apuração do ISS sobre Venda de Serviços;
             - Onde:

           - Emissão dos boletos de pagamento;
             - Onde:

           - Envio dos boletos para a caixa postal do cliente
             - Onde:

           - Confirmar com os clientes se o mesmo recebeu os boletos.
             - Onde:

           - **NOTAS**
             - _Total de clientes que recolhem ISS_:
               - Ativos:
                 - Onde:

               - Inativos:
                 - Onde:

             - _Total de horas gastas no processo_:
               - Ativos:
                 - Onde:

               - Inativos:
                 - Onde:

         - **Guia de Pagamento do Simples Nacional** ([PGDAS](http://www8.receita.fazenda.gov.br/SimplesNacional/Servicos/Grupo.aspx?grp=t&area=1))
           - Baixar as Notas Fiscais de Serviço Prestados;
             - Onde:

           - Baixar as Notas Fiscais de Serviço Tomados;
             - Onde:

           - Baixar as Notas Fiscais de Saídas;
             - Onde:

           - Baixar as Notas Fiscais de Entras;
             - Onde:

           - Confirmar com o cliente quanto foi suas vendas de serviços;
             - Onde:

           - Confirmar com o cliente quanto foi suas vendas de Mercadorias;
             - Onde:

           - Apuração do PGDAS sobre Venda de Serviços e Mercadorias;
             - Onde:

           - Emissão dos boletos de pagamento do PGDAS;
             - Onde:

           - Envio dos boletos do PGDAS para a caixa postal do cliente
             - Onde:

           - Confirmar com os clientes se o mesmo recebeu o boleto.
             - Onde:

           - **NOTAS**
             - _Total de clientes do Simples Nacional_:
               - Ativos:
                 - Onde:

               - Inativos:
                 - Onde:

             - _Total de horas gastas no processo_:
               - Ativos:
                 - Onde:

               - Inativos:
                 - Onde:

         - **Guia de Pagamento do Micro Empreendedor Individual** (PGMAI)
           - Baixar as Notas Fiscais de Serviço Prestados;
             - Onde:

           - Baixar as Notas Fiscais de Serviço Tomados;
             - Onde:

           - Baixar as Notas Fiscais de Saídas;
             - Onde:

           - Baixar as Notas Fiscais de Entras;
             - Onde:

           - Apuração do PGMAI;
             - Onde:

           - Emissão dos boletos de pagamento do PGMAI;
             - Onde:

           - Envio dos boletos do PGMAI para a caixa postal do cliente;
             - Onde:

           - Confirmar com os clientes se o mesmo recebeu o boleto.
             - Onde:

           - **NOTAS**
             - _Total de clientes do PGMAI_:
               - Ativos:
                 - Onde:

               - Inativos:
                 - Onde:

             - _Total de horas gastas no processo_:
               - Ativos:
                 - Onde:

               - Inativos:
                 - Onde:

         - **Guia de Pagamento do ICMS Normal** (DAE-Normal)
           - Baixar as Notas Fiscais de Saídas;
             - Onde:

           - Baixar as Notas Fiscais de Entradas;
             - Onde:

           - Confirmar com o cliente quanto foi suas vendas de Mercadorias;
             - Onde:

           - Apuração do DAE-Normal sobre Venda de Mercadorias;
             - Onde:

           - Emissão dos boletos de pagamento do DAE-Normal;
             - Onde:

           - Emissão do relatórios do icms Normal;
             - Onde:

           - Envio dos boletos do DAE-Normal e do relatório de ICMS Nomral
             para a caixa postal do cliente.
             - Onde:

           - Confirmar com os clientes se o mesmo recebeu o boleto.
             - Onde:

           - **NOTAS**
             - _Total de clientes do DAE-Normal_:
               - Ativos?:
                 - Onde:

               - Inativos?:
                 - Onde:

             - _Total de horas gastas no processo_:
               - Ativos?:
                 - Onde:

               - Inativos?:
                 - Onde:

         - **Guia de Pagamento do ICMS Substituto** (DAE-ST)
           - Baixar as Notas Fiscais de Entradas;
             - Onde:

           - Apuração do DAE-ST;
             - Onde:

           - Emissão dos boletos de pagamento do DAE-ST;
             - Onde:

           - Emissão do relatórios do icms Subtituto;
             - Onde:

           - Envio dos boletos do DAE-ST e do relatório de ICMS Substtituto
             para a caixa postal do cliente;
             - Onde:

           - Confirmar com os clientes se o mesmo recebeu o boleto.
             - Onde:

           - **NOTAS**
             - _Total de clientes do DAE-ST_:
               - Ativos:
                 - Onde:

               - Inativos:
                 - Onde:

             - _Total de horas gastas no processo_:
               - Ativos:
                 - Onde:

               - Inativos:
                 - Onde:
    }
    protected procedure Onde_sera_feito;override; // 'WHERE';

    {: QUANDO SERÁ FEITO

     - **PAGAMENTOD DOS IMPOSTOS**
       - **Imposto Sobre Serviços** ([ISS](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=265817))
         - Baixar as Notas Fiscais de Serviço;
           - O tempo de execução:
           - cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - prazos para a execução:

         - Confirmar com o cliente quanto foi suas vendas de serviços;
           - O tempo de execução:
           - cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - prazos para a execução:

         - Apuração do ISS sobre Venda de Serviços;
           - O tempo de execução:
           - cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - prazos para a execução:

         - Emissão dos boletos de pagamento;

      - O tempo de execução:
        - cronograma de execução;
          - Dia inicial:
          - Dia Final:
        - prazos para a execução:

         - Envio dos boletos para a caixa postal do cliente.
           - O tempo de execução:
           - cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - prazos para a execução:

         - Confirmar com os clientes se o mesmo recebeu os boletos.
           - O tempo de execução:
           - cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - prazos para a execução:

       - **Guia de Pagamento do Simples Nacional** ([PGDAS](http://www8.receita.fazenda.gov.br/SimplesNacional/Servicos/Grupo.aspx?grp=t&area=1))
         - Baixar as Notas Fiscais de Serviço Prestados;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Baixar as Notas Fiscais de Serviço Tomados;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Baixar as Notas Fiscais de Saídas;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Baixar as Notas Fiscais de Entras;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Confirmar com o cliente quanto foi suas vendas de serviços;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Confirmar com o cliente quanto foi suas vendas de Mercadorias;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Apuração do PGDAS sobre Venda de Serviços e Mercadorias;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Emissão dos boletos de pagamento do PGDAS;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Envio dos boletos do PGDAS para a caixa postal do cliente
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Confirmar com os clientes se o mesmo recebeu o boleto.
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

       - **Guia de Pagamento do Micro Empreendedor Individual** (PGMAI)
         - Baixar as Notas Fiscais de Serviço Prestados;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Baixar as Notas Fiscais de Serviço Tomados;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Baixar as Notas Fiscais de Saídas;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Baixar as Notas Fiscais de Entras;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Apuração do PGMAI;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Emissão dos boletos de pagamento do PGMAI;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Envio dos boletos do PGMAI para a caixa postal do cliente;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Confirmar com os clientes se o mesmo recebeu o boleto.
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

       - **Guia de Pagamento do ICMS Normal** (DAE-Normal)
         - Baixar as Notas Fiscais de Saídas;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Baixar as Notas Fiscais de Entradas;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Confirmar com o cliente quanto foi suas vendas de Mercadorias;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Apuração do DAE-Normal sobre Venda de Mercadorias;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Emissão dos boletos de pagamento do DAE-Normal;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Emissão do relatórios do icms Normal;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Envio dos boletos do DAE-Normal e do relatório de ICMS Nomral
           para a caixa postal do cliente.
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Confirmar com os clientes se o mesmo recebeu o boleto.
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

       - **Guia de Pagamento do ICMS Substituto** (DAE-ST)
         - Baixar as Notas Fiscais de Entradas;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Apuração do DAE-ST;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Emissão dos boletos de pagamento do DAE-ST;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Emissão do relatórios do icms Subtituto;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Envio dos boletos do DAE-ST e do relatório de ICMS Substtituto
           para a caixa postal do cliente;
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:

         - Confirmar com os clientes se o mesmo recebeu o boleto.
           - O tempo de execução:
           - Cronograma de execução;
             - Dia inicial:
             - Dia Final:
           - Prazos para a execução:
    }
    protected procedure Quando_sera_Feito;override; //= 'WHEN';

    {: **POR QUEM SERÁ FEITO**


       - **PAGAMENTOD DOS IMPOSTOS**
         - **Imposto Sobre Serviços** ([ISS](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=265817))
           - Baixar as Notas Fiscais de Serviço;
             - Auxiliar do Analista Fiscal.

           - Confirmar com o cliente quanto foi suas vendas de serviços;
             - Auxiliar do Analista Fiscal.

           - Apuração do ISS sobre Venda de Serviços;
             - Auxiliar do Analista Fiscal.

           - Emissão dos boletos de pagamento;
             - Auxiliar do Analista Fiscal.

           - Envio dos boletos para a caixa postal do cliente
             - Auxiliar do Analista Fiscal.

           - Confirmar com os clientes se o mesmo recebeu os boletos.
             - Auxiliar do Analista Fiscal.

           - **NOTAS**
             - _Total de clientes que recolhem ISS_:
               - Ativos:
               - Inativos:
             - _Total de horas gastas no processo_:
               - Ativos:
               - Inativos:

         - **Guia de Pagamento do Simples Nacional** ([PGDAS](http://www8.receita.fazenda.gov.br/SimplesNacional/Servicos/Grupo.aspx?grp=t&area=1))
           - Baixar as Notas Fiscais de Serviço Prestados;
           - Baixar as Notas Fiscais de Serviço Tomados;
           - Baixar as Notas Fiscais de Saídas;
           - Baixar as Notas Fiscais de Entras;

           - Confirmar com o cliente quanto foi suas vendas de serviços;
           - Confirmar com o cliente quanto foi suas vendas de Mercadorias;

           - Apuração do PGDAS sobre Venda de Serviços e Mercadorias;

           - Emissão dos boletos de pagamento do PGDAS;

           - Envio dos boletos do PGDAS para a caixa postal do cliente

           - Confirmar com os clientes se o mesmo recebeu o boleto.

           - **NOTAS**
             - _Total de clientes do Simples Nacional_:
               - Ativos:
               - Inativos:
             - _Total de horas gastas no processo_:
               - Ativos:
               - Inativos:

         - **Guia de Pagamento do Micro Empreendedor Individual** (PGMAI)
           - Baixar as Notas Fiscais de Serviço Prestados;
           - Baixar as Notas Fiscais de Serviço Tomados;
           - Baixar as Notas Fiscais de Saídas;
           - Baixar as Notas Fiscais de Entras;
             F
           - Apuração do PGMAI;

           - Emissão dos boletos de pagamento do PGMAI;

           - Envio dos boletos do PGMAI para a caixa postal do cliente;

           - Confirmar com os clientes se o mesmo recebeu o boleto.

           - **NOTAS**
             - _Total de clientes do PGMAI_:
               - Ativos:
               - Inativos:
             - _Total de horas gastas no processo_:
               - Ativos:
               - Inativos:


         - **Guia de Pagamento do ICMS Normal** (DAE-Normal)
           - Baixar as Notas Fiscais de Saídas;
           - Baixar as Notas Fiscais de Entradas;

           - Confirmar com o cliente quanto foi suas vendas de Mercadorias;

           - Apuração do DAE-Normal sobre Venda de Mercadorias;

           - Emissão dos boletos de pagamento do DAE-Normal;
           - Emissão do relatórios do icms Normal;

           - Envio dos boletos do DAE-Normal e do relatório de ICMS Nomral
             para a caixa postal do cliente.

           - Confirmar com os clientes se o mesmo recebeu o boleto.

           - **NOTAS**
             - _Total de clientes do DAE-Normal_:
               - Ativos:
               - Inativos:
             - _Total de horas gastas no processo_:
               - Ativos:
               - Inativos:


         - **Guia de Pagamento do ICMS Substituto** (DAE-ST)
           - Baixar as Notas Fiscais de Entradas;
           - Apuração do DAE-ST;


           - Emissão dos boletos de pagamento do DAE-ST;
           - Emissão do relatórios do icms Subtituto;

           - Envio dos boletos do DAE-ST e do relatório de ICMS Substtituto
             para a caixa postal do cliente;

           - Confirmar com os clientes se o mesmo recebeu o boleto.

           - **NOTAS**
             - _Total de clientes do DAE-ST_:
               - Ativos:
               - Inativos:
             - _Total de horas gastas no processo_:
               - Ativos:
               - Inativos:

       - **INTEGRAÇÃO COM A CONTABILIDADE**
         - Exportar para a contabilidade.
           Obs: O Módulo fiscal que exporta
           e o Renovato parametriza.



    }
    protected procedure Por_quem_sera_feito;override;// = 'WHO';

  end;

implementation

{ TFiscal_5W2H }

procedure TFiscal_5W2H.O_que_sera_feito;
begin

end;

procedure TFiscal_5W2H.Por_que_sera_feito;
begin

end;

procedure TFiscal_5W2H.Onde_sera_feito;
begin

end;

procedure TFiscal_5W2H.Quando_sera_Feito;
begin

end;

procedure TFiscal_5W2H.Por_quem_sera_feito;
begin

end;

end.


{: **O QUE SERÁ FEITO**
  - A apuração dos impostos e emissão das guias de pagamento no  prazo,
   são obrigações de nossos cliente para com o fisco, onde, o não pagamento
   na data estabelecida pelo fisco, acarreta em multas e juros, que podem
   inviabilizar o funcionamento da organização.

   - **PAGAMENTOD DOS IMPOSTOS**
     - **Imposto Sobre Serviços** ([ISS](https://iss.fortaleza.ce.gov.br/grpfor/login.seam?cid=265817))
       - Baixar as Notas Fiscais de Serviço;
       - Confirmar com o cliente quanto foi suas vendas de serviços;
       - Apuração do ISS sobre Venda de Serviços;
       - Emissão dos boletos de pagamento;
       - Envio dos boletos para a caixa postal do cliente
       - Confirmar com os clientes se o mesmo recebeu os boletos.

       - **NOTAS**
         - _Total de clientes que recolhem ISS_:
           - Ativos:
           - Inativos:
         - _Total de horas gastas no processo_:
           - Ativos:
           - Inativos:

     - **Guia de Pagamento do Simples Nacional** ([PGDAS](http://www8.receita.fazenda.gov.br/SimplesNacional/Servicos/Grupo.aspx?grp=t&area=1))
       - Baixar as Notas Fiscais de Serviço Prestados;
       - Baixar as Notas Fiscais de Serviço Tomados;
       - Baixar as Notas Fiscais de Saídas;
       - Baixar as Notas Fiscais de Entras;

       - Confirmar com o cliente quanto foi suas vendas de serviços;
       - Confirmar com o cliente quanto foi suas vendas de Mercadorias;

       - Apuração do PGDAS sobre Venda de Serviços e Mercadorias;

       - Emissão dos boletos de pagamento do PGDAS;

       - Envio dos boletos do PGDAS para a caixa postal do cliente

       - Confirmar com os clientes se o mesmo recebeu o boleto.

       - **NOTAS**
         - _Total de clientes do Simples Nacional_:
           - Ativos:
           - Inativos:
         - _Total de horas gastas no processo_:
           - Ativos:
           - Inativos:

     - **Guia de Pagamento do Micro Empreendedor Individual** (PGMAI)
       - Baixar as Notas Fiscais de Serviço Prestados;
       - Baixar as Notas Fiscais de Serviço Tomados;
       - Baixar as Notas Fiscais de Saídas;
       - Baixar as Notas Fiscais de Entras;
         F
       - Apuração do PGMAI;

       - Emissão dos boletos de pagamento do PGMAI;

       - Envio dos boletos do PGMAI para a caixa postal do cliente;

       - Confirmar com os clientes se o mesmo recebeu o boleto.

       - **NOTAS**
         - _Total de clientes do PGMAI_:
           - Ativos:
           - Inativos:
         - _Total de horas gastas no processo_:
           - Ativos:
           - Inativos:


     - **Guia de Pagamento do ICMS Normal** (DAE-Normal)
       - Baixar as Notas Fiscais de Saídas;
       - Baixar as Notas Fiscais de Entradas;

       - Confirmar com o cliente quanto foi suas vendas de Mercadorias;

       - Apuração do DAE-Normal sobre Venda de Mercadorias;

       - Emissão dos boletos de pagamento do DAE-Normal;
       - Emissão do relatórios do icms Normal;

       - Envio dos boletos do DAE-Normal e do relatório de ICMS Nomral
         para a caixa postal do cliente.

       - Confirmar com os clientes se o mesmo recebeu o boleto.

       - **NOTAS**
         - _Total de clientes do DAE-Normal_:
           - Ativos:
           - Inativos:
         - _Total de horas gastas no processo_:
           - Ativos:
           - Inativos:


     - **Guia de Pagamento do ICMS Substituto** (DAE-ST)
       - Baixar as Notas Fiscais de Entradas;
       - Apuração do DAE-ST;


       - Emissão dos boletos de pagamento do DAE-ST;
       - Emissão do relatórios do icms Subtituto;

       - Envio dos boletos do DAE-ST e do relatório de ICMS Substtituto
         para a caixa postal do cliente;

       - Confirmar com os clientes se o mesmo recebeu o boleto.

       - **NOTAS**
         - _Total de clientes do DAE-ST_:
           - Ativos:
           - Inativos:
         - _Total de horas gastas no processo_:
           - Ativos:
           - Inativos:

   - **INTEGRAÇÃO COM A CONTABILIDADE**
     - Exportar para a contabilidade.
       Obs: O Módulo fiscal que exporta
       e o Renovato parametriza.



}

