{------------------------------------------------------------------------------
  fpWeb AI Assistant com Memória Persistente + Frontend HTML
------------------------------------------------------------------------------}

program server;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, StrUtils, Math, fphttpapp, httpdefs, fpjson, jsonparser,
  fphttpclient, opensslsockets, sqlite3conn, sqldb;

const
  DB_FILE = 'memory.db';

{ ... [todo o código do servidor já existente permanece aqui] ... }

// --- WebModule ----------------------------------------------------------------

type
  TWebMod = class(TFPWebModule)
  private
    Conn: TSQLite3Connection;
    Trans: TSQLTransaction;
    BaseURL, APIKey, ChatModel, EmbModel: String;
  public
    procedure InitModule; override;
    procedure FinalizeModule; override;
    procedure HandleIngest(ARequest: TRequest; AResponse: TResponse);
    procedure HandleChat(ARequest: TRequest; AResponse: TResponse);
    procedure HandleUI(ARequest: TRequest; AResponse: TResponse);
  end;

procedure TWebMod.HandleUI(ARequest: TRequest; AResponse: TResponse);
begin
  AResponse.ContentType := 'text/html; charset=UTF-8';
  AResponse.Contents.Text :=
  '<!DOCTYPE html>'+
  '<html lang="en">'+
  '<head><meta charset="UTF-8"><title>AI Assistant</title></head>'+
  '<body>'+
  '<h1>AI Turbo Vision Assistant</h1>'+
  '<textarea id="input" rows="10" cols="80" placeholder="Digite sua pergunta ou código"></textarea><br>'+
  '<button onclick="sendMessage()">Enviar</button><br>'+
  '<pre id="response" style="border:1px solid #ccc;padding:10px;width:80%;height:300px;overflow:auto;"></pre>'+
  '<script>'+
  'async function sendMessage(){'+
  '  const msg = document.getElementById("input").value;'+
  '  const respElem = document.getElementById("response");'+
  '  const res = await fetch("/chat", {'+
  '    method: "POST",'+
  '    headers: {"Content-Type":"application/json"},'+
  '    body: JSON.stringify({message: msg})'+
  '  });'+
  '  const data = await res.json();'+
  '  respElem.textContent = data.answer;'+
  '}'+
  '</script>'+ 
  '</body></html>';
end;

procedure TWebMod.InitModule;
begin
  InitDB(Conn, Trans);
  BaseURL  := GetEnvOrDefault('AI_BASE_URL', 'http://localhost:1234/v1');
  APIKey   := GetEnvOrDefault('AI_API_KEY', '');
  ChatModel:= GetEnvOrDefault('AI_MODEL', 'gpt-4o-mini');
  EmbModel := GetEnvOrDefault('EMB_MODEL', 'text-embedding-3-small');

  // Rotas
  Actions.Add('ingest', @HandleIngest);
  Actions.Add('chat',   @HandleChat);
  Actions.Add('',       @HandleUI);  // página HTML principal
end;

{ ... [restante do código do servidor permanece igual] ... }

begin
  Application.Title := 'fpWeb AI Assistant';
  Application.Port := StrToIntDef(ParamStr(1).Replace('--port=','',[rfIgnoreCase, rfReplaceAll]), 8080);
  Application.WebModuleClass := TWebMod;
  Application.Initialize;
  Application.Run;
end.
