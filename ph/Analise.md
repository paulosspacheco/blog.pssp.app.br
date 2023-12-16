<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Análise do projeto ph.app.br

1. **Etapas:**
   1. Banco de dados Assistente_Virtual
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
         7. senha // String com 20 posições pode ser nulo

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

   2. Estudar como o site OpenAI pode ajudar a criar o  _Assistant API da OpenAI_.
   3. Criar rotinas para:
      1. Criar programa para coletar as informações do paciente
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

   5. **Banco de Dados de Informações Adicionais:**
         1. Criar um _banco de dados adicional_ para armazenar informações sobre _convênios_, _preços de consultas_ e _hospitais onde o médico atende_.

   6. Testes e Validação:
      1. Realizar _testes abrangentes_ para garantir o funcionamento adequado de todas as funcionalidades.

   7. **Documentação e Treinamento:**
      1. Preparar _documentação detalhada_ e _oferecer treinamento_ para o _médico_ e a _equipe_ sobre o uso da _secretária virtual_.

   8. **Manutenção e Atualização Contínua:**
       1. Criar um _plano de manutenção_ e _atualização_ para manter a segurança, eficiência e compatibilidade do sistema.

<!-- markdownlint-disable-next-line -->
</main>

[🔝🔝](#topo "Retorna ao topo")
