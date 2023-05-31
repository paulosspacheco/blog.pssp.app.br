program AppTRouterObject;
{:< - O projeto **@name** demonstra o uso das units **fphttpapp**, **fpcgi** e **inifiles**  .

  - **DESCRIÇÃO**
    - Este programa demonstra o uso dos parâmetros de chamada em um link do browser nos quais podem ser:
      - http://localhost:8080/simple;   
      - http://localhost:8080/component/1;
      - http://localhost:8080/component/2;      
      - http://localhost:8080/onepath/:param;
      - http://localhost:8080/twopaths/:param1/:param2;
      - http://localhost:8080/onepath/*path/new;
      - http://localhost:8080/routed/object;
      - http://localhost:8080/*path.

  - NOTAS   
    - Este projeto pode ser usado como **servidor http** porta 8080 ou
      um aplicação **CGI** para ser registrada em um servidor web.
     

  - **REFERÊNCIAS**
    - https://objectpascalprogramming.com/fpweb-hello
    - https://paulosspacheco.github.io/blog.pssp.app.br/programacao/pascal/lazarus/fcl-web/examples/routing/doc/index.html

  
  - **CÓDIGO FONTE**:
    - @html(<a href="../TRouteObject/apptrouterobject.lpr">AppTRouterObject.lpr</a>)

  - **HISTÓRICO**
    - Documento criado por: paulosspacheco@@yahoo.com.br
      - **23/03/2023** : Inicio da documentação deste código
}


{$DEFINE STANDALONE}

{$IFDEF FPC}
  {$mode Delphi}
{$ENDIF}

uses
  sysutils,
  routes,
{$IFDEF STANDALONE}
  fphttpapp,
{$ENDIF}
{$IFDEF CGI}
  fpcgi,
{$ENDIF}
  inifiles;


begin
  With TInifile.Create(ChangeFileExt(ParamStr(0),'.ini')) do
    try
      {$IFDEF CGI}
      BaseURL:=ReadString('CGI','BaseURL','');
      {$ENDIF CGI}
      {$IFDEF STANDALONE}
      Application.Port:=ReadInteger('Standalone','Port',8080);
      BaseURL:=ReadString('Standalone','BaseURL','http://localhost:'+IntToStr(Application.Port));
      {$ENDIF STANDALONE}
    finally
      Free;
    end;
  RegisterRoutes;
  Application.Initialize;
  Application.Run;
end.

