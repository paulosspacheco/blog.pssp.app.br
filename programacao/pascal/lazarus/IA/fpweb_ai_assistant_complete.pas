{------------------------------------------------------------------------------
  fpWeb AI Assistant com Memória Persistente + Frontend HTML
  - Servidor completo em Pascal / FPC / Lazarus
------------------------------------------------------------------------------}

program server;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, StrUtils, Math, fphttpapp, httpdefs, fpjson, jsonparser,
  fphttpclient, opensslsockets, sqlite3conn, sqldb;

const
  DB_FILE = 'memory.db';

Type
  TFloatDynArray = array of Double;

function GetEnvOrDefault(const Name, Def: String): String;
begin
  Result := GetEnvironmentVariable(Name);
  if Result = '' then Result := Def;
end;

// --- JSON helpers -----------------------------------------------------------
function ParseJSON(const S: String): TJSONData;
var P: TJSONParser;
begin
  P := TJSONParser.Create(S, [joUTF8, joStrict]);
  try
    Result := P.Parse;
  finally
    P.Free;
  end;
end;

function JGetStr(Obj: TJSONObject; const Key, Def: String = ''): String;
var D: TJSONData;
begin
  D := Obj.Find(Key);
  if (D<>nil) and (D.JSONType in [jtString, jtNumber]) then
    Result := D.AsString
  else
    Result := Def;
end;

function JGetInt(Obj: TJSONObject; const Key: String; Def: Integer = 0): Integer;
var D: TJSONData;
begin
  D := Obj.Find(Key);
  if (D<>nil) and (D.JSONType in [jtNumber]) then
    Result := D.AsInteger
  else
    Result := Def;
end;

// --- SQLite setup -----------------------------------------------------------
procedure EnsureSchema(Conn: TSQLite3Connection; Trans: TSQLTransaction);
begin
  with TSQLQuery.Create(nil) do
  try
    Database := Conn; Transaction := Trans;
    SQL.Text :=
      'CREATE TABLE IF NOT EXISTS chunks ('+
      '  id INTEGER PRIMARY KEY AUTOINCREMENT,'+
      '  doc_id TEXT,'+
      '  content TEXT,'+
      '  emb BLOB'+
      ');';
    ExecSQL;
    SQL.Text :=
      'CREATE TABLE IF NOT EXISTS chats ('+
      '  id INTEGER PRIMARY KEY AUTOINCREMENT,'+
      '  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,'+
      '  role TEXT,'+
      '  content TEXT'+
      ');';
    ExecSQL;
    Transaction.Commit;
  finally
    Free;
  end;
end;

procedure InitDB(out Conn: TSQLite3Connection; out Trans: TSQLTransaction);
begin
  Conn := TSQLite3Connection.Create(nil);
  Trans := TSQLTransaction.Create(nil);
  Conn.Transaction := Trans;
  Conn.DatabaseName := DB_FILE;
  Conn.Open; Trans.StartTransaction;
  EnsureSchema(Conn, Trans);
end;

// --- Embeddings via API (OpenAI-compatible) --------------------------------
function HTTPPostJSON(const URL, Bearer, Payload: String): String;
var C: TFPHTTPClient;
begin
  C := TFPHTTPClient.Create(nil);
  try
    C.AddHeader('Content-Type','application/json');
    if Bearer<>'' then C.AddHeader('Authorization','Bearer '+Bearer);
    Result := C.SimpleFormPost(URL, Payload);
  finally
    C.Free;
  end;
end;

function CallEmbeddingsAPI(const BaseURL, APIKey, Model, InputText: String): TFloatDynArray;
var Payload, Resp: String; J, DataArr, VecArr: TJSONData; I: Integer;
begin
  SetLength(Result, 0);
  Payload := '{"model":"'+Model+'","input":'+JSONEncode(InputText)+'}';
  Resp := HTTPPostJSON(IncludeTrailingPathDelimiter(BaseURL)+'embeddings', APIKey, Payload);
  J := GetJSON(Resp);
  try
    DataArr := (J as TJSONObject).Find('data');
    if (DataArr<>nil) and (DataArr.JSONType=jtArray) then begin
      VecArr := (DataArr as TJSONArray).Objects[0].Find('embedding');
      if (VecArr<>nil) and (VecArr.JSONType=jtArray) then begin
        SetLength(Result, (VecArr as TJSONArray).Count);
        for I := 0 to High(Result) do
          Result[I] := (VecArr as TJSONArray).Floats[I];
      end;
    end;
  finally
    J.Free;
  end;
end;

function DotProduct(const A,B: TFloatDynArray): Double;
var i: Integer; s: Double;
begin
  s := 0; for i:=0 to Min(High(A),High(B)) do s += A[i]*B[i];
  Result := s;
end;

function Norm(const A: TFloatDynArray): Double;
var i: Integer; s: Double;
begin
  s := 0; for i:=0 to High(A) do s += Sqr(A[i]);
  Result := Sqrt(s);
end;

function CosineSim(const A,B: TFloatDynArray): Double;
var na, nb: Double;
begin
  na := Norm(A); nb := Norm(B);
  if (na=0) or (nb=0) then Exit(0);
  Result := DotProduct(A,B)/(na*nb);
end;

procedure SaveChunk(Conn: TSQLite3Connection; Trans: TSQLTransaction;
                    const DocID, Content: String; const Emb: TFloatDynArray);
var Q: TSQLQuery; ms: TMemoryStream; i: Integer; d: Double;
begin
  ms := TMemoryStream.Create;
  try
    for i:=0 to High(Emb) do begin d := Emb[i]; ms.WriteBuffer(d, SizeOf(Double)); end;
    ms.Position := 0;
    Q := TSQLQuery.Create(nil);
    try
      Q.Database := Conn; Q.Transaction := Trans;
      Q.SQL.Text := 'INSERT INTO chunks (doc_id, content, emb) VALUES (:d,:c,:e)';
      Q.Params.ParamByName('d').AsString := DocID;
      Q.Params.ParamByName('c').AsString := Content;
      Q.Params.ParamByName('e').LoadFromStream(ms, ftBlob);
      Q.ExecSQL; Trans.Commit; Trans.StartTransaction;
    finally
      Q.Free;
    end;
  finally
    ms.Free;
  end;
end;

function LoadEmbFromField(Field: TField): TFloatDynArray;
var ms: TMemoryStream; d: Double;
begin
  ms := TMemoryStream.Create;
  try
    TBlobField(Field).SaveToStream(ms); ms.Position := 0;
    SetLength(Result, ms.Size div SizeOf(Double));
    if Length(Result)>0 then
      ms.ReadBuffer(Result[0], ms.Size);
  finally
    ms.Free;
  end;
end;

function RetrieveTopK(Conn: TSQLite3Connection; Trans: TSQLTransaction;
                      const QueryEmb: TFloatDynArray; K: Integer): TStringList;
var Q: TSQLQuery; sl: TStringList; scores: array of Double; embs: array of TFloatDynArray;
    i: Integer; bestIdx: Integer; bestScore: Double;
begin
  sl := TStringList.Create; sl.OwnsObjects := False;
  Q := TSQLQuery.Create(nil);
  try
    Q.Database := Conn; Q.Transaction := Trans;
    Q.SQL.Text := 'SELECT id, content, emb FROM chunks';
    Q.Open;
    SetLength(embs, 0);
    while not Q.EOF do begin
      SetLength(embs, Length(embs)+1);
      embs[High(embs)] := LoadEmbFromField(Q.FieldByName('emb'));
      sl.AddObject(Q.FieldByName('content').AsString, TObject(Q.FieldByName('id').AsInteger));
      Q.Next;
    end;
    SetLength(scores, sl.Count);
    for i:=0 to sl.Count-1 do scores[i] := CosineSim(QueryEmb, embs[i]);
    Result := TStringList.Create; Result.OwnsObjects := False;
    for i:=1 to K do begin
      bestIdx := -1; bestScore := -1;
      if Length(scores)=0 then Break;
      for var j:=0 to High(scores) do if scores[j]>bestScore then begin bestScore:=scores[j]; bestIdx:=j; end;
      if bestIdx=-1 then Break;
      Result.Add(sl[bestIdx]);
      scores[bestIdx] := -2;
    end;
  finally
    Q.Free; sl.Free;
  end;
end;

function ChunkText(const S: String; MaxTokens: Integer = 500): TStringList;
var words: TStringArray; i, curCount: Integer; cur: String;
begin
  Result := TStringList.Create;
  words := S.Split([' ', #10, #13, #9]);
  cur := ''; curCount := 0;
  for i:=0 to High(words) do begin
    if words[i] = '' then Continue;
    if curCount >= MaxTokens then begin
      Result.Add(Trim(cur)); cur := ''; curCount := 0;
    end;
    cur += words[i] + ' '; Inc(curCount);
  end;
  if Trim(cur)<>'' then Result.Add(Trim(cur));
end;

function CallChatAPI(const BaseURL, APIKey, Model: String; Messages: TJSONArray): String;
var Payload, Resp: String; J: TJSONData; Choices, MsgObj: TJSONData;
begin
  Payload := '{"model":'+JSONEncode(Model)+',"messages":'+Messages.AsJSON+'}';
  Resp := HTTPPostJSON(IncludeTrailingPathDelimiter(BaseURL)+'chat/completions', APIKey, Payload);
  J := GetJSON(Resp);
  try
    Choices := (J as TJSONObject).Find('choices');
    if (Choices<>nil) and (Choices.JSONType=jtArray) then begin
      MsgObj := (Choices as TJSONArray).Objects[0].FindPath('message.content');
      if (MsgObj<>nil) then Exit(MsgObj.AsString);
    end;
    Result := '[ERRO] Resposta inesperada do provedor: ' + Resp;
  finally
    J.Free;
  end;
end;

procedure AppendChat(Conn: TSQLite3Connection; Trans: TSQLTransaction;
                     const Role, Content: String);
var Q: TSQLQuery;
begin
  Q := TSQLQuery.Create(nil);
  try
    Q.Database := Conn; Q.Transaction := Trans;
    Q.SQL.Text := 'INSERT INTO chats (role, content) VALUES (:r,:c)';
    Q.Params.ParamByName('r').AsString := Role;
    Q.Params.ParamByName('c').AsString := Content;
    Q.ExecSQL; Trans.Commit; Trans.StartTransaction;
  finally
    Q.Free;
  end;
end;
