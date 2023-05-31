unit routes;
{:< - A Unit **@name** demonstra o uso da unit **httproute** .

  - **DESCRIÇÃO**
    -

    - **REFERÊNCIAS**
      -

  - **NOTAS**
    -

  - **CÓDIGO FONTE**:
    - @html(<a href="../units/routes.pas">routes.pas</a>)

  - **HISTÓRICO**
    - Documento criado por: paulosspacheco@@yahoo.com.br
      - **23/03/2023** : Inicio da documentação deste código
}

{$mode objfpc}{$H+}

interface

uses
 sysutils,
 classes,
 httpdefs,
 httproute;

Var
  BaseURL : String;

Procedure RegisterRoutes;

{$I ../includes/rotas_h.inc}


implementation

uses webutil, fphttp;

Type
  { TMyIntf }
  TMyIntf = Class(TObject,IRouteInterface)
  public
    procedure HandleRequest(ARequest: TRequest; AResponse: TResponse);
  end;


Var
  C1,C2 : TComponent;
  MyIntf : TMyIntf;

{$I ../includes/rotas.inc}

{ TMyIntf }

procedure TMyIntf.HandleRequest(ARequest: TRequest; AResponse: TResponse);
begin
  RequestToResponse('Interface object',ARequest,AResponse);
end;

Procedure RegisterRoutes;

begin
  if (C1=Nil) then
  begin
    C1:=TComponent.Create(Nil);
    C1.Name:='ComponentRoute1';
    HTTPRouter.RegisterRoute('/component/1',C1,rmall,@ComponentPath);

    C2:=TComponent.Create(Nil);
    C2.Name:='ComponentRoute2';
    HTTPRouter.RegisterRoute('/component/2',C2,rmall,@ComponentPath);

    MyIntf := TMyIntf.Create;
  end;

  HTTPRouter.RegisterRoute('simple',rmall,@SimpleCallBack);
  HTTPRouter.RegisterRoute('onepath/:param',rmall,@ParamPath);
  HTTPRouter.RegisterRoute('twopaths/:param1/:param2',rmall,@ParamPaths2);
  HTTPRouter.RegisterRoute('onepath/*path/new',rmall,@ParamPathMiddle);

  HTTPRouter.RegisterRoute('/interfaced',rmall,MyIntf);

  {: A rota '*path' pegará todos os outros caminhos, ou seja: Se não
     informar uma rota o sistema não gera execeção.
     Exemplo:
       Ao digitar o endereço http://localhost:8080 seja executado
  }
  HTTPRouter.RegisterRoute('*path',rmall,@DefaultCallBack,True);

end;

begin
  FreeAndNil(C1);
  FreeAndNil(C2);
end.

