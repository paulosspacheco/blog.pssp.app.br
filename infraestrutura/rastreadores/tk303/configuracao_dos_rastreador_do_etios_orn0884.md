<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Configuração dos rastreadores do étios orn0884

## Dados do aparelho

  1. Manual do tk303
    1. <https://cdn.awsli.com.br/78/78556/arquivos/Manual_TKs.pdf>

## Dados do fornecedor m2m

  1. **Nome:** Wisley vende chip m2m no Maracanaú
  2. **telefone:** 85 9 8189 8440

## Sites de rastreamento

  1. [TrackHome](http://www.gpstrackerxy.com/Login.aspx?Server=1)
     1. **Vídeos aulas**
        1. [Como adicionar sub usuários](https://www.youtube.com/watch?v=IyEjTOv4Rf4)

## étios - placa: orn0884
  
 1. **Dados para conexão com o chip m2m**
    1. **Telefone vivo:** 62-9 9604 3182
       1. **Site da operadora:** transmeet.br
       2. **Imei:** 864 893 033 858 450
       3. **site TRACKHOME:** <http://www.gpstrackerxy.com/Login.aspx?Server=1>
          1. **IP:** 103.39.235.8
          2. **Porta:** 9000

 2. **Dados necessários para enviar por sms para o rastreador tk303:**
    1. Para cada comando enviado por sms abaixo, espere o rastreador responder time ok! ou aguarde 1 minuto  para enviar a próxima mensagem:
       1. Reset do rastreador _(Enviar SMS "begin + senha" para a unidade, ele irá responder "begin ok" e inicializar todas as configurações para as configurações padrão de fábrica (senha padrão: 123456).)_
          1. Reset rastreador:
             1. Enviar SMS **begin123456** (minúsculas)

       2. Configurar time zone.
          1. Enviar SMS **time zone123456 -3** (minúsculas)

       3. GPRS Definição _(O usuário deve enviar SMS via telefone celular para configurar APN, IP ea porta antes de iniciar rastreamento por GPRS)_
           1. Configurar APN
              1. Enviar sms **apn123456 transmeet.br**  (minúsculas)

           2. Configurar UP _( Enviar SMS "up + senha + espaço + espaço + usuário + senha", Se bem sucedida, "de usuário, senha ok!" É devolvido pelo rastreador em SMS.)_
              1. Enviar sms **up123456 vivo vivo** (minúsculas)

           3. IP e port Setup _( Enviar SMS comando "adminip123456 202.104.150.75 9000" para o dispositivo rastreador, se conseguiu ", adminip OK" é retornado pelo dispositivo em SMS. (123456 é a senha padrão, é 103.39.235.78 IP, 9000 é a porta). Menos tráfego 6,)_
              1. Enviar sms **adminip123456 103.39.235.8 9000** (minúsculas)

           4. Configurar para acesso a GPRS
              1. Enviar SMS **gprs123456**  (minúsculas)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")
