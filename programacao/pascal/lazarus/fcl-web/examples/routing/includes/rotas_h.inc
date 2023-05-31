//Head das rotas a serem executadas pelo Browser.

{: A procedure @name adiciona na lista L os link das rotas registradas}
Procedure DumpRoutes(L : TStrings; AURL : String);

{: A procedure @name envia para o Browser um página HTML prenchida com os parametros passados por: **RouteParams** }
Procedure RequestToResponse(ATitle : String; ARequest : TRequest; AResponse : TResponse; RouteParams : Array of String);

Procedure RequestToResponse(ATitle : String; ARequest : TRequest; AResponse : TResponse);

{: A procedure @name implementa a rota **Simple callback** :

   - DESCRIÇÃO:
     - Executa a procedure RequestToResponse('Simple callback',ARequest,AResponse);

   - PARÂMETROS
     - **ARequest**
       - Contém informações vinda do Browser;

     - **aResponse**
       - Contém informações enviadas para o Browser;

    - EXEMPLO DE USO:
      - Registro da rota /simple/:
        - HTTPRouter.RegisterRoute('simple',rmall,@SimpleCallBack);

      - Chamada do método TMyHandler.HandleRequest()
        - http://localhost:8080/simple/

}
Procedure SimpleCallBack(ARequest : TRequest; AResponse : TResponse);


Procedure ParamPathMiddle(ARequest : TRequest; AResponse : TResponse);

Procedure ParamPath(ARequest : TRequest; AResponse : TResponse);

Procedure ParamPaths2(ARequest : TRequest; AResponse : TResponse);

Procedure ComponentPath(AData : Pointer; ARequest : TRequest; AResponse : TResponse);

{: A procedure @name é executado pelo browser quando o link não tem parâmetro

   - DESCRIÇÃO:
     - A rota **'*path'** pegará todos os outros caminhos, ou seja: Se não
       informar uma rota o sistema não gera exceção.

   - EXEMPLO DE USO:
     - Registro da rota:
       - HTTPRouter.RegisterRoute('*path',rmall,@DefaultCallBack,IsDefault=True);
         - Nota:
           - Como o parâmetro IsDefault = true essa chamada deve executada após
             todos os registros das rotas da unit.

     - Chamada do Browser
       - http://localhost:8080/
}
Procedure DefaultCallBack(ARequest : TRequest; AResponse : TResponse);


