<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# api rest

## O que é api rest stateless

1. O conceito de "stateless" em uma API REST significa que cada chamada da API deve ser independente e não deve depender de chamadas anteriores. Em outras palavras, o servidor não mantém nenhum estado de cliente entre as requisições. Cada requisição do cliente deve conter todas as informações necessárias para o servidor entender e processar essa requisição.

## Significado de Stateless

1. _Independência de Requisições_: Cada requisição é autossuficiente e deve incluir todas as informações necessárias para o processamento.
2. _Escalabilidade_: Facilita a escalabilidade horizontal (adicionando mais servidores) porque qualquer servidor pode atender qualquer requisição sem a necessidade de compartilhamento de estado.
3. _Simplicidade_: Reduz a complexidade do servidor, pois não precisa gerenciar o estado das sessões de clientes.

# Como Implementar uma API Stateless

1. _Autenticação_:
   1. Utilize tokens, como JSON Web Tokens (JWT), que são enviados em cada requisição, geralmente através do cabeçalho Authorization: Bearer \<token\>.
2. _Mensagens Completas_:
   1. As requisições devem conter todas as informações necessárias, como parâmetros, cabeçalhos, e corpo da mensagem (payload).
3. _Idempotência_:
   1. As operações devem ser _idempotentes_ quando possível, especialmente para métodos HTTP como GET, PUT, DELETE.
   2. _Obs_:
      1. Idempotência é um conceito fundamental em sistemas distribuídos e APIs REST. Refere-se à propriedade de certas operações que podem ser executadas múltiplas vezes sem alterar o resultado além da primeira aplicação. Em outras palavras, uma operação idempotente produzirá o mesmo efeito, independentemente de quantas vezes for executada.
         1. Características da Idempotência:
            1. Repetição Segura: Executar a mesma operação várias vezes não altera o estado do sistema após a primeira execução.
            2. Consistência: Garante que a operação produz um resultado consistente e previsível.
            3. Facilita Recuperação de Falhas: Em casos de falha na comunicação, a operação pode ser repetida sem preocupação de efeitos colaterais adversos.

## Exemplo Prático Usando Free Pascal

1. Exemplo simples de como se implementar uma API REST stateless usando FPWeb.

   ```pascal

        program StatelessAPI;

        {$mode objfpc}{$H+}

        uses
          fphttpapp, fpweb, HTTPDefs;

        type
          TMyRESTModule = class(TFPWebModule)
            private
              procedure HandleGetRequest(Sender: TObject; ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);
            public
          end;

        procedure TMyRESTModule.HandleGetRequest(Sender: TObject; ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);
          var
            authToken: string;
        begin
            // Check for authorization token in the request header
            authToken := ARequest.GetHeader('Authorization');
            if authToken = 'Bearer mysecrettoken' then
            begin
                AResponse.ContentType := 'application/json';
                AResponse.Contents.Text := '{"message": "Hello, World!"}';
            end
            else
            begin
                AResponse.Code := 401; // Unauthorized
                AResponse.Contents.Text := '{"error": "Unauthorized"}';
            end;
            Handled := True;
        end;

        var
          Application: TFPHTTPApplication;
          Module: TMyRESTModule;

        begin
            Application := TFPHTTPApplication.Create(nil);
            try
                Module := TMyRESTModule.Create(nil);
                Module.OnRequest := @Module.HandleGetRequest;
                Application.Initialize;
                Application.Run;
            finally
                Application.Free;
            end;
        end.

   ```

</main>

[🔝🔝](#topo "Retorna ao topo")

