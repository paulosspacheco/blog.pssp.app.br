- [Análise do projeto ph.app.br](#análise-do-projeto-phappbr)
<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Análise do projeto ph.app.br

- [Análise do projeto ph.app.br](#análise-do-projeto-phappbr)
  - [Infraestrutura necessária](#infraestrutura-necessária)
  - [Definição do banco de dados Assistente\_Virtual](#definição-do-banco-de-dados-assistente_virtual)
  - [Estudar como o site OpenAI pode ajudar a criar o  _Assistant API da OpenAI_](#estudar-como-o-site-openai-pode-ajudar-a-criar-o--assistant-api-da-openai)
  - [Criar API de comunicação com o banco de dados](#criar-api-de-comunicação-com-o-banco-de-dados)
  - [Banco de Dados de Informações Adicionais](#banco-de-dados-de-informações-adicionais)
  - [Testes e Validação:](#testes-e-validação)
  - [Documentação e Treinamento:](#documentação-e-treinamento)
  - [Manutenção e Atualização Contínua:](#manutenção-e-atualização-contínua)

## Infraestrutura necessária
  
1. **Criar máquina virtual _LinuxMint-ph_ com tudo que precisamos para o projeto;**
   1. Criar usuário _phdemelo_ e dar permissões de administrador; ✅
      1. adm
      2. cdrom
      3. dip
      4. lpadmin
      5. phpaulo
      6. plugdev
      7. sambashare
      8. sudo
      9. xrdp

   2. Instalar _xrdp_ e abrir para acesso publico para poder operar quando não estivermos próximo ao servidor. ✅

   3. Ao tentar compartilhar para acesso publico tive que contratar um _IP fixo_ _45.160.125.12_ e contratar o plano _300 mega_ da Smart Soluções; ✅

   4. Instalar _PostgresSQL_ e abrir para acesso publico; ✅

   5. Criar o banco de dados _assistente_virtual_; ✅
      1. Criar documento: [Como trocar a senha do banco _postgreSQL_ no linux caso se esqueça?](http://127.0.0.1:5502/infraestrutura/linux/banco_de_dados/posgresql/o_que_e_postgresql.html#id_assunto04)

   6. Fazer backup do banco de dados _assistente_virtual_.

   7. Instalar cliente de banco de dados _dbeaver-ce_ para executar os script sql do projeto na criação e manutenção do banco de dados. ✅

   8. Instalar _Servidor Web Apache2_ e abrir para acesso publico para poder publicar os _Serviço Rest_ para que a IA tenha acesso;

   9. Instalar _IDE Lazarus_ e o compilador _free pascal_ para criar programas de cadastros e relatórios das tabelas do banco de dados. ✅

   10. Criar _Serviço Rest_ para comunicar-se com a inteligência artificial.

   11. Instalar o interpretador _python_ para estudo do Paulo Henrique; ✅

   12. Compartilhar a pasta _user/local/Lazarus_ para que eu possa usar na minha máquina a mesma versão do Lazarus que vou usar na máquina do Paulo Henrique. ✅

## Definição do banco de dados Assistente_Virtual

1. operadores //Pode ser a secretária virtual
   1. id // tipo Integer serial
   2. nome // String com 50 posições não pode ser nulo
   3. telefone : // String com 20 posições

2. hospitais
   1. id // tipo Integer serial
   2. nome // String com 50 posições pode ser nulo
   3. telefone // String com 20 posições pode ser nulo

3. status_da_agenda_ou_consulta
   1. id // tipo Integer serial
   2. nome // String com 20 posições pode ser nulo

4. médicos
   1. id // tipo Integer serial
   2. id_operadores //Tipo Integer
   3. nome // String com 50 posições pode ser nulo
   4. telefone // String com 25 posições pode ser nulo
   5. telefone_da_secretaria // String com 25 posições pode ser nulo
   6. login // String com 50 posições pode ser nulo
   7. se>nha // String com 20 posições pode ser nulo

5. serviço_de_agendas
   1. id // tipo Integer serial
   2. id_operador // tipo Integer
   3. nome // String com 100 posições pode ser nulo
   4. login // String com 50 posições pode ser nulo
   5. senha // String com 50 posições pode ser nulo

6. convênios
   1. id  // tipo Integer serial
   2. id_médico // tipo Integer
   3. nome  // String com 50 posições pode ser nulo
   4. login // String com 50 posições pode ser nulo
   5. senha // String com 50 posições pode ser nulo

7. clientes
   1. id // tipo Integer serial
   2. nome // String com 50 posições. Obs: Não pode ser nulo
   3. telefone_whatsApp;// String com 25 posições. Obs: pode ser nulo
   4. e_mail // String com 50 posições e pode ser nulo
   5. login  // String com 50 posições e não pode ser nulo
   6. senha  // String com 20 posições e não pode ser nulo
   7. id_convênio // tipo Integer pode ser nulo
   8. dataTime_disponível // Tipo da data e pode ser nulo. Obs: Usado para pesquisar na agenda uma data mais próxima
   9. matricula_no_convênio // String com 50 posições e pode ser nulo.

8. integração // Usado para ser logar
   1. id // tipo Integer serial
   2. endereço_do_site // String com 255 posições e não pode ser nulo
   3. login // String com 50 posições e não pode ser nulo. Obs: Login para acessar o endereço_do_site
   4. senha // String com 20 posições e não pode ser nulo. Obs: Senha para acessar o endereço_do_site
   5. status // Campo lógico e não pode ser nulo Obs: Usado para saber o se o site está conectado

9. expediente_do_medico_data // Chave múltipla id_medico+Data
   1. id // tipo Integer serial
   2. id_medico // tipo Integer  e não pode ser nulo
   3. dataTime // tipo data e não pode ser nulo

10. expediente_do_medico_horas // Chave múltipla id_medico+Data+Hora_inicial
    1. id_expediente_do_medico_data // tipo Integer e não pode ser nulo
    2. dataTime_inicial // Data e Hora inicial  do expediente do médico e não pode ser nulo
    3. dataTime_final   // Data e Hora final do expediente do médico e não pode ser nulo

11. agenda
    1. id // tipo Integer serial
    2. id_Medico // tipo Integer  e não pode ser nulo
    3. id_Cliente // tipo Integer  e não pode ser nulo
    4. dataTime  // Data e hora prevista da consulta e não pode ser nulo
    5. dataTime_confirmação // Data e hora da confirmação  da consulta e não pode ser nulo
    6. id_convênio //tipo Integer e pode ser nulo caso id_formas_de_pagamento não for nulo.
    7. id_status_da_agenda_ou_consulta //tipo Integer e não pode ser nulo
    8. id_formas_de_pagamento //tipo Integer e pode ser nulo caso id_convênio não for nulo.
    9. dataTime // Data e hora em que a agenda foi criada e não pode ser nulo
    10. observações // String com 255 posições e pode ser nulo

12. formas_de_pagamento
    1. id // tipo Integer serialNatureza
    2. Nome // String com 30 posições e não pode ser nulo. Obs: Pode ser: 0 - Dinheiro; 1 - Pix; 2 - Convênio; 3 - Cartão de debito; 4 - Catão de credito Mastercard; 5 - Catão de credito Visa;  etc....

13. consulta //Usado para baixar baixar a agenda
    1. id // tipo Integer serial
    2. id_agenda  // tipo Integer e pode ser nulo. Obs: Uma consulta não é obrigado ter agenda.
    3. id_cliente // tipo Integer e não pode ser nulo.
    4. id_medico  // tipo Integer e não pode ser nulo.
    5. dataTime   // Data e hora da consulta e não pode ser nulo
    6. id_convênio // tipo Integer e pode ser nulo. Obs: Uma consulta não é obrigado ter convênio
    7. id_forma_de_pagamento // tipo Integer e pode ser nulo se id_convênio não for nulo.
    8. id_status_da_agenda_ou_consulta // tipo Integer e não pode ser nulo
    9. Observação // String com 255 posições e pode ser nulo

## Estudar como o [site OpenAI](https://platform.openai.com/docs/overview) pode ajudar a criar o  _Assistant API da OpenAI_

 1. Checar se é possível comunicar-se com a IA usando o compilador free pascal; ✅
    1. _Nota_:
       1. Projeto _CHATGPT_ criado por _Marcelo Maurin Martins_ e está disponível no [github](https://github.com/marcelomaurin/CHATGPT);
       2. Projeto [DelphiOpenAI](https://github.com/HemulGM/DelphiOpenAI) criado por HemulGM com licença _MIT_.
          1. [Readme do projeto](https://github.com/HemulGM/DelphiOpenAI/blob/main/README.md)

 2. A IA precisa de _[chave de autenticação](https://platform.openai.com/docs/api-reference/authentication)_ onde a mesma pode ser adquirida [_aqui_](https://platform.openai.com/api-keys);

 3. A _IA_ comunica-se com o programa por meio de prompts, usando a linguagem _JSON_ para receber um pedido do usuário e a resposta é retornada com outro _JSON_ com dados que o programa precisa para continuar o diálogo.
    1. Exemplo 01:
       1. Vamos criar algumas especificações de função para fazer interface com uma _API climática hipotética_.
          1. Passaremos essas especificações de função para a _API_ de conclusões de bate-papo para gerar argumentos de função que sigam a especificação.

            ```json

               tools = [
                  {
                     "type": "function",
                     "function": {
                           "name": "get_current_weather",
                           "description": "Obtenha o clima atual",
                           "parameters": {
                              "type": "object",
                              "properties": {
                                 "location": {
                                       "type": "string",
                                       "description": "A cidade e o estado, por ex. São Francisco, Califórnia",
                                 },
                                 "format": {
                                       "type": "string",
                                       "enum": ["celsius", "fahrenheit"],
                                       "description": "A unidade de temperatura a ser usada. Inferir isso a partir da localização dos usuários.",
                                 },
                              },
                              "required": ["location", "format"],
                           },
                     }
                  },
                  {
                     "type": "function",
                     "function": {
                           "name": "get_n_day_weather_forecast",
                           "description": "Obtenha uma previsão do tempo para N dias",
                           "parameters": {
                              "type": "object",
                              "properties": {
                                 "location": {
                                       "type": "string",
                                       "description": "A cidade e o estado, por ex. São Francisco, Califórnia",
                                 },
                                 "format": {
                                       "type": "string",
                                       "enum": ["celsius", "fahrenheit"],
                                       "description": "A unidade de temperatura a ser usada. Inferir isso a partir da localização dos usuários.",
                                 },
                                 "num_days": {
                                       "type": "integer",
                                       "description": "O número de dias para previsão",
                                 }
                              },
                              "required": ["location", "format", "num_days"]
                           },
                     }
                  },
               ] 

            ```

    2. Exemplos:
       1. Linguagem python:
          1. [Como chamar funções com modelos de chat](https://cookbook.openai.com/examples/how_to_call_functions_with_chat_models)
          2. 

 4. **Referências:**
    1. [api-reference](https://platform.openai.com/docs/api-reference)
    2. [developer-quickstart](https://platform.openai.com/docs/quickstart/developer-quickstart)
    3. [Introduction API OpenAi](https://platform.openai.com/docs/api-reference/introduction)
    4. [Developer-quickstart](https://platform.openai.com/docs/quickstart/developer-quickstart)
    5. [python-library](https://platform.openai.com/docs/libraries/python-library)
    6. [typescript-javascript-library](https://platform.openai.com/docs/libraries/typescript-javascript-library)
    7. [community.openai.com](https://community.openai.com/)
    8. [step-1-setup-curl](https://platform.openai.com/docs/quickstart/step-1-setup-curl)
    9. [Adding your API client to the Community Libraries page](https://help.openai.com/en/articles/6684216-adding-your-api-client-to-the-community-libraries-page)
    10. [Melhores práticas para engenharia imediata com API OpenAI](https://help.openai.com/en/articles/6654000-best-practices-for-prompt-engineering-with-openai-api)
    11. [Referência da API - Solicitar corpo](https://platform.openai.com/docs/api-reference/completions/create)
    12. [Como contar tokens com tiktoken](https://cookbook.openai.com/examples/how_to_count_tokens_with_tiktoken)
    13. [DelphiOpenAI](https://github.com/HemulGM/DelphiOpenAI)
    14. [incrível-chatgpt](https://github.com/uhub/awesome-chatgpt)
        1. Obs:
           1. Esse documento mostrou-me:
              1. Biblioteca [DelphiOpenAI](https://github.com/HemulGM/DelphiOpenAI) completa para comunicação com _chatgpt_,
              2. [Dicas sobre chatgpt-prompts](https://github.com/f/awesome-chatgpt-prompts)
    15. .

## Criar API de comunicação com o banco de dados

1. **Tecnologias usadas no projeto**:
   1. Linguagem free pascal
      1. IDE Lazarus
      2. Pacotes
         1. LCL
            1. Para edição de formulários gráficos
         2. fcl-web
            1. Para comunicação com protocolo HTTP
         3. Maricarai
            1. Para criação de formulários LCL e HTML
         4. CHATGPT-main
            1. Usado para comunicação com chatgpt
   2. Linguagem javascript
      1. Editor VsCode
         1. Usado para editar o javascript que vou usar na IDE Lazaros
   3. Objeto JSON
      1. Editor VsCode
         1. Usado para editar o JSON que vou usar na IDE Lazaros
   4. Python
      1. Editor VsCode
         1. Só prendendo usar essa linguagem caso não consiga fazer com pascal.

2. **Criar pasta _avm_ onde _A_=Assistente, _V_=Virtual e _M_=Médicos**
   1. Criar pasta _avm/dm_ onde _D_=Data e _M_=module ✅  
      1. Nesta pasta deve ser registrada todo processamento que não dependa de componentes visuais;
         1. Criar datamodule _DM_Connections_ para concentrar as conexões com o banco de dados;
         2. Criar datamodule _DM_operador_ para consultas para incluir, alterar e excluir a tabela de operadores;
         3. Criar datamodule  _DM_hospitais_ para consultas para incluir, alterar e excluir a tabela de hospitais;
         4. Criar datamodule  _DM_status_da_agenda_ou_consulta_ para consultas para incluir, alterar e excluir a tabela de status_da_agenda_ou_consulta;
         5. Criar datamodule  _DM_medicos_ para consultas para incluir, alterar e excluir a tabela de médicos;
         6. Criar datamodule  _DM_serviço_de_agendas_ para consultas para incluir, alterar e excluir a tabela de serviço_de_agendas;
         7. Criar datamodule  _DM_convenios_ para consultas para incluir, alterar e excluir a tabela de convênios;
         8. Criar datamodule  _DM_clientes_ para consultas para incluir, alterar e excluir a tabela de clientes;
         9. Criar datamodule  _DM_integracao_  para consultas para incluir, alterar e excluir a tabela de integração ;
         10. Criar datamodule  _DM_expediente_do_medico_data_  para consultas para incluir, alterar e excluir a tabela de expediente_do_medico_data ;
         11. Criar datamodule  _DM_expediente_do_medico_horas_ para consultas para incluir, alterar e excluir a tabela de expediente_do_medico_horas;
         12. Criar datamodule  _DM_agenda_ para consultas para incluir, alterar e excluir a tabela de agenda;
         13. Criar datamodule  _DM_formas_de_pagamento_ para consultas para incluir, alterar e excluir a tabela de formas_de_pagamento;
         14. Criar datamodule  _DM_consulta_  para consultas para incluir, alterar e excluir a tabela de consulta;
         15. Criar datamodule _DM_Main_ para concentrar todos os datamodule do projeto;

3. **Criar pasta _lcl_ onde _L_=Lazarus, _C_=Component e _L_=Library**
   1. Criar pasta _avm/lcl_
      1. Criar projeto de nome _avm_lcl_;
      2. Criar pasta _avm/lcl/units_
         1. Nesta pasta deve ficar todos os formulários que dependem do pacote _lcl_
            1. Criar formulário _TForm_Main_ para edição de todos os formulário do projeto:
            2. Criar formulário _TForm_model_ para o modelo básico de um formulário _CRUD_ que possa ser herdado;
               1. Adicionar os componentes: (obs: Checar se posso aproveitar o form básico que criei para o gcic vcl.)
                  1. Class Panel;
                  2. Class Menu;
                  3. OnEventLogin;
                  4. OnEvent????
                  5. Criar menu de opções

            3. Criar formulário modelo básico de um formulário crud mestre/detalhe que possa ser herdado;
               1. Pensar....
            4. Criar formulário _TForm_operado_r edição da tabela de operadores;
            5. Criar formulário _TForm_hospitais_ edição da tabela de hospitais;
            6. Criar formulário _TForm_status_da_agenda_ou_consulta_ edição da tabela de status_da_agenda_ou_consulta;
            7. Criar formulário _TForm_medicos_ edição da tabela de médicos;
            8. Criar formulário _TForm_serviço_de_agendas_ edição da tabela de serviço_de_agendas;
            9. Criar formulário _TForm_convenios_ edição da tabela de convênios;
            10. Criar formulário _TForm_clientes_ edição da tabela de clientes;
            11. Criar formulário _TForm_integracao_  edição da tabela de integração ;
            12. Criar formulário _TForm_expediente_do_medico_data_  edição da tabela de expediente_do_medico_data ;
            13. Criar formulário _TForm_expediente_do_medico_horas_ edição da tabela de expediente_do_medico_horas;
            14. Criar formulário _TForm_agenda_ edição da tabela de agenda;
            15. Criar formulário _TForm_formas_de_pagamento_ edição da tabela de formas_de_pagamento;
            16. Criar formulário _TForm_consulta_  edição da tabela de consulta;
   2. 
4. **Criar programa para coletar as informações do paciente**
   1. Obs?
      1. Quais textos utilizar para interagir com o cliente no WhatsApp?
         1. Podemos usar a IA para textos humanizados.
         2. Outras forma é fazer perguntas e o cliente responde com o número da opção.

   2. Cadastros necessários para comunicar-se com os clientes:
      1. Medico
      2. Convênio
      3. Serviço_de_agendas
      4. Integração
      5. Expediente_do_medico_data
      6. Expediente_do_medico_horas
   3. Criar programa para confirmações de consultas.
      1. Cadastros atualizados aqui:
         1. clientes
         2. Agenda
         3. Disponibilidade_do_Paciente

   4. **Confirmação de Consultas:**
          1. Utilize a _API do WhatsApp_ para enviar 
          2. Implementar a _API de voz da OpenAI_ para fazer _chamadas de voz automatizadas_ para _confirmação de consultas_.

## Banco de Dados de Informações Adicionais

 1. Criar um _banco de dados adicional_ para armazenar informações sobre _convênios_, _preços de consultas_ e _hospitais onde o médico atende_.

## Testes e Validação:

 1. Realizar _testes abrangentes_ para garantir o funcionamento adequado de todas as funcionalidades.

## Documentação e Treinamento:

 1. Preparar _documentação detalhada_ e _oferecer treinamento_ para o _médico_ e a _equipe_ sobre o uso da _secretária virtual_.

## Manutenção e Atualização Contínua:

1. Criar um _plano de manutenção_ e _atualização_ para manter a segurança, eficiência e compatibilidade do sistema.

<!-- markdownlint-disable-next-line -->
</main>

[🔝🔝](#topo "Retorna ao topo")
